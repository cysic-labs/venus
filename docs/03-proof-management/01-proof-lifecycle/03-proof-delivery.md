# Proof Delivery

## Overview

Proof delivery is the final stage of the proof lifecycle, responsible for returning completed proofs to clients and ensuring proofs are accessible for verification. This stage handles proof storage, client notification, retrieval mechanisms, and cleanup of expired proofs. Reliable delivery is essential - a proof that cannot be retrieved is as useless as no proof at all.

The delivery system must accommodate various client needs: some require immediate synchronous responses, others prefer asynchronous retrieval, and some need proofs archived for long-term access. The system must also handle proof caching for repeated verification requests and manage storage efficiently as proofs accumulate.

This document covers delivery mechanisms, storage strategies, client notification, and proof lifecycle management after generation.

## Delivery Mechanisms

### Synchronous Delivery

Return proof directly in response:

```
Client perspective:
  response = prove(program, inputs)
  proof = response.proof

Server process:
  1. Generate proof
  2. Include in response body
  3. Client receives proof immediately

Advantages:
  - Simple client code
  - No state management needed
  - Immediate availability

Disadvantages:
  - Client must wait entire duration
  - Connection timeout risks
  - Memory held during wait
```

### Asynchronous Retrieval

Client polls or retrieves later:

```
Client perspective:
  request_id = submit_proof_request(program, inputs)

  // Later...
  status = get_status(request_id)
  if status == COMPLETED:
    proof = retrieve_proof(request_id)

Server process:
  1. Store proof upon completion
  2. Update request status
  3. Serve proof on retrieval

Advantages:
  - Client not blocked
  - Better for long proofs
  - Retry-friendly

Disadvantages:
  - More client complexity
  - Need request tracking
  - Storage requirements
```

### Webhook Delivery

Server pushes to client:

```
Client setup:
  submit_proof_request(
    program, inputs,
    callback_url="https://client.com/proof-callback"
  )

Server process:
  1. Generate proof
  2. POST to callback URL with proof
  3. Retry on delivery failure

Callback payload:
  {
    request_id: "...",
    status: "COMPLETED",
    proof: "<base64-encoded-proof>",
    metadata: {...}
  }

Advantages:
  - No polling overhead
  - Real-time notification
  - Server pushes when ready

Disadvantages:
  - Client needs endpoint
  - Firewall/security considerations
  - Delivery reliability complexity
```

### Streaming Delivery

Stream proof as generated:

```
For very large proofs:
  1. Stream proof components as available
  2. Client assembles incrementally
  3. Enables early validation

Protocol:
  HEADER: proof metadata
  CHUNK: commitment data
  CHUNK: FRI layer 0 data
  CHUNK: FRI layer 1 data
  ...
  TRAILER: final polynomial + checksums
```

## Storage Strategies

### Temporary Storage

Short-term proof storage:

```
Purpose:
  - Buffer between generation and retrieval
  - Allow multiple retrievals
  - Handle client latency

Implementation:
  - In-memory cache for recent proofs
  - Time-limited retention
  - LRU eviction for capacity

Configuration:
  retention_time: 1 hour
  max_storage: 10 GB
  eviction_policy: LRU
```

### Persistent Storage

Long-term proof archival:

```
Purpose:
  - Audit trail
  - Re-verification
  - Compliance requirements

Implementation:
  - Object storage (S3, GCS, etc.)
  - Content-addressed naming
  - Metadata indexing

Organization:
  proofs/
    {year}/{month}/{day}/
      {proof_hash}.proof
      {proof_hash}.meta.json
```

### Distributed Storage

Multi-region proof storage:

```
Requirements:
  - High availability
  - Geographic distribution
  - Fast retrieval globally

Architecture:
  - Primary storage region
  - Replicated to secondary regions
  - CDN for retrieval acceleration

Trade-offs:
  - Storage costs multiply
  - Consistency management
  - Complexity increases
```

## Client Notification

### Status Updates

Keep clients informed:

```
Status polling:
  GET /proofs/{request_id}/status

Response:
  {
    status: "PROVING",
    progress: 0.75,
    estimated_remaining: "30s",
    started_at: "2024-01-15T10:00:00Z"
  }
```

### Event Notifications

Push status changes:

```
WebSocket:
  Connect to /ws/proofs/{request_id}
  Receive: {"event": "progress", "value": 0.5}
  Receive: {"event": "completed", "proof_url": "..."}

Server-Sent Events:
  GET /proofs/{request_id}/events
  data: {"event": "progress", "value": 0.5}
  data: {"event": "completed", "proof_url": "..."}
```

### Email/SMS Notification

For long-running proofs:

```
Configuration:
  submit_proof_request(
    program, inputs,
    notify_email="user@example.com",
    notify_sms="+1234567890"
  )

Notification:
  Subject: Proof generation complete
  Body: Your proof is ready at: {proof_url}
```

## Retrieval API

### Direct Download

Simple proof retrieval:

```
GET /proofs/{request_id}/download

Response:
  Content-Type: application/octet-stream
  Content-Disposition: attachment; filename="proof.bin"
  Content-Length: 150000
  [proof bytes]
```

### Signed URLs

Temporary access URLs:

```
GET /proofs/{request_id}/signed-url

Response:
  {
    url: "https://storage.example.com/proofs/abc123?token=xyz...",
    expires_at: "2024-01-15T11:00:00Z"
  }

Benefits:
  - Offload bandwidth to storage
  - Time-limited access
  - CDN compatible
```

### Chunked Retrieval

For very large proofs:

```
GET /proofs/{request_id}/chunks

Response:
  {
    total_size: 10000000,
    chunk_size: 1000000,
    chunks: [
      {"index": 0, "url": "..."},
      {"index": 1, "url": "..."},
      ...
    ]
  }

Client can download chunks in parallel and assemble.
```

## Proof Format

### Serialization Format

Structure of serialized proof:

```
Proof Format:
  Header (fixed size):
    - Version: 4 bytes
    - Flags: 4 bytes
    - Sizes: commitments, queries, etc.

  Commitments:
    - Trace root(s)
    - Composition root
    - Quotient root(s)
    - FRI layer roots

  Final polynomial:
    - Coefficients

  Query responses:
    - For each query:
      - Evaluations
      - Merkle paths

  Footer:
    - Checksum
```

### Compression

Optional proof compression:

```
Strategies:
  1. Generic compression (zstd, lz4)
     - 10-30% size reduction
     - Fast compression/decompression

  2. Proof-aware compression
     - Deduplicate Merkle nodes
     - Compact field element encoding
     - 20-40% reduction

  3. No compression
     - Zero overhead
     - Fastest transfer
```

### Proof Metadata

Accompanying metadata:

```
Metadata JSON:
  {
    proof_id: "abc123",
    created_at: "2024-01-15T10:30:00Z",
    program_hash: "0x...",
    public_inputs_hash: "0x...",
    proof_size: 150000,
    generation_time_ms: 45000,
    security_level: 128,
    version: "1.0.0"
  }
```

## Lifecycle Management

### Retention Policies

How long to keep proofs:

```
Policy types:
  1. Time-based: Delete after N days
  2. Size-based: Keep most recent M proofs
  3. Access-based: Delete if not accessed in N days
  4. Explicit: Delete only on client request

Configuration:
  retention:
    default: 30 days
    premium: 365 days
    archived: indefinite
```

### Cleanup Process

Removing expired proofs:

```
Scheduled cleanup:
  1. Identify expired proofs
  2. Check for active references
  3. Archive metadata (if required)
  4. Delete proof data
  5. Update indexes

Safety measures:
  - Grace period before deletion
  - Deletion logging
  - Soft delete option
```

### Archival

Long-term storage:

```
Archive process:
  1. Compress proof with high ratio
  2. Move to cold storage
  3. Update retrieval path
  4. Mark as archived

Retrieval from archive:
  1. Request restoration
  2. Copy to hot storage
  3. Notify when available
  4. Time-limited hot access
```

## Reliability

### Delivery Guarantees

Ensuring proof delivery:

```
At-least-once delivery (webhooks):
  1. Attempt delivery
  2. If failure, retry with backoff
  3. After N failures, fallback to polling

Idempotency:
  - Include proof hash in delivery
  - Client can deduplicate

Acknowledgment:
  - Client acknowledges receipt
  - Server confirms delivery complete
```

### Failure Handling

When delivery fails:

```
Webhook failure:
  - Retry with exponential backoff
  - Queue for later retry
  - Alert on persistent failure
  - Fall back to client polling

Storage failure:
  - Retry write operations
  - Use redundant storage
  - Alert operators
  - Return error to client

Network issues:
  - Support resumable downloads
  - Provide checksums for verification
  - Enable range requests
```

### Monitoring

Track delivery health:

```
Metrics:
  - Delivery success rate
  - Delivery latency
  - Storage utilization
  - Retrieval latency
  - Cache hit rate

Alerts:
  - High failure rate
  - Storage near capacity
  - Delivery latency spike
```

## Security

### Access Control

Protect proof access:

```
Authentication:
  - API key per client
  - JWT tokens
  - OAuth integration

Authorization:
  - Client can only access own proofs
  - Admin access for operations
  - Read-only tokens for verification

Audit:
  - Log all access attempts
  - Track proof downloads
  - Monitor for anomalies
```

### Encryption

Protect proofs in transit and at rest:

```
In transit:
  - TLS for all connections
  - Certificate validation

At rest:
  - Encrypt stored proofs
  - Key management system
  - Rotation policy

End-to-end (optional):
  - Client provides encryption key
  - Server never sees plaintext
```

## Key Concepts

- **Delivery mechanism**: How proofs reach clients
- **Storage strategy**: Where and how long proofs are kept
- **Notification**: Informing clients of completion
- **Retrieval**: Client access to completed proofs
- **Lifecycle**: Managing proofs from creation to deletion

## Design Considerations

### Push vs. Pull

| Push (Webhooks) | Pull (Polling) |
|-----------------|----------------|
| Lower latency | Simpler client |
| Server initiates | Client controls timing |
| Delivery complexity | Polling overhead |
| Firewall challenges | Always works |

### Storage Trade-offs

| Short Retention | Long Retention |
|-----------------|----------------|
| Lower storage cost | Higher storage cost |
| Simple management | Complex lifecycle |
| Re-prove if needed | Always available |
| Faster cleanup | Audit capability |

## Related Topics

- [Proof Request Handling](01-proof-request-handling.md) - Request entry point
- [Proof Generation Pipeline](02-proof-generation-pipeline.md) - Generating proofs
- [Proof Aggregation](../03-proof-composition/01-proof-aggregation.md) - Combining proofs
