#!/bin/bash

source ./utils.sh

main() {
    info "▶️  Running $(basename "$0") script..."

    current_dir=$(pwd)

    current_step=1
    total_steps=8

    step "Loading environment variables..."
    load_env || return 1

    cd "${WORKSPACE_DIR}"

    step  "Cloning pil2-compiler and pil2-proofman repos..."

    # Remove existing directories if they exist
    rm -rf pil2-compiler
    rm -rf pil2-proofman

    # Clone repositories
    if [[ "$DISABLE_CLONE_REPO" == "1" ]]; then
        warn "Skipping cloning repositories as DISABLE_CLONE_REPO is set to 1"
    else
        ensure git clone https://github.com/0xPolygonHermez/pil2-compiler.git || return 1
        cd pil2-compiler
        # If PIL2_COMPILER_BRANCH is defined, check out the specified branch
        if [[ -n "$PIL2_COMPILER_BRANCH" ]]; then
            echo "Checking out branch '$PIL2_COMPILER_BRANCH' for pil2-compiler..."
            ensure git checkout "$PIL2_COMPILER_BRANCH" || return 1
        fi
        cd ..

        ensure git clone https://github.com/0xPolygonHermez/pil2-proofman.git || return 1
        cd pil2-proofman
        # If PIL2_PROOFMAN_BRANCH is defined, check out the specified branch
        if [[ -n "$PIL2_PROOFMAN_BRANCH" ]]; then
            echo "Checking out branch '$PIL2_PROOFMAN_BRANCH' for pil2-proofman..."
            ensure git checkout "$PIL2_PROOFMAN_BRANCH" || return 1
        fi
        cd ..
    fi

    step "Building Rust tools..."
    ensure cargo build --release --bin pil2c --bin venus-setup || return 1

    cd "$(get_zisk_repo_dir)"

    step "Generate fixed data..."
    ensure cargo run --release --bin arith_frops_fixed_gen || return 1
    ensure cargo run --release --bin binary_basic_frops_fixed_gen || return 1
    ensure cargo run --release --bin binary_extension_frops_fixed_gen || return 1

    step "Compiling ZisK PIL..."
    ensure cargo run --release --bin pil2c -- pil/zisk.pil \
	-I pil,"${WORKSPACE_DIR}/pil2-proofman/pil2-components/lib/std/pil",state-machines,precompiles \
	-o pil/zisk.pilout -u tmp/fixed -O fixed-to-file || return 1

    step "Generating setup..."
    cached=0
    if [[ "${USE_CACHE_SETUP}" == "1" ]]; then
        # Compute setup hash
        HASH_SUM=$(sha256sum pil/zisk.pilout tmp/fixed/*.fixed state-machines/starkstructs.json \
        | sort -k2 \
        | sha256sum \
        | awk '{print $1}' \
        | awk '{print substr($0, 1, 4) substr($0, length($0)-3)}')

        echo "Setup hash: ${HASH_SUM}"

        cache_setup_folder="${OUTPUT_DIR}/${PLATFORM}/${HASH_SUM}"

        # Check if setup file exists in cache
        if [[ -d "${cache_setup_folder}" ]]; then
            info "Found cached setup folder: ${cache_setup_folder}"
            cached=1
        else
            info "No cached setup folder found at ${cache_setup_folder}"
        fi
    fi

    if [[ ${cached} == "0" ]]; then
        if [[ ${DISABLE_RECURSIVE_SETUP} == "1" ]];  then
            info "Building non-recursive setup..."
        else
            info  "Building recursive setup..."
            # Add flags for recursive setup command
            setup_flags="-t ${WORKSPACE_DIR}/pil2-proofman/pil2-components/lib/std/pil -r"
            # Add -a flag  (aggregation) for check-setup command
        fi

        rm -rf build/provingKey
        ensure cargo run --release --bin venus-setup -- \
            -a ./pil/zisk.pilout -b build \
            -u tmp/fixed ${setup_flags} \
            -s state-machines/starkstructs.json
    fi

    if [[ ${USE_CACHE_SETUP} == "1" && ${cached} == "0" ]]; then
        info "Caching setup to ${cache_setup_folder}..."
        mkdir -p "${cache_setup_folder}"
        ensure cp -R build/provingKey "${cache_setup_folder}" || return 1
    fi

    step "Copy provingKey directory to \$HOME/.zisk directory..."
    if [[ ${cached} == "1" ]]; then
        ensure cp -R "${cache_setup_folder}/provingKey" "$HOME/.zisk" || return 1
    else
        ensure cp -R build/provingKey "$HOME/.zisk" || return 1
    fi

    step "Generate constant tree files..."
    if [[ ${DISABLE_RECURSIVE_SETUP} != "1" ]];  then
            check_setup_flags=-a
    fi
    ensure cargo-zisk check-setup $check_setup_flags || return 1

    success "ZisK setup completed successfully!"
}

main
