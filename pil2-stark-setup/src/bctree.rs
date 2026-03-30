use std::fs;
use std::io::Read;
use std::path::Path;

use anyhow::{Context, Result};
use fields::{
    Field, Goldilocks, Poseidon16, Poseidon2Constants, Poseidon8, PrimeField64,
    linear_hash_seq, poseidon2_hash,
};
use rayon::prelude::*;
use serde::Deserialize;

use crate::ntt::extend_pol;

/// Minimal subset of starkinfo.json needed for constant tree computation.
/// This avoids depending on the full `proofman-common` crate (and its C++
/// linkage) for what is a standalone setup tool.
#[derive(Deserialize)]
struct StarkInfoForTree {
    #[serde(rename = "starkStruct")]
    stark_struct: StarkStructForTree,
    #[serde(rename = "nConstants")]
    n_constants: u64,
}

#[derive(Deserialize)]
struct StarkStructForTree {
    #[serde(rename = "nBits")]
    n_bits: u64,
    #[serde(rename = "nBitsExt")]
    n_bits_ext: u64,
    #[serde(rename = "merkleTreeArity")]
    merkle_tree_arity: u64,
}

/// Build the constant polynomial Merkle tree and return the 4-element root.
///
/// This is the pure-Rust replacement for the C++ `bctree` binary. It reads
/// the raw constant polynomials from `const_path`, parses tree parameters
/// from `starkinfo_path`, extends the polynomials to the evaluation domain,
/// builds a Poseidon2 Merkle tree, and writes the root as a JSON array of
/// four u64 values to `verkey_path`.
pub fn compute_const_tree(
    const_path: &str,
    starkinfo_path: &str,
    verkey_path: &str,
) -> Result<[u64; 4]> {
    tracing::info!("Loading starkinfo from {}", starkinfo_path);
    let stark_info_json = fs::read_to_string(starkinfo_path)
        .with_context(|| format!("Failed to read starkinfo file: {starkinfo_path}"))?;
    let stark_info: StarkInfoForTree = serde_json::from_str(&stark_info_json)
        .with_context(|| format!("Failed to parse starkinfo file: {starkinfo_path}"))?;

    let n_bits = stark_info.stark_struct.n_bits as usize;
    let n_bits_ext = stark_info.stark_struct.n_bits_ext as usize;
    let n: usize = 1 << n_bits;
    let n_extended: usize = 1 << n_bits_ext;
    let n_pols = stark_info.n_constants as usize;
    let arity = stark_info.stark_struct.merkle_tree_arity;

    let expected_const_size = n * n_pols * 8; // each Goldilocks element is 8 bytes

    tracing::info!(
        "Parameters: nBits={}, nBitsExt={}, N={}, NExtended={}, nPols={}, arity={}",
        n_bits, n_bits_ext, n, n_extended, n_pols, arity
    );

    // Load constant polynomials as raw little-endian u64 array
    tracing::info!("Loading constant polynomials from {}", const_path);
    let const_bytes = read_file_exact(const_path, expected_const_size)
        .with_context(|| format!("Failed to read const file: {const_path}"))?;

    let const_pols: Vec<Goldilocks> = const_bytes
        .chunks_exact(8)
        .map(|chunk| {
            let val = u64::from_le_bytes(chunk.try_into().unwrap());
            Goldilocks::new(val)
        })
        .collect();
    assert_eq!(const_pols.len(), n * n_pols);

    // Extend polynomials to the evaluation domain
    tracing::info!("Extending constant polynomials to evaluation domain");
    let const_pols_ext = extend_pol(&const_pols, n_bits, n_bits_ext, n_pols);
    assert_eq!(const_pols_ext.len(), n_extended * n_pols);

    // Build Merkle tree.
    // The C++ code maps arity to Poseidon2 sponge width as: arity * HASH_SIZE (4).
    //   arity=2 -> sponge width 8  (Poseidon2Goldilocks<8>)
    //   arity=3 -> sponge width 12 (Poseidon2Goldilocks<12>)
    //   arity=4 -> sponge width 16 (Poseidon2Goldilocks<16>)
    tracing::info!("Building Poseidon2 Merkle tree (arity={})", arity);
    let root = match arity {
        2 => merkle_tree_gl::<Poseidon8, 8>(&const_pols_ext, n_extended, n_pols, arity),
        3 => merkle_tree_gl::<fields::Poseidon12, 12>(&const_pols_ext, n_extended, n_pols, arity),
        4 => merkle_tree_gl::<Poseidon16, 16>(&const_pols_ext, n_extended, n_pols, arity),
        _ => anyhow::bail!("Unsupported Merkle tree arity: {arity}"),
    };

    // Write verkey.json
    tracing::info!("Writing verkey to {}", verkey_path);
    let root_u64: [u64; 4] = [
        root[0].as_canonical_u64(),
        root[1].as_canonical_u64(),
        root[2].as_canonical_u64(),
        root[3].as_canonical_u64(),
    ];
    // Format verkey.json matching the legacy C++ bctree format: 4-space indent
    let verkey_json = format!(
        "[\n    {},\n    {},\n    {},\n    {}\n]\n",
        root_u64[0], root_u64[1], root_u64[2], root_u64[3]
    );
    fs::write(verkey_path, &verkey_json)
        .with_context(|| format!("Failed to write verkey file: {verkey_path}"))?;

    tracing::info!("Verkey root: {:?}", root_u64);
    Ok(root_u64)
}

/// Read a file, verifying it has exactly the expected size.
fn read_file_exact(path: &str, expected_size: usize) -> Result<Vec<u8>> {
    let p = Path::new(path);
    let metadata = fs::metadata(p)
        .with_context(|| format!("Cannot stat file: {path}"))?;
    let file_size = metadata.len() as usize;
    anyhow::ensure!(
        file_size == expected_size,
        "Const file size mismatch: expected {expected_size} bytes, got {file_size} bytes in {path}"
    );

    let mut file = fs::File::open(p)?;
    let mut buf = vec![0u8; expected_size];
    file.read_exact(&mut buf)?;
    Ok(buf)
}

/// Build a Goldilocks Poseidon2 Merkle tree and return the 4-element root.
///
/// This replicates the C++ `MerkleTreeGL::merkelize()` logic:
///   1. Hash each row of the source matrix using `linear_hash_seq` to get
///      a 4-element leaf digest.
///   2. Build a tree bottom-up: at each level, group digests by `arity`,
///      concatenate their 4-element hashes into a sponge-width input,
///      hash with Poseidon2, and take the first 4 elements as the parent digest.
fn merkle_tree_gl<C: Poseidon2Constants<W>, const W: usize>(
    source: &[Goldilocks],
    height: usize,
    width: usize,
    arity: u64,
) -> [Goldilocks; 4] {
    const HASH_SIZE: usize = 4;

    // Compute total number of node slots
    let num_nodes = compute_num_nodes(height as u64, arity) as usize;

    let mut nodes = vec![Goldilocks::ZERO; num_nodes * HASH_SIZE];

    // Hash each row to produce leaf digests (parallel)
    let leaf_area = &mut nodes[..height * HASH_SIZE];
    leaf_area
        .par_chunks_mut(HASH_SIZE)
        .enumerate()
        .for_each(|(i, dest)| {
            let row_start = i * width;
            let row = &source[row_start..row_start + width];
            let leaf_hash = linear_hash_seq::<Goldilocks, C, W>(row);
            dest.copy_from_slice(&leaf_hash[..HASH_SIZE]);
        });

    // Build tree bottom-up
    let mut pending = height as u64;
    let mut next_n = pending.div_ceil(arity);
    let mut next_index: u64 = 0;

    while pending > 1 {
        let extra_zeros = (arity - (pending % arity)) % arity;

        // Zero-fill padding slots
        if extra_zeros > 0 {
            let start = (next_index + pending * HASH_SIZE as u64) as usize;
            let end = start + (extra_zeros * HASH_SIZE as u64) as usize;
            for v in &mut nodes[start..end] {
                *v = Goldilocks::ZERO;
            }
        }

        for i in 0..next_n {
            let mut pol_input = [Goldilocks::ZERO; W];

            let child_start =
                (next_index + i * W as u64) as usize;
            let copy_len = W.min(nodes.len() - child_start);
            pol_input[..copy_len]
                .copy_from_slice(&nodes[child_start..child_start + copy_len]);

            let parent_hash = poseidon2_hash::<Goldilocks, C, W>(&pol_input);

            let parent_start =
                (next_index + (pending + extra_zeros + i) * HASH_SIZE as u64) as usize;
            nodes[parent_start..parent_start + HASH_SIZE]
                .copy_from_slice(&parent_hash[..HASH_SIZE]);
        }

        next_index += (pending + extra_zeros) * HASH_SIZE as u64;
        pending = pending.div_ceil(arity);
        next_n = pending.div_ceil(arity);
    }

    // Root is the last HASH_SIZE elements in the node buffer
    let root_start = num_nodes * HASH_SIZE - HASH_SIZE;
    let mut root = [Goldilocks::ZERO; 4];
    root.copy_from_slice(&nodes[root_start..root_start + HASH_SIZE]);
    root
}

/// Compute the total number of node slots (in units of HASH_SIZE=4 elements)
/// for a Merkle tree of the given height and arity.
fn compute_num_nodes(height: u64, arity: u64) -> u64 {
    let mut num_nodes = height;
    let mut nodes_level = height;

    while nodes_level > 1 {
        let extra_zeros = (arity - (nodes_level % arity)) % arity;
        num_nodes += extra_zeros;
        let next_n = nodes_level.div_ceil(arity);
        num_nodes += next_n;
        nodes_level = next_n;
    }

    num_nodes
}

#[cfg(test)]
mod tests {
    use super::*;
    use fields::Poseidon16;

    #[test]
    fn test_compute_num_nodes() {
        // height=8, arity=4:
        //   level 0: 8, extra=0, next=2 -> 8+0+2=10
        //   level 1: 2, extra=2, next=1 -> 10+2+1=13
        //   but nodes_level=1 exits the loop
        // Actually: 8 + 0 + 2 + 2 + 1 = 13? Let me trace:
        //   num_nodes=8, nodes_level=8
        //   iter1: extra=(4-(8%4))%4=0, next=2, num_nodes=8+0+2=10, nodes_level=2
        //   iter2: extra=(4-(2%4))%4=2, next=1, num_nodes=10+2+1=13, nodes_level=1
        //   exit
        assert_eq!(compute_num_nodes(8, 4), 13);
        assert_eq!(compute_num_nodes(1, 4), 1);
        // height=4, arity=2:
        //   num=4, level=4
        //   iter1: extra=0, next=2, num=6, level=2
        //   iter2: extra=0, next=1, num=7, level=1
        assert_eq!(compute_num_nodes(4, 2), 7);
    }

    #[test]
    fn test_merkle_tree_small() {
        let height = 4;
        let width = 2;
        let source: Vec<Goldilocks> = (0..(height * width) as u64)
            .map(Goldilocks::new)
            .collect();

        let root = merkle_tree_gl::<Poseidon16, 16>(&source, height, width, 4);

        let all_zero = root.iter().all(|x| x.as_canonical_u64() == 0);
        assert!(!all_zero, "Merkle root should not be all zeros");
    }

    #[test]
    fn test_merkle_tree_arity_2() {
        let height = 4;
        let width = 2;
        let source: Vec<Goldilocks> = (0..(height * width) as u64)
            .map(Goldilocks::new)
            .collect();

        let root = merkle_tree_gl::<Poseidon8, 8>(&source, height, width, 2);
        let all_zero = root.iter().all(|x| x.as_canonical_u64() == 0);
        assert!(!all_zero, "Merkle root should not be all zeros");
    }

    #[test]
    fn test_merkle_tree_matches_fields_partial_merkle_tree() {
        // Verify our merkle_tree_gl produces the same root as fields'
        // partial_merkle_tree when given the same leaf hashes.
        use fields::{linear_hash_seq, partial_merkle_tree, Poseidon8};

        let height = 8;
        let width = 5;
        let arity = 2u64;
        let source: Vec<Goldilocks> = (0..(height * width) as u64)
            .map(|v| Goldilocks::new(v + 100))
            .collect();

        // Compute leaf hashes manually
        let mut leaf_hashes = Vec::with_capacity(height * 4);
        for i in 0..height {
            let row = &source[i * width..(i + 1) * width];
            let h = linear_hash_seq::<Goldilocks, Poseidon8, 8>(row);
            leaf_hashes.extend_from_slice(&h[..4]);
        }

        // Use fields' partial_merkle_tree
        let expected_root =
            partial_merkle_tree::<Goldilocks, Poseidon8, 8>(&leaf_hashes, height as u64, arity);

        // Use our merkle_tree_gl
        let actual_root = merkle_tree_gl::<Poseidon8, 8>(&source, height, width, arity);

        for i in 0..4 {
            assert_eq!(
                expected_root[i].as_canonical_u64(),
                actual_root[i].as_canonical_u64(),
                "Root element {i} mismatch: fields partial_merkle_tree vs our merkle_tree_gl"
            );
        }
    }

    #[test]
    fn test_merkle_tree_matches_fields_arity_4() {
        use fields::{linear_hash_seq, partial_merkle_tree, Poseidon16};

        let height = 16;
        let width = 7;
        let arity = 4u64;
        let source: Vec<Goldilocks> = (0..(height * width) as u64)
            .map(|v| Goldilocks::new(v * 3 + 1))
            .collect();

        let mut leaf_hashes = Vec::with_capacity(height * 4);
        for i in 0..height {
            let row = &source[i * width..(i + 1) * width];
            let h = linear_hash_seq::<Goldilocks, Poseidon16, 16>(row);
            leaf_hashes.extend_from_slice(&h[..4]);
        }

        let expected_root =
            partial_merkle_tree::<Goldilocks, Poseidon16, 16>(&leaf_hashes, height as u64, arity);

        let actual_root = merkle_tree_gl::<Poseidon16, 16>(&source, height, width, arity);

        for i in 0..4 {
            assert_eq!(
                expected_root[i].as_canonical_u64(),
                actual_root[i].as_canonical_u64(),
                "Root element {i} mismatch for arity 4"
            );
        }
    }

    #[test]
    fn test_merkle_tree_deterministic() {
        // Same input should produce same root
        let height = 8;
        let width = 3;
        let source: Vec<Goldilocks> = (0..(height * width) as u64)
            .map(|v| Goldilocks::new(v + 1))
            .collect();

        let root1 = merkle_tree_gl::<Poseidon8, 8>(&source, height, width, 2);
        let root2 = merkle_tree_gl::<Poseidon8, 8>(&source, height, width, 2);

        for i in 0..4 {
            assert_eq!(
                root1[i].as_canonical_u64(),
                root2[i].as_canonical_u64(),
                "Root element {i} differs between runs"
            );
        }
    }

    #[test]
    fn test_verkey_json_byte_identical_to_golden() {
        // Verify verkey.json serialization matches golden reference byte-for-byte.
        let golden_path = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
            .join("../golden_reference/zisk/Zisk/airs/Dma/air/Dma.verkey.json");
        if !golden_path.exists() {
            eprintln!("Skipping verkey golden test: {:?} not found", golden_path);
            return;
        }
        let golden = std::fs::read_to_string(&golden_path).unwrap();

        // Parse the golden root values
        let vals: Vec<u64> = golden
            .trim()
            .trim_start_matches('[')
            .trim_end_matches(']')
            .split(',')
            .map(|s| s.trim().parse::<u64>().unwrap())
            .collect();
        assert_eq!(vals.len(), 4);

        // Re-serialize using the same format as compute_const_tree
        let rendered = format!(
            "[\n    {},\n    {},\n    {},\n    {}\n]\n",
            vals[0], vals[1], vals[2], vals[3]
        );

        assert_eq!(
            rendered, golden,
            "verkey.json serialization does not match golden reference byte-for-byte"
        );
    }
}
