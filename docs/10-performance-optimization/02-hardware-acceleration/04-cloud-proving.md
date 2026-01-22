# Cloud Proving

## Overview

Cloud proving leverages cloud computing resources for zkVM proof generation. Cloud platforms provide access to powerful hardware (many-core CPUs, GPUs, FPGAs) without capital investment, enabling flexible scaling based on proving demand. Organizations can spin up proving infrastructure for peak loads and scale down during quiet periods. Cloud proving also enables geographic distribution for latency optimization and redundancy.

Effective cloud proving requires understanding cloud pricing models, instance types, and deployment strategies. The goal is minimizing cost while meeting latency requirements. This document covers cloud architecture, instance selection, cost optimization, and deployment strategies for cloud-based zkVM proving.

## Cloud Architecture

### Compute Options

Available cloud compute resources:

```
CPU instances:
  General purpose (c-series)
  Compute optimized
  High memory
  Bare metal options

GPU instances:
  NVIDIA A100, H100, V100
  Multiple GPUs per instance
  NVLink for GPU-to-GPU

FPGA instances:
  AWS F1 (Xilinx)
  Azure with Intel FPGAs
  Specialized workloads
```

### Network Architecture

Cloud networking:

```
Within availability zone:
  Low latency (<1ms)
  High bandwidth (up to 100 Gbps)
  Placement groups for optimization

Cross availability zone:
  Higher latency (1-2ms)
  Lower effective bandwidth
  Redundancy benefit

Cross region:
  Higher latency (tens of ms)
  Disaster recovery
  Geographic distribution
```

### Storage Options

Cloud storage for proving:

```
Instance storage:
  NVMe SSDs attached to instance
  High IOPS, low latency
  Ephemeral (lost on termination)

EBS/Persistent disk:
  Survives instance termination
  Lower performance
  Snapshot capability

Object storage (S3/GCS):
  Proof and input storage
  High durability
  Higher latency
```

## Instance Selection

### CPU Instance Sizing

Choosing CPU instances:

```
Factors:
  Core count (parallelization)
  Memory size (large traces)
  Memory bandwidth (FFT-heavy)

Recommendations:
  Memory-bound: High memory instances
  Compute-bound: Compute-optimized
  Both: Balanced instances

Examples (AWS):
  c7i.24xlarge: 96 vCPU, 192 GB RAM
  r7i.24xlarge: 96 vCPU, 768 GB RAM
  c7i.metal: Bare metal, 192 cores
```

### GPU Instance Sizing

Choosing GPU instances:

```
Factors:
  GPU memory (polynomial size)
  GPU count (parallelism)
  GPU type (compute capability)

Recommendations:
  Large proofs: Multi-GPU instances
  Small proofs: Single GPU sufficient
  Latency-sensitive: Fastest GPU type

Examples (AWS):
  p4d.24xlarge: 8× A100, 320 GB GPU RAM
  g5.48xlarge: 8× A10G, more cost-effective
```

### Spot vs On-Demand

Instance pricing models:

```
On-demand:
  Pay per hour
  No commitment
  Highest price
  Always available

Spot instances:
  60-90% discount
  Can be interrupted
  Good for batch proving
  Need interruption handling

Reserved:
  Committed usage
  30-60% discount
  Predictable workloads
```

## Deployment Strategies

### Autoscaling

Dynamic capacity management:

```
Scaling triggers:
  Queue depth (proofs waiting)
  CPU/GPU utilization
  Time-based (predictable patterns)

Scaling actions:
  Add instances when busy
  Remove instances when idle
  Minimum capacity for latency

Implementation:
  Auto Scaling Groups (AWS)
  Instance Group Managers (GCP)
  VM Scale Sets (Azure)
```

### Queue-Based Architecture

Decoupling submission from proving:

```
Architecture:
  Proof requests → Queue → Prover pool

Benefits:
  Handle traffic spikes
  Decouple request rate from capacity
  Retry on failure

Implementation:
  SQS, Cloud Tasks, Azure Queue
  Priority queues for urgency
  Dead letter queues for failures
```

### Hybrid Architecture

Combining cloud and on-premise:

```
Pattern:
  Base load: On-premise hardware
  Peak load: Cloud burst

Benefits:
  Lower cost for steady state
  Flexibility for peaks

Implementation:
  VPN/Direct Connect to cloud
  Unified orchestration
  Workload routing
```

## Cost Optimization

### Right-Sizing

Matching instance to workload:

```
Analysis:
  Profile CPU/memory utilization
  Measure GPU utilization
  Identify bottlenecks

Optimization:
  Downsize underutilized instances
  Upgrade if bottlenecked
  Consider different instance families

Tools:
  CloudWatch/Monitoring
  Cost Explorer recommendations
  Third-party tools
```

### Spot Instance Strategy

Maximizing spot usage:

```
Strategies:
  Use spot for batch proving
  Mix spot and on-demand
  Multiple instance types in pool

Interruption handling:
  Checkpoint progress regularly
  Graceful shutdown on warning
  Resume from checkpoint

Spot fleets:
  Multiple instance types
  Diversification reduces interruptions
  Automatic replacement
```

### Reserved Capacity

Commitment-based savings:

```
When to reserve:
  Predictable baseline load
  Long-term proving needs
  >30% utilization of reserved

Options:
  1-year or 3-year terms
  All upfront, partial, no upfront
  Convertible vs standard

Savings plans:
  More flexible than reserved
  Compute commitment (any instance)
  Machine learning commitment (GPU)
```

### Cost Monitoring

Tracking proving costs:

```
Metrics:
  Cost per proof
  Cost per trace row
  Resource utilization

Allocation:
  Tag resources by project/customer
  Cost allocation by tag
  Chargeback/showback

Optimization:
  Review spending regularly
  Identify waste
  Automate cost controls
```

## Operational Considerations

### Reliability

Ensuring proving availability:

```
Multi-AZ deployment:
  Prover instances in multiple AZs
  Load balancing across AZs
  Automatic failover

Health checks:
  Monitor prover health
  Replace unhealthy instances
  Circuit breakers for failures

Redundancy:
  Multiple proof generation paths
  Fallback proving strategies
```

### Security

Protecting proving infrastructure:

```
Network security:
  VPC isolation
  Security groups/firewall
  Private subnets for provers

Access control:
  IAM roles for instances
  Minimal permissions
  Audit logging

Data protection:
  Encrypt data at rest
  Encrypt data in transit
  Secure key management
```

### Monitoring

Observability for cloud proving:

```
Metrics:
  Proving throughput
  Latency percentiles
  Resource utilization
  Error rates

Logging:
  Centralized log aggregation
  Structured logging
  Log retention policies

Alerting:
  Latency thresholds
  Error rate spikes
  Capacity warnings
```

## Multi-Cloud

### Provider Diversification

Using multiple cloud providers:

```
Benefits:
  Avoid vendor lock-in
  Geographic flexibility
  Pricing arbitrage
  Resilience

Challenges:
  Complexity
  Different APIs/services
  Data transfer costs

Implementation:
  Abstract cloud-specific code
  Common orchestration layer
  Workload placement optimization
```

### Edge Proving

Distributed proving locations:

```
Edge locations:
  Closer to users
  Lower latency
  May have limited capacity

Use cases:
  Latency-critical proofs
  Geographic requirements
  Regulatory compliance

Implementation:
  Edge compute services
  CDN-integrated compute
  Lightweight provers at edge
```

## Key Concepts

- **Instance selection**: Matching hardware to workload
- **Spot instances**: Cost savings with interruption risk
- **Autoscaling**: Dynamic capacity adjustment
- **Cost optimization**: Right-sizing, reservations, monitoring
- **Reliability**: Multi-AZ, health checks, redundancy

## Design Considerations

### Cost vs Latency

| Low Cost | Low Latency |
|----------|-------------|
| Spot instances | On-demand |
| Queue-based | Direct proving |
| Batch processing | Real-time |
| Right-sized | Oversized |

### Operational Complexity

| Simple | Complex |
|--------|---------|
| Single region | Multi-region |
| One provider | Multi-cloud |
| Fixed capacity | Autoscaling |
| Single instance type | Mixed fleet |

## Related Topics

- [GPU Proving](01-gpu-proving.md) - GPU acceleration in cloud
- [Distributed Proving](../../08-distributed-proving/01-distributed-architecture/01-proving-network.md) - Distributed architecture
- [Work Distribution](../../08-distributed-proving/01-distributed-architecture/02-work-distribution.md) - Workload distribution
- [Parallel Proving](../01-prover-optimization/04-parallel-proving.md) - Parallelization strategies

