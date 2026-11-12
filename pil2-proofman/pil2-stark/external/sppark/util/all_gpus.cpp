// Copyright Supranational LLC
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Modified 2026 by Roger Taule: added sppark_set_visible_devices() to scope the
// GPU registry to a caller-provided device allow-list (multi-process/MPI use).

#include "gpu_t.cuh"
#include <algorithm>
#include <vector>

#if defined(__NVCC__)
# define PROP_MAJOR_MIN 7   // Volta and forward
#elif defined(__HIPCC__)
# define PROP_MAJOR_MIN 9   // CDNA/RDNA
#else
# error "unknown platform"
#endif

// Allow-list of CUDA ordinals this process may touch; empty => all devices.
static std::vector<int>& sppark_visible_ordinals()
{
    static std::vector<int> ords;
    return ords;
}

extern "C" void sppark_set_visible_devices(const int* ordinals, int n)
{
    auto& v = sppark_visible_ordinals();
    if (ordinals == nullptr || n <= 0) { v.clear(); return; }
    v.assign(ordinals, ordinals + n);
}

class gpus_t {
    std::vector<const gpu_t*> gpus;
public:
    gpus_t()
    {
        int n;
        if (cudaGetDeviceCount(&n) != cudaSuccess)
            return;

        int caller = 0;
        (void)cudaGetDevice(&caller);

        const auto& allow = sppark_visible_ordinals();
        for (int id = 0; id < n; id++) {
            if (!allow.empty() &&
                std::find(allow.begin(), allow.end(), id) == allow.end())
                continue;

            cudaDeviceProp prop;
            if (cudaGetDeviceProperties(&prop, id) == cudaSuccess &&
                prop.major >= PROP_MAJOR_MIN && prop.cooperativeLaunch) {
                (void)cudaSetDevice(id);
                gpus.push_back(new gpu_t(gpus.size(), id, prop));
            }
        }
        (void)cudaSetDevice(caller);
    }
    ~gpus_t()
    {   for (auto* ptr: gpus) delete ptr;   }

    static const auto& all()
    {
        static gpus_t all_gpus;
        return all_gpus.gpus;
    }
};

const gpu_t& select_gpu(int id)
{
    auto& gpus = gpus_t::all();
    if (gpus.size() == 0)
        CUDA_OK(cudaErrorNoDevice);
    if (id == -1) {
        int cuda_id;
        CUDA_OK(cudaGetDevice(&cuda_id));
        for (auto* gpu: gpus)
           if (gpu->cid() == cuda_id) return *gpu;
        id = 0;
    }
    // Match by CUDA ordinal: under a scoped registry, logical index != ordinal.
    for (auto* gpu: gpus)
        if (gpu->cid() == id) { gpu->select(); return *gpu; }
    // Fall back to logical index (sppark-internal callers).
    if (id < 0 || (size_t)id >= gpus.size())
        CUDA_OK(cudaErrorInvalidDevice);
    auto* gpu = gpus[id];
    gpu->select();
    return *gpu;
}

const cudaDeviceProp& gpu_props(int id)
{   return gpus_t::all()[id]->props();   }

size_t ngpus()
{   return gpus_t::all().size();   }

const std::vector<const gpu_t*>& all_gpus()
{   return gpus_t::all();   }

SPPARK_FFI bool cuda_available()
{   return gpus_t::all().size() != 0;   }

SPPARK_FFI void drop_gpu_ptr_t(gpu_ptr_t<void>& ref)
{   ref.~gpu_ptr_t();   }

#ifdef __clang__
# pragma clang diagnostic push
# pragma clang diagnostic ignored "-Wreturn-type-c-linkage"
#endif

SPPARK_FFI gpu_ptr_t<void>::by_value clone_gpu_ptr_t(const gpu_ptr_t<void>& rhs)
{   return rhs;   }

#ifdef __clang__
# pragma clang diagnostic pop
#endif

#ifdef TAKE_RESPONSIBILITY_FOR_ERROR_MESSAGE
SPPARK_FFI void drop_error_message(char *ptr)
{   free(ptr);   }
#endif
