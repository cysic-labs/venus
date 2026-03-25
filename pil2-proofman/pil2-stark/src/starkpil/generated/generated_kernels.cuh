// Auto-generated kernel declarations for host-side dispatch
// Each kernel is compiled in its own .cu file for optimal register allocation

// expId=136 nOps=96 nTemp1=3 nTemp3=5
__global__ void computeExpression_gen_136_(StepsParams *d_params, DeviceArguments *d_deviceArgs, ExpsArguments *d_expsArgs, DestParamsGPU *d_destParams);

// expId=186 nOps=146 nTemp1=4 nTemp3=5
__global__ void computeExpression_gen_186_(StepsParams *d_params, DeviceArguments *d_deviceArgs, ExpsArguments *d_expsArgs, DestParamsGPU *d_destParams);

// expId=212 nOps=171 nTemp1=3 nTemp3=3
__global__ void computeExpression_gen_212_(StepsParams *d_params, DeviceArguments *d_deviceArgs, ExpsArguments *d_expsArgs, DestParamsGPU *d_destParams);

// expId=239 nOps=142 nTemp1=1 nTemp3=5
__global__ void computeExpression_gen_239_(StepsParams *d_params, DeviceArguments *d_deviceArgs, ExpsArguments *d_expsArgs, DestParamsGPU *d_destParams);

// expId=265 nOps=206 nTemp1=5 nTemp3=5
__global__ void computeExpression_gen_265_(StepsParams *d_params, DeviceArguments *d_deviceArgs, ExpsArguments *d_expsArgs, DestParamsGPU *d_destParams);

// expId=302 nOps=184 nTemp1=1 nTemp3=5
__global__ void computeExpression_gen_302_(StepsParams *d_params, DeviceArguments *d_deviceArgs, ExpsArguments *d_expsArgs, DestParamsGPU *d_destParams);

// expId=319 nOps=245 nTemp1=5 nTemp3=5
__global__ void computeExpression_gen_319_(StepsParams *d_params, DeviceArguments *d_deviceArgs, ExpsArguments *d_expsArgs, DestParamsGPU *d_destParams);

// expId=347 nOps=274 nTemp1=5 nTemp3=5
__global__ void computeExpression_gen_347_(StepsParams *d_params, DeviceArguments *d_deviceArgs, ExpsArguments *d_expsArgs, DestParamsGPU *d_destParams);

// expId=437 nOps=270 nTemp1=3 nTemp3=5
__global__ void computeExpression_gen_437_(StepsParams *d_params, DeviceArguments *d_deviceArgs, ExpsArguments *d_expsArgs, DestParamsGPU *d_destParams);

// expId=479 nOps=307 nTemp1=2 nTemp3=5
__global__ void computeExpression_gen_479_(StepsParams *d_params, DeviceArguments *d_deviceArgs, ExpsArguments *d_expsArgs, DestParamsGPU *d_destParams);

// expId=482 nOps=251 nTemp1=1 nTemp3=5
__global__ void computeExpression_gen_482_(StepsParams *d_params, DeviceArguments *d_deviceArgs, ExpsArguments *d_expsArgs, DestParamsGPU *d_destParams);

// expId=51 nOps=36 nTemp1=1 nTemp3=2
__global__ void computeExpression_gen_51_(StepsParams *d_params, DeviceArguments *d_deviceArgs, ExpsArguments *d_expsArgs, DestParamsGPU *d_destParams);

// expId=518 nOps=427 nTemp1=4 nTemp3=5
__global__ void computeExpression_gen_518_(StepsParams *d_params, DeviceArguments *d_deviceArgs, ExpsArguments *d_expsArgs, DestParamsGPU *d_destParams);

// expId=632 nOps=486 nTemp1=7 nTemp3=5
__global__ void computeExpression_gen_632_(StepsParams *d_params, DeviceArguments *d_deviceArgs, ExpsArguments *d_expsArgs, DestParamsGPU *d_destParams);

// Host-side dispatch by expId
inline bool dispatchGeneratedKernel(uint64_t expId, dim3 nBlocks, dim3 nThreads, size_t sharedMem, cudaStream_t stream,
    StepsParams *d_params, DeviceArguments *d_deviceArgs, ExpsArguments *d_expsArgs, DestParamsGPU *d_destParams) {
    switch (expId) {
    case 136: computeExpression_gen_136_<<<nBlocks, nThreads, sharedMem, stream>>>(d_params, d_deviceArgs, d_expsArgs, d_destParams); return true;
    case 186: computeExpression_gen_186_<<<nBlocks, nThreads, sharedMem, stream>>>(d_params, d_deviceArgs, d_expsArgs, d_destParams); return true;
    case 212: computeExpression_gen_212_<<<nBlocks, nThreads, sharedMem, stream>>>(d_params, d_deviceArgs, d_expsArgs, d_destParams); return true;
    case 239: computeExpression_gen_239_<<<nBlocks, nThreads, sharedMem, stream>>>(d_params, d_deviceArgs, d_expsArgs, d_destParams); return true;
    case 265: computeExpression_gen_265_<<<nBlocks, nThreads, sharedMem, stream>>>(d_params, d_deviceArgs, d_expsArgs, d_destParams); return true;
    case 302: computeExpression_gen_302_<<<nBlocks, nThreads, sharedMem, stream>>>(d_params, d_deviceArgs, d_expsArgs, d_destParams); return true;
    case 319: computeExpression_gen_319_<<<nBlocks, nThreads, sharedMem, stream>>>(d_params, d_deviceArgs, d_expsArgs, d_destParams); return true;
    case 347: computeExpression_gen_347_<<<nBlocks, nThreads, sharedMem, stream>>>(d_params, d_deviceArgs, d_expsArgs, d_destParams); return true;
    case 437: computeExpression_gen_437_<<<nBlocks, nThreads, sharedMem, stream>>>(d_params, d_deviceArgs, d_expsArgs, d_destParams); return true;
    case 479: computeExpression_gen_479_<<<nBlocks, nThreads, sharedMem, stream>>>(d_params, d_deviceArgs, d_expsArgs, d_destParams); return true;
    case 482: computeExpression_gen_482_<<<nBlocks, nThreads, sharedMem, stream>>>(d_params, d_deviceArgs, d_expsArgs, d_destParams); return true;
    case 51: computeExpression_gen_51_<<<nBlocks, nThreads, sharedMem, stream>>>(d_params, d_deviceArgs, d_expsArgs, d_destParams); return true;
    case 518: computeExpression_gen_518_<<<nBlocks, nThreads, sharedMem, stream>>>(d_params, d_deviceArgs, d_expsArgs, d_destParams); return true;
    case 632: computeExpression_gen_632_<<<nBlocks, nThreads, sharedMem, stream>>>(d_params, d_deviceArgs, d_expsArgs, d_destParams); return true;
    default: return false;
    }
}
