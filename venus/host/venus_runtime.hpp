#ifndef VENUS_HOST_VENUS_RUNTIME_HPP
#define VENUS_HOST_VENUS_RUNTIME_HPP

#include <algorithm>
#include <cctype>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <limits>
#include <string>
#include <vector>

enum class ProverBackend {
    GPU,
    VENUS,
};

inline std::string normalize_backend_name(const char *value) {
    std::string backend = value == nullptr ? "" : value;
    backend.erase(
        std::remove_if(
            backend.begin(),
            backend.end(),
            [](unsigned char c) { return std::isspace(c) != 0; }),
        backend.end());
    std::transform(
        backend.begin(),
        backend.end(),
        backend.begin(),
        [](unsigned char c) { return std::tolower(c); });
    return backend;
}

inline ProverBackend get_prover_backend() {
    static const ProverBackend backend = []() {
        std::string backend_name = normalize_backend_name(std::getenv("ZISK_PROVER_BACKEND"));
        if (backend_name == "venus" || backend_name == "fpga") {
            zklog.info("Using prover backend: venus");
            return ProverBackend::VENUS;
        }
        if (!backend_name.empty() && backend_name != "gpu") {
            zklog.warning("Unknown ZISK_PROVER_BACKEND='" + backend_name + "', defaulting to gpu");
        }
        zklog.info("Using prover backend: gpu");
        return ProverBackend::GPU;
    }();
    return backend;
}

inline bool use_venus_backend() {
    if (get_prover_backend() != ProverBackend::VENUS) return false;

    static const bool venus_cpu_mode = []() {
        const char *value = std::getenv("ZISK_VENUS_CPU");
        if (value == nullptr || *value == '\0') {
            zklog.info("Venus backend using GPU-compatible runtime path (set ZISK_VENUS_CPU=1 for software emulation)");
            return false;
        }
        if (strcmp(value, "0") == 0 || strcmp(value, "false") == 0 || strcmp(value, "FALSE") == 0 ||
            strcmp(value, "off") == 0 || strcmp(value, "OFF") == 0 || strcmp(value, "no") == 0 ||
            strcmp(value, "NO") == 0) {
            zklog.info("Venus backend using GPU-compatible runtime path");
            return false;
        }
        zklog.info("Venus backend using software emulation path");
        return true;
    }();

    return venus_cpu_mode;
}

struct VenusDeviceBuffers : DeviceCommitBuffersCPU {
    uint64_t n_streams = 1;
    uint64_t n_recursive_streams = 0;
    uint64_t n_total_streams = 1;

    VenusDeviceBuffers() {
        airgroupId = std::numeric_limits<uint64_t>::max();
        airId = std::numeric_limits<uint64_t>::max();
        proofType.clear();
    }
};

inline void venus_notify_proof_done(uint64_t instance_id, const char *proof_type) {
    if (proof_done_callback != nullptr) {
        proof_done_callback(instance_id, proof_type);
    }
}

inline void venus_load_const_pols(
    DeviceCommitBuffersCPU *cpu_buffers,
    Goldilocks::Element *dst,
    const char *const_pols_path,
    uint64_t n_rows,
    uint64_t n_cols)
{
    uint64_t expected_bytes = n_rows * n_cols * sizeof(Goldilocks::Element);
    std::error_code ec;
    uint64_t file_size = std::filesystem::file_size(const_pols_path, ec);
    if (ec || file_size == expected_bytes) {
        loadFileParallel(dst, const_pols_path, expected_bytes);
        return;
    }

    std::ifstream fs(const_pols_path, std::ios::binary);
    if (!fs.is_open()) {
        zklog.error("Unable to open const pols file: " + std::string(const_pols_path));
        exitProcess();
    }

    uint64_t words_per_row = 0;
    fs.read((char *)&words_per_row, sizeof(uint64_t));
    if (!fs.good() || words_per_row == 0) {
        zklog.error("Invalid packed const pols header in file: " + std::string(const_pols_path));
        exitProcess();
    }

    std::vector<uint64_t> unpack_info(n_cols, 0);
    fs.read((char *)unpack_info.data(), n_cols * sizeof(uint64_t));
    if (!fs.good()) {
        zklog.error("Invalid packed const pols unpack info in file: " + std::string(const_pols_path));
        exitProcess();
    }

    std::vector<uint64_t> packed_data(n_rows * words_per_row, 0);
    fs.read((char *)packed_data.data(), packed_data.size() * sizeof(uint64_t));
    if (!fs.good() && !fs.eof()) {
        zklog.error("Invalid packed const pols payload in file: " + std::string(const_pols_path));
        exitProcess();
    }

    cpu_buffers->unpack_cpu(
        packed_data.data(),
        (uint64_t *)dst,
        n_rows,
        n_cols,
        words_per_row,
        unpack_info);
}

#endif
