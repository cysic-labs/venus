# Terminology and Notation Standards

## Overview

This glossary provides standardized definitions for terms used throughout the zkVM documentation. Consistent terminology is essential for clear communication and accurate understanding of complex cryptographic concepts. All documents in this knowledge base adhere to the definitions and notation conventions established here.

The glossary is organized into thematic sections covering fields and algebra, polynomials, proof systems, zkVM architecture, and cryptographic primitives. Each term includes a concise definition and, where applicable, the mathematical notation used to represent it.

When reading other documents, refer back to this glossary for any unfamiliar terms. When writing or extending documentation, use these standardized terms and notation to maintain consistency.

## Notation Conventions

### Mathematical Symbols

| Symbol | Meaning |
|--------|---------|
| F_p | Prime field with characteristic p |
| F_p^n | Extension field of degree n over F_p |
| Z_n | Integers modulo n |
| |S| | Cardinality (size) of set S |
| a mod p | Remainder when a is divided by p |
| a := b | Definition: a is defined as b |
| a = b | Equality: a equals b |
| a != b | Inequality: a does not equal b |
| a \| b | a divides b (b is a multiple of a) |
| gcd(a,b) | Greatest common divisor of a and b |

### Field Operations

| Notation | Operation |
|----------|-----------|
| a + b | Field addition |
| a - b | Field subtraction |
| a * b or ab | Field multiplication |
| a / b or a * b^(-1) | Field division |
| a^n | Exponentiation (a to the power n) |
| a^(-1) | Multiplicative inverse of a |

### Polynomial Notation

| Notation | Meaning |
|----------|---------|
| P(X) | Polynomial in variable X |
| deg(P) | Degree of polynomial P |
| P(z) | Evaluation of P at point z |
| P'(X) | Derivative of P with respect to X |
| P \| Q | P divides Q (Q = P * R for some polynomial R) |
| Z_D(X) | Vanishing polynomial for domain D |

### Complexity Notation

| Notation | Meaning |
|----------|---------|
| O(f(n)) | Big-O: asymptotic upper bound |
| Theta(f(n)) | Big-Theta: asymptotic tight bound |
| poly(n) | Some polynomial function of n |
| negl(n) | Negligible function of n |

### Probability Notation

| Notation | Meaning |
|----------|---------|
| Pr[E] | Probability of event E |
| x <- S | Sample x uniformly from set S |
| x <- A(y) | x is output of algorithm A on input y |

## Field Theory Terms

### Prime Field (F_p)

A finite field containing exactly p elements, where p is a prime number. Elements are integers {0, 1, 2, ..., p-1} with arithmetic performed modulo p. Every non-zero element has a multiplicative inverse.

**Notation**: F_p, GF(p), Z/pZ

**Example**: F_7 = {0, 1, 2, 3, 4, 5, 6} with 3 + 5 = 1 (since 8 mod 7 = 1)

### Field Characteristic

The smallest positive integer n such that adding the multiplicative identity to itself n times yields the additive identity. For F_p, the characteristic equals p.

**Notation**: char(F) = p

### Multiplicative Group

The set of all non-zero elements of a field, forming a group under multiplication. For F_p, this group has order p - 1.

**Notation**: F_p^*, (Z/pZ)^*

### Generator (Primitive Root)

An element g of the multiplicative group whose powers generate all non-zero field elements. If g is a generator of F_p^*, then {g^0, g^1, ..., g^(p-2)} = F_p^*.

**Also known as**: Primitive root, multiplicative generator

### Root of Unity

An element omega such that omega^n = 1 for some positive integer n. A **primitive n-th root of unity** is one where n is the smallest such positive integer.

**Notation**: omega, omega_n (primitive n-th root)

**Property**: The n-th roots of unity form a cyclic group of order n

### Extension Field (F_p^n)

A field containing F_p as a subfield, with degree n over F_p. Constructed as F_p[X]/(f(X)) where f is an irreducible polynomial of degree n. Elements are polynomials of degree < n with coefficients in F_p.

**Notation**: F_p^n, F_{p^n}, GF(p^n)

### Quadratic Non-Residue

An element a in F_p that has no square root in F_p. Used in constructing quadratic extensions.

**Test**: a is a non-residue if a^((p-1)/2) = -1 mod p

### Frobenius Endomorphism

The map phi: F_p^n -> F_p^n defined by phi(x) = x^p. This is a field automorphism that fixes F_p.

**Property**: phi^n = identity (applying n times returns original)

## Polynomial Terms

### Univariate Polynomial

A polynomial in a single variable, typically X. Represented as a sum of terms a_i * X^i.

**Standard form**: P(X) = a_0 + a_1*X + a_2*X^2 + ... + a_d*X^d

### Polynomial Degree

The highest power of X with a non-zero coefficient. A polynomial of degree d has d+1 coefficients.

**Notation**: deg(P) = d means highest non-zero term is a_d*X^d

### Coefficient Form

Representation of a polynomial by listing its coefficients [a_0, a_1, ..., a_d].

**Also known as**: Coefficient representation

### Evaluation Form

Representation of a polynomial by its values at specified points. A polynomial of degree < n is uniquely determined by its values at n distinct points.

**Also known as**: Point-value representation

### Lagrange Interpolation

The process of finding the unique polynomial of degree < n that passes through n given points. The Lagrange basis polynomials L_i(X) satisfy L_i(x_j) = 1 if i=j, 0 otherwise.

**Formula**: P(X) = sum_i y_i * L_i(X)

### Vanishing Polynomial

A polynomial that evaluates to zero at all points in a specified set D.

**Notation**: Z_D(X) or V_D(X)

**For roots of unity**: Z(X) = X^n - 1 vanishes on {omega^0, omega^1, ..., omega^(n-1)}

### Quotient Polynomial

The result of dividing one polynomial by another. If P(X) = Q(X) * D(X) + R(X), then Q is the quotient and R is the remainder.

**Key property**: If P vanishes on domain D, then P is divisible by Z_D, so P = Q * Z_D for some quotient Q.

### Low-Degree Extension (LDE)

The process of extending polynomial evaluations from a smaller domain to a larger domain while preserving the polynomial. Also refers to the extended evaluation domain itself.

**Process**: Interpolate on small domain, evaluate on large domain

### Reed-Solomon Encoding

Encoding data as evaluations of a low-degree polynomial. The polynomial degree is less than the message length, and evaluations are taken at more points than the degree.

**Properties**: Enables error detection and correction

## Proof System Terms

### Zero-Knowledge Proof

A cryptographic protocol allowing a prover to convince a verifier that a statement is true without revealing any information beyond the statement's validity.

**Properties**: Completeness, soundness, zero-knowledge

### STARK (Scalable Transparent ARgument of Knowledge)

A proof system with near-linear proving time, polylogarithmic verification, no trusted setup, and post-quantum security. Based on polynomial IOPs and hash functions.

**Key features**: Transparency, scalability

### SNARK (Succinct Non-interactive ARgument of Knowledge)

A proof system with constant-size proofs and constant verification time, typically based on elliptic curve cryptography. Many SNARKs require a trusted setup.

**Key features**: Succinctness, non-interactivity

### Prover

The party generating a proof of computational correctness. The prover has access to the full execution trace (witness) and produces a proof convincing the verifier.

### Verifier

The party checking a proof's validity. The verifier does not have access to the full witness but can efficiently verify the proof.

### Witness

The private data that proves a statement is true. In zkVM context, this includes the execution trace, intermediate values, and any auxiliary data needed for proof generation.

**Also known as**: Auxiliary input

### Statement (Instance)

The public portion of what is being proven. Includes public inputs, public outputs, and any public parameters.

### Soundness

The property that a cheating prover cannot convince a verifier of a false statement except with negligible probability.

**Soundness error**: The maximum probability of a cheating prover succeeding

### Completeness

The property that an honest prover with a valid witness can always convince the verifier.

### Zero-Knowledge Property

The property that a proof reveals nothing beyond the validity of the statement. Formally, there exists a simulator that can produce indistinguishable transcripts without the witness.

### Fiat-Shamir Transform

A technique for converting an interactive proof into a non-interactive one by replacing verifier challenges with hash outputs of the protocol transcript.

**Requirement**: Security relies on the random oracle model

### Transcript

The sequence of messages exchanged (or simulated) in a proof protocol. Used as input to hash functions for generating challenges.

## FRI and Commitment Terms

### FRI (Fast Reed-Solomon IOP)

A protocol for proving that a committed function is close to a low-degree polynomial. Uses iterative folding to reduce degree and verify consistency.

**Expansion**: Fast Reed-Solomon Interactive Oracle Proof

### Polynomial Commitment

A cryptographic commitment to a polynomial that allows later proving evaluations at chosen points without revealing the full polynomial.

**Operations**: Commit, Open, Verify

### Merkle Tree

A hash-based data structure where each leaf is a hash of data, and each internal node is a hash of its children. The root commits to all leaves.

**Opening**: A leaf can be opened with O(log n) sibling hashes

### Merkle Root

The single hash at the top of a Merkle tree, serving as a commitment to all leaf data.

### Authentication Path (Merkle Path)

The sequence of sibling hashes from a leaf to the root, enabling verification that a leaf is part of the committed tree.

### Folding (FRI)

The core operation in FRI that reduces polynomial degree. Given P(X) and random challenge alpha, the folded polynomial P'(Y) has half the degree.

**Formula**: P(X) = P_even(X^2) + X*P_odd(X^2), then P'(Y) = P_even(Y) + alpha*P_odd(Y)

### Query (FRI)

A random position where the verifier requests the prover to open commitments and demonstrate folding consistency.

### Blowup Factor (Expansion Factor)

The ratio of the evaluation domain size to the polynomial degree. Larger blowup means more redundancy in the Reed-Solomon encoding.

**Typical values**: 2x to 8x

## zkVM Architecture Terms

### Execution Trace

A table recording the complete state of a computation at each step. Columns represent state variables; rows represent time steps.

**Also known as**: Computation trace, witness trace

### Trace Column

A single state variable tracked across all execution steps. Becomes a polynomial when the trace is encoded.

### Trace Polynomial

A polynomial whose evaluations at domain points equal a trace column's values.

### State Machine

A modular component of the zkVM that enforces constraints for a specific aspect of execution (e.g., arithmetic operations, memory access).

### Main State Machine

The central state machine that orchestrates execution, decodes instructions, and coordinates with other state machines.

### Constraint

A polynomial equation that must evaluate to zero for all valid executions. Constraints encode the correctness rules of the computation.

### Transition Constraint

A constraint relating values in consecutive trace rows, encoding how state evolves from one step to the next.

**Example**: next_pc = pc + 4 (for sequential execution)

### Boundary Constraint

A constraint fixing values at specific trace positions, such as initial state or final outputs.

**Example**: pc[0] = entry_point

### AIR (Algebraic Intermediate Representation)

A way of expressing computation constraints as polynomial identities over an execution trace. Consists of trace columns and constraint polynomials.

### Register

A named storage location in the virtual machine, typically holding values used in the current instruction.

### Program Counter (PC)

A register pointing to the address of the current instruction being executed.

### Instruction Set Architecture (ISA)

The specification of a processor's instructions, including opcodes, operand formats, and execution semantics. zkVMs often implement RISC-V.

### Precompile

A specialized constraint system for efficiently proving common operations like hashes or elliptic curve arithmetic.

**Also known as**: Precompiled operation, accelerated operation

## Cryptographic Primitive Terms

### Hash Function

A function mapping arbitrary-length input to fixed-length output with properties: deterministic, efficient, preimage-resistant, collision-resistant.

### Collision Resistance

The property that finding two distinct inputs producing the same hash output is computationally infeasible.

### Algebraic Hash

A hash function designed using field-native operations (addition, multiplication) for efficient representation in constraint systems.

**Examples**: Poseidon, Rescue, Griffin

### Sponge Construction

A mode of operation for hash functions using a state split into "rate" (absorbs input, produces output) and "capacity" (provides security).

### MDS Matrix

A Maximum Distance Separable matrix providing optimal diffusion in hash functions. Every square submatrix is non-singular.

### S-box (Substitution Box)

A non-linear function used in cryptographic constructions. In algebraic hashes, typically x^d for small d.

### Elliptic Curve

An algebraic curve defined by y^2 = x^3 + ax + b over a field, with a group structure on its points used in cryptography.

### Scalar Multiplication

Computing k*P for scalar k and curve point P by repeated addition. The core operation in elliptic curve cryptography.

### Pairing

A bilinear map e: G1 x G2 -> GT between elliptic curve groups, enabling constructions like BLS signatures and KZG commitments.

### KZG Commitment

A polynomial commitment scheme using pairings, producing constant-size commitments and opening proofs.

**Requirement**: Trusted setup or universal reference string

## Complexity and Security Terms

### Security Parameter (lambda)

A value determining the security level of a cryptographic system. Commonly 128 bits for modern systems.

**Notation**: lambda, kappa

### Negligible Function

A function f(n) that decreases faster than any inverse polynomial: for all c, f(n) < 1/n^c for sufficiently large n.

### Computational Security

Security against adversaries with bounded computational resources (polynomial time).

### Information-Theoretic Security

Security against adversaries with unlimited computational power, based solely on information availability.

### Trusted Setup

A setup phase requiring secret randomness that must be discarded. Compromise of secrets breaks the system's security.

### Transparent Setup

A setup phase using only public randomness, with no secrets. Anyone can verify the setup's correctness.

### Post-Quantum Security

Security against adversaries with access to quantum computers. Typically achieved by avoiding discrete-log or factoring assumptions.

## Protocol and System Terms

### Interactive Protocol

A protocol where prover and verifier exchange multiple messages, with each party's messages depending on previous exchanges.

### Non-Interactive Protocol

A protocol where the prover sends a single message (the proof) with no further communication.

### Random Oracle Model

A theoretical model where hash functions are idealized as truly random functions. Used in security proofs.

### Recursion (Proof Recursion)

Verifying a proof inside another proof, enabling aggregation and incremental computation.

### Proof Aggregation

Combining multiple proofs into a single proof, reducing verification cost for batches of statements.

### Proof Compression

Reducing proof size, often by verifying a large proof inside a system with smaller proofs (e.g., STARK inside SNARK).

## Key Concepts

- Consistent terminology enables clear communication
- Mathematical notation follows standard conventions
- Terms are organized by thematic area
- Each term includes notation and examples where applicable

## Design Considerations

### Extending This Glossary

When adding new terms:
- Place in the appropriate thematic section
- Include notation if applicable
- Provide a concise, precise definition
- Add examples for complex concepts
- Cross-reference related terms

### Using Terminology in Documents

- Define specialized terms on first use with reference to this glossary
- Use terms consistently as defined here
- Avoid synonyms unless explicitly listed as "also known as"
- When precision matters, include the formal notation

## Related Topics

- [What is a zkVM?](01-what-is-zkvm.md) - Introduction to zkVM concepts
- [zkVM Architecture Overview](02-zkvm-architecture-overview.md) - System architecture
- [Building Blocks](03-building-blocks.md) - Cryptographic foundations
- [Prime Fields](../01-mathematical-foundations/01-finite-fields/01-prime-fields.md) - Field arithmetic details
