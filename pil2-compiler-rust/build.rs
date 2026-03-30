fn main() {
    println!("cargo:rerun-if-changed=../pil2-proofman/pilout/src/pilout.proto");
    let mut config = prost_build::Config::new();
    config.protoc_arg("--experimental_allow_proto3_optional");
    config
        .compile_protos(
            &["../pil2-proofman/pilout/src/pilout.proto"],
            &["../pil2-proofman/pilout/src/"],
        )
        .expect("Failed to compile pilout.proto");
}
