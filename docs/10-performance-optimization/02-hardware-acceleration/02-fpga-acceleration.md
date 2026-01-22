# FPGA Acceleration

## Overview

FPGA (Field-Programmable Gate Array) acceleration offers an alternative to GPU-based proving acceleration. FPGAs provide reconfigurable hardware that can implement custom circuits optimized for specific operations. For zkVM proving, FPGAs can achieve high performance with better energy efficiency than GPUs for certain workloads. The programmable logic allows implementing custom field arithmetic, specialized hash circuits, and tailored FFT architectures.

FPGA development requires hardware design expertise and longer development cycles than GPU programming. However, the resulting implementations can achieve deterministic latency, high throughput, and excellent power efficiency. This document covers FPGA architecture, suitable operations, design considerations, and integration strategies for FPGA-accelerated proving.

## FPGA Architecture

### Programmable Logic

FPGA building blocks:

```
Look-Up Tables (LUTs):
  Implement arbitrary logic functions
  4-6 inputs typically
  Foundation of all computation

Flip-Flops (FFs):
  Store state
  Pipeline registers
  One per LUT typically

Block RAM (BRAM):
  On-chip memory blocks
  Kilobytes per block
  Dual-port access

DSP blocks:
  Hardened multiply-accumulate
  18x18 or larger multipliers
  Essential for field arithmetic
```

### Resource Hierarchy

FPGA organization:

```
Logic elements:
  Basic compute units
  Millions on large FPGAs

Clock regions:
  Localized timing domains
  Easier timing closure

I/O banks:
  Interface to external world
  Memory, network, PCIe

Hard IP:
  PCIe controllers
  Memory interfaces
  Transceivers
```

### Memory System

FPGA memory options:

```
On-chip (BRAM/URAM):
  Fast access
  Limited capacity (10s of MB)
  Many parallel ports

External DDR:
  Large capacity (GBs)
  Higher latency
  Limited bandwidth

HBM (High Bandwidth Memory):
  High-end FPGAs
  Multiple GB, high bandwidth
  Expensive
```

## Suitable Operations

### Field Arithmetic

Custom field implementations:

```
Advantages:
  Optimized for specific prime
  Custom reduction circuit
  Parallel multipliers

Implementation:
  Montgomery multiplication
  Barrett reduction
  Specialized for field size

Performance:
  Deterministic latency
  High throughput with pipelining
  Multiple operations in parallel
```

### Hash Functions

Hardcoded hash circuits:

```
Unrolled implementation:
  All rounds in hardware
  Single-cycle or few-cycle hash
  Massive parallelism

SHA-256:
  Well-suited to FPGA
  Efficient message scheduling

Poseidon:
  FPGA-friendly design
  Matrix operations in DSP blocks
```

### Number Theoretic Transform

NTT/FFT on FPGA:

```
Architecture:
  Streaming design
  Butterfly units
  On-chip memory for small transforms

Parallelism:
  Multiple butterfly units
  Concurrent transforms

Memory bandwidth:
  Often the bottleneck
  Carefully manage data flow
```

### Polynomial Commitment

Commitment acceleration:

```
Merkle tree:
  Tree of hash computations
  Highly parallel leaves
  Pipelined structure

MSM (if applicable):
  Point multiplication units
  Bucket accumulation
  Specialized for curve
```

## Design Approaches

### Streaming Architecture

Data flow design:

```
Concept:
  Data flows through pipeline
  Each stage processes and passes
  Continuous throughput

Benefits:
  High utilization
  Deterministic latency
  Natural parallelism

Implementation:
  Ready/valid handshaking
  Back-pressure handling
  FIFO buffering
```

### Systolic Arrays

Regular processing elements:

```
Structure:
  Grid of identical processing elements
  Data flows between neighbors
  Suited for matrix operations

Applications:
  NTT computation
  Matrix operations (Poseidon)
  Parallel field arithmetic
```

### Memory-Bound Design

Handling large data:

```
Challenge:
  Polynomials too large for on-chip
  External memory bandwidth limited

Solutions:
  Block processing
  Multi-pass algorithms
  Maximize memory reuse

Optimization:
  Careful data layout
  Prefetching
  Hide memory latency
```

## Resource Utilization

### DSP Block Usage

Maximizing multiplier efficiency:

```
Mapping:
  Field multiplication to DSP
  Multiple small multiplications per DSP
  Cascaded DSPs for large products

Efficiency:
  Match algorithm to DSP capabilities
  Avoid underutilizing DSPs

Trade-off:
  DSP count often limiting factor
  May use LUT-based multiply instead
```

### Memory Utilization

Efficient memory use:

```
BRAM allocation:
  Coefficient storage
  Twiddle factor tables
  Intermediate results

URAM (if available):
  Larger capacity
  Simple dual-port
  Good for large tables

External memory:
  Full polynomial storage
  Witness data
  Careful bandwidth management
```

### Logic Utilization

LUT and FF usage:

```
Control logic:
  State machines
  Addressing
  Coordination

Datapath logic:
  Arithmetic not in DSPs
  Multiplexing
  Reduction circuits

Balance:
  Keep utilization under 80%
  Leave room for routing
  Avoid timing failures
```

## Integration

### Host Communication

Connecting FPGA to CPU:

```
PCIe:
  Standard interface
  High bandwidth (32-256 Gb/s)
  Moderate latency

Memory mapping:
  FPGA memory accessible to CPU
  DMA transfers

Control:
  Register interface
  Command/status
  Interrupt handling
```

### Data Transfer

Moving data to/from FPGA:

```
Input data:
  Witness values
  Polynomial coefficients
  Control parameters

Output data:
  Commitments
  Proof components
  Results

Optimization:
  Minimize transfers
  Overlap with computation
  Batch operations
```

### Driver and Runtime

Software support:

```
Driver:
  Low-level FPGA access
  DMA management
  Interrupt handling

Runtime:
  High-level API
  Job scheduling
  Resource management

Integration:
  Prover library calls FPGA runtime
  Transparent acceleration
  Fallback to CPU
```

## Development Workflow

### Design Languages

FPGA programming:

```
HDL (Verilog/VHDL):
  Traditional approach
  Full control
  Longer development

HLS (High-Level Synthesis):
  C/C++ to hardware
  Faster development
  Less optimal results

Domain-specific:
  Specialized languages for crypto
  Constrained but productive
```

### Simulation and Testing

Verification process:

```
RTL simulation:
  Behavioral verification
  Waveform analysis
  Slow but detailed

Emulation:
  Faster than simulation
  Hardware-assisted

On-board testing:
  Real hardware
  Actual performance
  Integration testing
```

### Deployment

Production FPGA use:

```
Bitstream generation:
  Synthesis and place-and-route
  Hours to days for large designs

Programming:
  Load bitstream to FPGA
  JTAG or PCIe

Cloud FPGA:
  AWS F1, Azure, etc.
  No hardware ownership
  Pay-per-use model
```

## Performance Considerations

### Throughput vs Latency

Design trade-offs:

```
Throughput-optimized:
  Deep pipelining
  Many parallel units
  Higher resource usage

Latency-optimized:
  Shorter pipeline
  Less parallelism
  Faster single operation

zkVM proving:
  Usually throughput-focused
  Latency matters for interactive
```

### Clock Frequency

Achieving timing:

```
Target frequency:
  200-400 MHz typical
  Higher with careful design
  Limited by critical paths

Timing closure:
  Meet timing constraints
  May require design changes
  Longer build times
```

### Power Efficiency

Energy considerations:

```
FPGA advantage:
  Better perf/watt than GPU
  Custom circuits avoid waste

Power management:
  Clock gating unused blocks
  Voltage scaling
  Dynamic power down
```

## Key Concepts

- **Programmable logic**: LUTs, FFs, DSPs for custom computation
- **Streaming architecture**: Data flows through processing pipeline
- **Resource utilization**: Balancing DSPs, memory, logic
- **Host integration**: PCIe, DMA, software runtime
- **Development cycle**: HDL/HLS, simulation, deployment

## Design Considerations

### FPGA vs GPU

| FPGA | GPU |
|------|-----|
| Custom circuits | Fixed architecture |
| Better energy efficiency | Higher raw throughput |
| Deterministic latency | Variable latency |
| Longer development | Faster development |
| Lower volume cost | Higher volume cost |

### Development Trade-offs

| HDL | HLS |
|-----|-----|
| Full control | Faster iteration |
| Optimal results | Good-enough results |
| Hardware expertise needed | Software-like development |
| Longer development | Shorter development |

## Related Topics

- [GPU Proving](01-gpu-proving.md) - GPU acceleration alternative
- [Parallel Proving](../01-prover-optimization/04-parallel-proving.md) - Parallelization concepts
- [Hash Function Circuits](../../05-cryptographic-precompiles/02-hash-functions/01-sha256-circuit.md) - Hash implementations
- [Polynomial Optimization](../01-prover-optimization/02-polynomial-optimization.md) - FFT optimization

