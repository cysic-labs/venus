#include "gl64_tooling.cuh"
#include "data_layout.cuh"
#include <cstdlib>

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

    uint32_t gpuId = d_buffers->streamsData[streamId].gpuId;

    cudaSetDevice(gpuId);

    uint32_t gpuLocalId = d_buffers->gpus_g2l[gpuId];
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
