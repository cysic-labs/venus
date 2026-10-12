#include "gl64_tooling.cuh"
#include "data_layout.cuh"
#include <algorithm>
#include <cstdio>
#include <cstdlib>
#include <limits>
#include <memory>
#include <string>
#include <unordered_map>

static bool venus_direct_registered_h2d_enabled()
{
    static int enabled = []() {
        const char *value = std::getenv("VENUS_DIRECT_REGISTERED_H2D");
        return value != nullptr && value[0] != '\0' && value[0] != '0';
    }();
    return enabled != 0;
}

static bool copy_direct_registered_h2d_if_enabled(const void *src, void *dst, uint64_t total_size, cudaStream_t stream, StreamData *stream_data = nullptr)
{
    if (!venus_direct_registered_h2d_enabled() || total_size < 16 * 1024 * 1024) return false;

    cudaPointerAttributes attrs;
    cudaError_t attrErr = cudaPointerGetAttributes(&attrs, src);
    if (attrErr != cudaSuccess) {
        cudaGetLastError();
        return false;
    }

#if CUDART_VERSION >= 10000
    if (attrs.type != cudaMemoryTypeHost) return false;
#else
    if (attrs.memoryType != cudaMemoryTypeHost) return false;
#endif

    CHECKCUDAERR(cudaMemcpyAsync(dst, src, total_size, cudaMemcpyHostToDevice, stream));
    if (stream_data != nullptr) {
        CHECKCUDAERR(cudaEventRecord(stream_data->direct_h2d_event, stream));
        stream_data->direct_h2d_event_pending = true;
    } else {
        CHECKCUDAERR(cudaStreamSynchronize(stream));
    }
    return true;
}

struct VenusConstTreeHostCacheEntry {
    std::shared_ptr<uint8_t> data;
    uint64_t size = 0;
    uint64_t last_use = 0;
};

struct VenusConstTreeHostCacheStats {
    uint64_t calls = 0;
    uint64_t hits = 0;
    uint64_t misses = 0;
    uint64_t prewarm_calls = 0;
    uint64_t prewarm_hits = 0;
    uint64_t prewarm_loaded = 0;
    uint64_t prewarm_skipped = 0;
    uint64_t skipped_filter = 0;
    uint64_t skipped_min_uses = 0;
    uint64_t evictions = 0;
    uint64_t alloc_failures = 0;
    uint64_t load_failures = 0;
    uint64_t bytes_read = 0;
    uint64_t bytes_uploaded = 0;
};

static bool venus_const_tree_host_cache_stats_enabled()
{
    static int enabled = []() {
        const char *value = std::getenv("VENUS_CONST_TREE_HOST_CACHE_STATS");
        return value != nullptr && value[0] != '\0' && value[0] != '0';
    }();
    return enabled != 0;
}

static uint64_t venus_const_tree_host_cache_capacity()
{
    static uint64_t capacity = []() -> uint64_t {
        const char *value = std::getenv("VENUS_CONST_TREE_HOST_CACHE_MB");
        if (value == nullptr || value[0] == '\0') return 0ULL;
        char *end = nullptr;
        unsigned long long mb = std::strtoull(value, &end, 10);
        if (end == value || *end != '\0') return 0ULL;
        return static_cast<uint64_t>(mb) * 1024ULL * 1024ULL;
    }();
    return capacity;
}

static uint64_t venus_const_tree_host_cache_min_uses()
{
    static uint64_t min_uses = []() -> uint64_t {
        const char *value = std::getenv("VENUS_CONST_TREE_HOST_CACHE_MIN_USES");
        if (value == nullptr || value[0] == '\0') return 1ULL;
        char *end = nullptr;
        unsigned long long parsed = std::strtoull(value, &end, 10);
        if (end == value || *end != '\0' || parsed == 0) return 1ULL;
        return static_cast<uint64_t>(parsed);
    }();
    return min_uses;
}

static bool venus_const_tree_host_cache_async_h2d_enabled()
{
    static int enabled = []() {
        const char *value = std::getenv("VENUS_CONST_TREE_HOST_CACHE_ASYNC_H2D");
        return value != nullptr && value[0] != '\0' && value[0] != '0';
    }();
    return enabled != 0;
}

static bool venus_const_tree_host_cache_enabled_for_size(uint64_t total_size)
{
    return venus_const_tree_host_cache_capacity() >= total_size && total_size >= 128ULL * 1024ULL * 1024ULL;
}

static bool venus_const_tree_host_cache_path_allowed(const char *bufferPath)
{
    const char *filters = std::getenv("VENUS_CONST_TREE_HOST_CACHE_FILTER");
    if (filters == nullptr || filters[0] == '\0') return true;

    std::string path(bufferPath);
    const char *token = filters;
    while (*token != '\0') {
        const char *next = token;
        while (*next != '\0' && *next != ',') ++next;
        if (next > token && path.find(std::string(token, static_cast<size_t>(next - token))) != std::string::npos) {
            return true;
        }
        token = (*next == ',') ? next + 1 : next;
    }
    return false;
}

static std::mutex &venus_const_tree_host_cache_mutex()
{
    static auto *mutex = new std::mutex();
    return *mutex;
}

static std::unordered_map<std::string, VenusConstTreeHostCacheEntry> &venus_const_tree_host_cache()
{
    static auto *cache = new std::unordered_map<std::string, VenusConstTreeHostCacheEntry>();
    return *cache;
}

static std::unordered_map<std::string, uint64_t> &venus_const_tree_host_cache_seen()
{
    static auto *seen = new std::unordered_map<std::string, uint64_t>();
    return *seen;
}

static uint64_t &venus_const_tree_host_cache_bytes()
{
    static auto *bytes = new uint64_t(0);
    return *bytes;
}

static uint64_t &venus_const_tree_host_cache_clock()
{
    static auto *clock = new uint64_t(0);
    return *clock;
}

static VenusConstTreeHostCacheStats &venus_const_tree_host_cache_stats()
{
    static auto *stats = new VenusConstTreeHostCacheStats();
    return *stats;
}

static void venus_const_tree_host_cache_print_stats()
{
    std::lock_guard<std::mutex> lock(venus_const_tree_host_cache_mutex());
    const VenusConstTreeHostCacheStats &stats = venus_const_tree_host_cache_stats();
    std::fprintf(stderr,
        "[VENUS_CONST_TREE_HOST_CACHE] calls=%lu hits=%lu misses=%lu skipped_filter=%lu skipped_min_uses=%lu "
        "prewarm_calls=%lu prewarm_hits=%lu prewarm_loaded=%lu prewarm_skipped=%lu "
        "evictions=%lu alloc_failures=%lu load_failures=%lu read_mib=%.1f uploaded_mib=%.1f resident_mib=%.1f capacity_mib=%.1f entries=%zu min_uses=%lu\n",
        stats.calls,
        stats.hits,
        stats.misses,
        stats.skipped_filter,
        stats.skipped_min_uses,
        stats.prewarm_calls,
        stats.prewarm_hits,
        stats.prewarm_loaded,
        stats.prewarm_skipped,
        stats.evictions,
        stats.alloc_failures,
        stats.load_failures,
        stats.bytes_read / 1048576.0,
        stats.bytes_uploaded / 1048576.0,
        venus_const_tree_host_cache_bytes() / 1048576.0,
        venus_const_tree_host_cache_capacity() / 1048576.0,
        venus_const_tree_host_cache().size(),
        venus_const_tree_host_cache_min_uses());
}

static void venus_const_tree_host_cache_register_stats_printer()
{
    static bool registered = []() {
        if (venus_const_tree_host_cache_stats_enabled()) {
            std::atexit(venus_const_tree_host_cache_print_stats);
        }
        return true;
    }();
    (void)registered;
}

uint32_t prewarm_const_tree_host_cache_path(const char *bufferPath, uint64_t total_size)
{
    if (!venus_const_tree_host_cache_enabled_for_size(total_size) || bufferPath == nullptr) return 0;

    venus_const_tree_host_cache_register_stats_printer();

    std::string key = std::string(bufferPath) + "#" + std::to_string(total_size);
    const bool collect_stats = venus_const_tree_host_cache_stats_enabled();

    {
        std::lock_guard<std::mutex> lock(venus_const_tree_host_cache_mutex());
        VenusConstTreeHostCacheStats *stats = collect_stats ? &venus_const_tree_host_cache_stats() : nullptr;
        if (stats != nullptr) stats->prewarm_calls++;

        if (!venus_const_tree_host_cache_path_allowed(bufferPath)) {
            if (stats != nullptr) stats->prewarm_skipped++;
            return 0;
        }

        auto &cache = venus_const_tree_host_cache();
        if (cache.find(key) != cache.end()) {
            if (stats != nullptr) stats->prewarm_hits++;
            return 1;
        }
    }

    uint8_t *raw_data = nullptr;
    cudaError_t err = cudaHostAlloc(&raw_data, total_size, cudaHostAllocPortable);
    if (err != cudaSuccess) {
        cudaGetLastError();
        if (collect_stats) {
            std::lock_guard<std::mutex> lock(venus_const_tree_host_cache_mutex());
            venus_const_tree_host_cache_stats().alloc_failures++;
        }
        return 0;
    }

    if (!loadFileParallel(raw_data, bufferPath, total_size, false, 0)) {
        CHECKCUDAERR(cudaFreeHost(raw_data));
        if (collect_stats) {
            std::lock_guard<std::mutex> lock(venus_const_tree_host_cache_mutex());
            venus_const_tree_host_cache_stats().load_failures++;
        }
        return 0;
    }

    std::shared_ptr<uint8_t> data(raw_data, [](uint8_t *ptr) {
        if (ptr != nullptr) CHECKCUDAERR(cudaFreeHost(ptr));
    });

    {
        std::lock_guard<std::mutex> lock(venus_const_tree_host_cache_mutex());
        VenusConstTreeHostCacheStats *stats = collect_stats ? &venus_const_tree_host_cache_stats() : nullptr;
        auto &cache = venus_const_tree_host_cache();
        if (cache.find(key) != cache.end()) {
            if (stats != nullptr) stats->prewarm_hits++;
            return 1;
        }

        uint64_t capacity = venus_const_tree_host_cache_capacity();
        while (venus_const_tree_host_cache_bytes() + total_size > capacity && !cache.empty()) {
            auto evict_it = cache.begin();
            uint64_t oldest = std::numeric_limits<uint64_t>::max();
            for (auto entry_it = cache.begin(); entry_it != cache.end(); ++entry_it) {
                if (entry_it->second.last_use < oldest) {
                    oldest = entry_it->second.last_use;
                    evict_it = entry_it;
                }
            }
            venus_const_tree_host_cache_bytes() -= evict_it->second.size;
            cache.erase(evict_it);
            if (stats != nullptr) stats->evictions++;
        }

        VenusConstTreeHostCacheEntry entry;
        entry.data = data;
        entry.size = total_size;
        entry.last_use = ++venus_const_tree_host_cache_clock();
        cache.emplace(key, entry);
        venus_const_tree_host_cache_bytes() += total_size;
        auto &seen = venus_const_tree_host_cache_seen();
        seen[key] = std::max(seen[key], venus_const_tree_host_cache_min_uses());

        if (stats != nullptr) {
            stats->bytes_read += total_size;
            stats->prewarm_loaded++;
        }
    }

    return 1;
}

static bool copy_const_tree_from_host_cache_if_enabled(
    DeviceCommitBuffers* d_buffers,
    const char* bufferPath,
    void* dst,
    uint64_t total_size,
    uint64_t streamId)
{
    if (!venus_const_tree_host_cache_enabled_for_size(total_size) || bufferPath == nullptr) return false;

    venus_const_tree_host_cache_register_stats_printer();

    uint32_t gpuId = d_buffers->streamsData[streamId].gpuId;
    cudaStream_t stream = d_buffers->streamsData[streamId].stream;
    std::string key = std::string(bufferPath) + "#" + std::to_string(total_size);
    std::shared_ptr<uint8_t> data;
    const bool collect_stats = venus_const_tree_host_cache_stats_enabled();

    {
        std::lock_guard<std::mutex> lock(venus_const_tree_host_cache_mutex());
        VenusConstTreeHostCacheStats *stats = collect_stats ? &venus_const_tree_host_cache_stats() : nullptr;
        if (stats != nullptr) stats->calls++;

        if (!venus_const_tree_host_cache_path_allowed(bufferPath)) {
            if (stats != nullptr) stats->skipped_filter++;
            return false;
        }

        auto &seen = venus_const_tree_host_cache_seen();
        uint64_t seen_count = ++seen[key];
        if (seen_count < venus_const_tree_host_cache_min_uses()) {
            if (stats != nullptr) stats->skipped_min_uses++;
            return false;
        }

        auto &cache = venus_const_tree_host_cache();
        auto it = cache.find(key);
        if (it == cache.end()) {
            uint64_t capacity = venus_const_tree_host_cache_capacity();
            while (venus_const_tree_host_cache_bytes() + total_size > capacity && !cache.empty()) {
                auto evict_it = cache.begin();
                uint64_t oldest = std::numeric_limits<uint64_t>::max();
                for (auto entry_it = cache.begin(); entry_it != cache.end(); ++entry_it) {
                    if (entry_it->second.last_use < oldest) {
                        oldest = entry_it->second.last_use;
                        evict_it = entry_it;
                    }
                }
                venus_const_tree_host_cache_bytes() -= evict_it->second.size;
                cache.erase(evict_it);
                if (stats != nullptr) stats->evictions++;
            }

            uint8_t *raw_data = nullptr;
            cudaError_t err = cudaHostAlloc(&raw_data, total_size, cudaHostAllocPortable);
            if (err != cudaSuccess) {
                cudaGetLastError();
                if (stats != nullptr) stats->alloc_failures++;
                return false;
            }

            if (!loadFileParallel(raw_data, bufferPath, total_size, false, 0)) {
                CHECKCUDAERR(cudaFreeHost(raw_data));
                if (stats != nullptr) stats->load_failures++;
                return false;
            }

            data = std::shared_ptr<uint8_t>(raw_data, [](uint8_t *ptr) {
                if (ptr != nullptr) CHECKCUDAERR(cudaFreeHost(ptr));
            });

            VenusConstTreeHostCacheEntry entry;
            entry.data = data;
            entry.size = total_size;
            entry.last_use = ++venus_const_tree_host_cache_clock();
            it = cache.emplace(key, entry).first;
            venus_const_tree_host_cache_bytes() += total_size;
            if (stats != nullptr) {
                stats->bytes_read += total_size;
                stats->misses++;
            }
        } else {
            it->second.last_use = ++venus_const_tree_host_cache_clock();
            data = it->second.data;
            if (stats != nullptr) stats->hits++;
        }
    }

    cudaSetDevice(gpuId);
    const bool async_h2d = venus_const_tree_host_cache_async_h2d_enabled();
    if (async_h2d) {
        d_buffers->streamsData[streamId].const_tree_h2d_keepalives.push_back(data);
    }
    CHECKCUDAERR(cudaMemcpyAsync(dst, data.get(), total_size, cudaMemcpyHostToDevice, stream));
    if (!async_h2d) {
        CHECKCUDAERR(cudaStreamSynchronize(stream));
    }

    if (collect_stats) {
        std::lock_guard<std::mutex> lock(venus_const_tree_host_cache_mutex());
        venus_const_tree_host_cache_stats().bytes_uploaded += total_size;
    }
    return true;
}

void wait_direct_registered_h2d(DeviceCommitBuffers* d_buffers, uint64_t streamId)
{
    StreamData &stream_data = d_buffers->streamsData[streamId];
    if (!stream_data.direct_h2d_event_pending) return;
    CHECKCUDAERR(cudaEventSynchronize(stream_data.direct_h2d_event));
    stream_data.direct_h2d_event_pending = false;
}

// Kernel to convert row-major layout to tiled layout
// Uses blockIdx.x for rows (which can be very large) and blockIdx.y for cols
__global__ void fromRowMajorToTiled(
    const uint64_t nRows,
    const uint64_t nCols,
    const uint64_t* __restrict__ input,
    uint64_t* __restrict__ output
) {
    uint64_t row = blockIdx.x * blockDim.x + threadIdx.x;
    uint64_t col = blockIdx.y * blockDim.y + threadIdx.y;

    if (row < nRows && col < nCols) {
        uint64_t inputOffset = row * nCols + col;
        uint64_t outputOffset = getBufferOffset(row, col, nRows, nCols);
        output[outputOffset] = input[inputOffset];
    }
}

void copy_to_device_in_chunks(
    DeviceCommitBuffers* d_buffers,
    const void* src,
    void* dst,
    uint64_t total_size,
    uint64_t streamId,
    TimerGPU &timer
    ){
    if (total_size == 0) return;

    uint32_t gpuId = d_buffers->streamsData[streamId].gpuId;

    cudaSetDevice(gpuId);

    uint32_t gpuLocalId = d_buffers->gpus_g2l[gpuId];
    cudaStream_t stream = d_buffers->streamsData[streamId].stream;
    std::lock_guard<std::mutex> lock(d_buffers->mutex_pinned[gpuLocalId]);

    if (copy_direct_registered_h2d_if_enabled(src, dst, total_size, stream, &d_buffers->streamsData[streamId])) return;

    uint64_t block_size = d_buffers->pinned_size;
    Goldilocks::Element *pinned_buffer = d_buffers->pinned_buffer[gpuLocalId];
    Goldilocks::Element *pinned_buffer_extra = d_buffers->pinned_buffer_extra[gpuLocalId];

    uint64_t nBlocks = (total_size + block_size - 1) / block_size;

    Goldilocks::Element *pinned_buffer_temp;
    
    uint64_t copySizeBlock = std::min(block_size, total_size);
    std::memcpy(pinned_buffer_extra, (const uint8_t*)src, copySizeBlock);

    for (uint64_t i = 1; i < nBlocks; ++i) {
        CHECKCUDAERR(cudaStreamSynchronize(stream));

        pinned_buffer_temp = pinned_buffer;
        pinned_buffer = pinned_buffer_extra;
        pinned_buffer_extra = pinned_buffer_temp;

        uint64_t copySizeBlockPrev = std::min(block_size, total_size - (i - 1) * block_size);

        CHECKCUDAERR(cudaMemcpyAsync(
            (uint8_t*)dst + (i - 1) * block_size,
            pinned_buffer,
            copySizeBlockPrev,
            cudaMemcpyHostToDevice,
            stream));

        uint64_t copySizeBlock = std::min(block_size, total_size - i * block_size);
        std::memcpy(pinned_buffer_extra, (const uint8_t*)src + i * block_size, copySizeBlock);
    }

    CHECKCUDAERR(cudaStreamSynchronize(stream));
    
    uint64_t copySizeBlockFinal = std::min(block_size, total_size - (nBlocks - 1) * block_size);
    
    CHECKCUDAERR(cudaMemcpyAsync(
        (uint8_t*)dst + (nBlocks - 1) * block_size,
        pinned_buffer_extra,
        copySizeBlockFinal,
        cudaMemcpyHostToDevice,
        stream
    ));

    CHECKCUDAERR(cudaStreamSynchronize(stream));
}

void copy_to_device_in_chunks(
    const uint8_t* src,
    uint8_t* dst,
    uint64_t total_size_bytes,
    uint8_t* pinnedBuffer,
    uint64_t pinnedBufferSize,
    cudaStream_t stream
){
    if (total_size_bytes == 0) return;

    if (copy_direct_registered_h2d_if_enabled(src, dst, total_size_bytes, stream)) return;

     uint64_t block_size = pinnedBufferSize/2;
    
    uint8_t *pinned_buffer = pinnedBuffer;
    uint8_t *pinned_buffer_extra = (uint8_t *)pinnedBuffer + block_size;
    uint64_t nBlocks = (total_size_bytes + block_size - 1) / block_size;

    uint8_t *pinned_buffer_temp;
    
    uint64_t copySizeBlock = std::min(block_size, total_size_bytes);
    std::memcpy(pinned_buffer_extra, (const uint8_t*)src, copySizeBlock);

    for (uint64_t i = 1; i < nBlocks; ++i) {
        CHECKCUDAERR(cudaStreamSynchronize(stream));

        pinned_buffer_temp = pinned_buffer;
        pinned_buffer = pinned_buffer_extra;
        pinned_buffer_extra = pinned_buffer_temp;

        uint64_t copySizeBlockPrev = std::min(block_size, total_size_bytes - (i - 1) * block_size);

        CHECKCUDAERR(cudaMemcpyAsync(
            (uint8_t*)dst + (i - 1) * block_size,
            pinned_buffer,
            copySizeBlockPrev,
            cudaMemcpyHostToDevice,
            stream));

        uint64_t copySizeBlock = std::min(block_size, total_size_bytes - i * block_size);
        std::memcpy(pinned_buffer_extra, (const uint8_t*)src + i * block_size, copySizeBlock);
    }

    CHECKCUDAERR(cudaStreamSynchronize(stream));
    
    uint64_t copySizeBlockFinal = std::min(block_size, total_size_bytes - (nBlocks - 1) * block_size);
    
    CHECKCUDAERR(cudaMemcpyAsync(
        (uint8_t*)dst + (nBlocks - 1) * block_size,
        pinned_buffer_extra,
        copySizeBlockFinal,
        cudaMemcpyHostToDevice,
        stream
    ));

    CHECKCUDAERR(cudaStreamSynchronize(stream));

}

void load_and_copy_to_device_in_chunks(
    DeviceCommitBuffers* d_buffers,
    const char* bufferPath,
    void* dst,
    uint64_t total_size,
    uint64_t streamId
    ){
    if (total_size == 0) return;

    uint32_t gpuId = d_buffers->streamsData[streamId].gpuId;

    cudaSetDevice(gpuId);

    uint32_t gpuLocalId = d_buffers->gpus_g2l[gpuId];
    if (copy_const_tree_from_host_cache_if_enabled(d_buffers, bufferPath, dst, total_size, streamId)) return;

    std::lock_guard<std::mutex> lock(d_buffers->mutex_pinned[gpuLocalId]);
    
    uint64_t block_size = d_buffers->pinned_size;
    
    cudaStream_t stream = d_buffers->streamsData[streamId].stream;
    Goldilocks::Element *pinned_buffer = d_buffers->pinned_buffer[gpuLocalId];
    Goldilocks::Element *pinned_buffer_extra = d_buffers->pinned_buffer_extra[gpuLocalId];

    uint64_t nBlocks = (total_size + block_size - 1) / block_size;

    Goldilocks::Element *pinned_buffer_temp;

    loadFileParallel_block(pinned_buffer_extra, bufferPath, block_size, true, 0);

    for (uint64_t i = 1; i < nBlocks; ++i) {
        CHECKCUDAERR(cudaStreamSynchronize(stream));

        pinned_buffer_temp = pinned_buffer;
        pinned_buffer = pinned_buffer_extra;
        pinned_buffer_extra = pinned_buffer_temp;

        uint64_t copySizeBlockPrev = std::min(block_size, total_size - (i - 1) * block_size);
        CHECKCUDAERR(cudaMemcpyAsync(
            (uint8_t*)dst + (i - 1) * block_size,
            pinned_buffer,
            copySizeBlockPrev,
            cudaMemcpyHostToDevice,
            stream));
        
        loadFileParallel_block(pinned_buffer_extra, bufferPath, block_size, true, i);
    }

    CHECKCUDAERR(cudaStreamSynchronize(stream));

    uint64_t copySizeBlockFinal = std::min(block_size, total_size - (nBlocks - 1) * block_size);

    CHECKCUDAERR(cudaMemcpyAsync(
        (uint8_t*)dst + (nBlocks - 1) * block_size,
        pinned_buffer_extra,
        copySizeBlockFinal,
        cudaMemcpyHostToDevice,
        stream
    ));

    CHECKCUDAERR(cudaStreamSynchronize(stream));
}
