/// Standalone bctree binary for constant polynomial Merkle tree computation.
///
/// Runs in a child process from venus-setup to isolate bctree memory
/// (NTT buffers, Merkle tree nodes) from the parent's heap.
/// Usage: venus-bctree <const_path> <starkinfo_path> <verkey_path>

fn main() {
    let args: Vec<String> = std::env::args().collect();
    if args.len() != 4 {
        eprintln!("Usage: venus-bctree <const_path> <starkinfo_path> <verkey_path>");
        std::process::exit(1);
    }
    match pil2_stark_setup::bctree::compute_const_tree(&args[1], &args[2], &args[3]) {
        Ok(_root) => {}
        Err(e) => {
            eprintln!("venus-bctree error: {:#}", e);
            std::process::exit(1);
        }
    }
}
