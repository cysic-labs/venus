fn main() {
    println!("cargo:rerun-if-changed=../pil2-compiler/src/pilout.proto");
    let mut config = prost_build::Config::new();
    config.protoc_arg("--experimental_allow_proto3_optional");
    config
        .compile_protos(
            &["../pil2-compiler/src/pilout.proto"],
            &["../pil2-compiler/src/"],
        )
        .expect("Failed to compile pilout.proto");

    // Compile the LALRPOP grammar. process_root() looks for .lalrpop files
    // under src/ and writes the generated .rs into OUT_DIR mirroring the
    // directory structure.
    println!("cargo:rerun-if-changed=src/parser/grammar.lalrpop");
    lalrpop::process_root().expect("Failed to compile LALRPOP grammar");
}
