#ifndef VENUS_HOST_VENUS_RUNTIME_HPP
#define VENUS_HOST_VENUS_RUNTIME_HPP

#include <algorithm>
#include <cctype>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <limits>
#include <mutex>
#include <string>
#include <vector>

enum class ProverBackend {
    GPU,
    VENUS,
};

enum class VenusRuntimeMode {
    GPU_COMPATIBLE,
    FPGA_CSIM,
    CPU_EMULATION,
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

inline bool venus_env_is_false(const char *value) {
    if (value == nullptr || *value == '\0') return true;
    return strcmp(value, "0") == 0 || strcmp(value, "false") == 0 || strcmp(value, "FALSE") == 0 ||
           strcmp(value, "off") == 0 || strcmp(value, "OFF") == 0 || strcmp(value, "no") == 0 ||
           strcmp(value, "NO") == 0;
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

inline VenusRuntimeMode get_venus_runtime_mode() {
    static const VenusRuntimeMode mode = []() {
        if (get_prover_backend() != ProverBackend::VENUS) {
            return VenusRuntimeMode::GPU_COMPATIBLE;
        }

        const char *cpu_mode = std::getenv("ZISK_VENUS_CPU");
        if (cpu_mode != nullptr && *cpu_mode != '\0' && !venus_env_is_false(cpu_mode)) {
            zklog.info("Venus backend using software emulation path");
            return VenusRuntimeMode::CPU_EMULATION;
        }

        std::string mode_name = normalize_backend_name(std::getenv("ZISK_VENUS_MODE"));
        if (mode_name.empty() || mode_name == "csim" || mode_name == "fpga") {
            zklog.info("Venus backend using CSIM preflight + GPU proving runtime path");
            return VenusRuntimeMode::FPGA_CSIM;
        }
        if (mode_name == "cpu" || mode_name == "sw" || mode_name == "software") {
            zklog.info("Venus backend using software emulation path");
            return VenusRuntimeMode::CPU_EMULATION;
        }
        if (mode_name == "gpu" || mode_name == "compat" || mode_name == "gpu-compatible") {
            zklog.info("Venus backend using GPU-compatible runtime path");
            return VenusRuntimeMode::GPU_COMPATIBLE;
        }

        zklog.warning("Unknown ZISK_VENUS_MODE='" + mode_name + "', defaulting to csim");
        zklog.info("Venus backend using CSIM preflight + GPU proving runtime path");
        return VenusRuntimeMode::FPGA_CSIM;
    }();
    return mode;
}

inline bool use_venus_backend() {
    if (get_prover_backend() != ProverBackend::VENUS) return false;
    VenusRuntimeMode mode = get_venus_runtime_mode();
    return mode == VenusRuntimeMode::CPU_EMULATION;
}

inline bool venus_uses_csim() {
    return get_prover_backend() == ProverBackend::VENUS && get_venus_runtime_mode() == VenusRuntimeMode::FPGA_CSIM;
}

inline bool venus_trace_preunpacked() {
    const char *value = std::getenv("ZISK_VENUS_TRACE_PREUNPACKED");
    if (value == nullptr || *value == '\0') return false;
    return !venus_env_is_false(value);
}

inline std::filesystem::path venus_find_hls_dir() {
    std::error_code ec;
    std::filesystem::path cursor = std::filesystem::current_path(ec);
    if (!ec) {
        while (true) {
            std::filesystem::path candidate = cursor / "venus" / "hls";
            if (std::filesystem::exists(candidate / "Makefile")) {
                return candidate;
            }
            if (cursor == cursor.root_path()) break;
            cursor = cursor.parent_path();
        }
    }

    std::filesystem::path relative_candidate = std::filesystem::path("venus") / "hls";
    if (std::filesystem::exists(relative_candidate / "Makefile")) {
        return relative_candidate;
    }

    return std::filesystem::path();
}

inline bool venus_prepare_runtime() {
    if (!venus_uses_csim()) return true;

    static std::once_flag once;
    static bool ok = false;

    std::call_once(once, []() {
        std::filesystem::path hls_dir = venus_find_hls_dir();
        if (hls_dir.empty()) {
            zklog.error("Unable to locate venus/hls for CSIM runtime mode");
            ok = false;
            return;
        }

        std::string cmd = "make -C \"" + hls_dir.string() + "\" csim";
        zklog.info("Running Venus HLS C-simulation preflight: " + cmd);
        int rc = std::system(cmd.c_str());
        if (rc != 0) {
            zklog.error("Venus HLS C-simulation preflight failed with exit code " + std::to_string(rc));
            ok = false;
            return;
        }

        zklog.info("Venus HLS C-simulation preflight completed successfully");
        ok = true;
    });

    return ok;
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
