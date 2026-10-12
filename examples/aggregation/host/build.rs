fn main() {
    // The guests include the shared protocol module from outside their own package directories.
    println!("cargo:rerun-if-changed=../protocol.rs");
    zisk_sdk::build_program("../guest");
    zisk_sdk::build_program("../guest_agg");
}
