# Linker Scripts

## Overview

Linker scripts control how the linker combines object files into an executable program. They define memory regions, section placement, symbol assignments, and the overall memory layout of the final program. For zkVM environments, linker scripts are essential for establishing the precise memory organization that both the runtime and proving system expect.

Unlike user-space programs on typical operating systems that rely on dynamic loaders and virtual memory, zkVM programs are typically statically linked with explicit memory layouts. The linker script specifies exactly where code, data, and runtime structures reside in the address space. This explicit control ensures deterministic execution and enables the proving system to make assumptions about program structure.

This document covers linker script concepts, their role in zkVM program construction, and design considerations for memory layout specification.

## Linker Script Purpose

### What Linker Scripts Do

Primary functions:

```
Linker script functions:
  Define memory regions
  Assign sections to regions
  Set entry point
  Define symbols
  Control alignment
  Organize output layout
```

### Why They Matter for zkVM

Importance in zkVM context:

```
zkVM relevance:
  Fixed memory layout
  Known addresses
  No dynamic loading
  Proving system assumptions
  Runtime expectations
```

### Static vs Dynamic Linking

zkVM linking model:

```
Static linking:
  All code combined at build time
  Fixed addresses
  No runtime loading
  Self-contained binary

Why static:
  Deterministic layout
  No dynamic linker
  Simpler execution model
  Proof-friendly
```

## Memory Layout Definition

### Memory Regions

Defining available memory:

```
Region specification:
  Region name
  Origin address
  Length in bytes
  Attributes (optional)

Purpose:
  Where code can go
  Where data can go
  Bounds enforcement
```

### Region Attributes

Memory region properties:

```
Common attributes:
  Read permission
  Write permission
  Execute permission
  Allocation behavior

zkVM regions:
  ROM: Read, execute
  RAM: Read, write
  I/O: Read/write specific
```

### Region Sizing

Determining region sizes:

```
Sizing considerations:
  Program size requirements
  Data size requirements
  Stack size needs
  Heap size needs
  Safety margins
```

## Section Management

### Section Concepts

What sections represent:

```
Common sections:
  .text: Executable code
  .rodata: Read-only data
  .data: Initialized data
  .bss: Uninitialized data (zeroed)

Purpose:
  Organize content by type
  Apply appropriate permissions
  Enable efficient layout
```

### Input Sections

Sections from object files:

```
Input sections:
  From compiled object files
  Named by compiler
  Contain code or data

Gathering:
  Match by pattern
  Collect from all objects
  Order may matter
```

### Output Sections

Sections in final executable:

```
Output sections:
  Defined in linker script
  Contain collected inputs
  Placed in memory regions

Definition:
  Name and placement
  Contents from inputs
  Alignment and fill
```

### Section Placement

Assigning sections to regions:

```
Placement control:
  Section goes in region
  At specified address
  Or after previous section

Constraints:
  Must fit in region
  Alignment respected
  No overlap
```

## Address Assignment

### Start Addresses

Setting section origins:

```
Start address options:
  Explicit address
  Following previous section
  Aligned to boundary
  Region start

Control:
  Precise placement when needed
  Sequential for convenience
```

### Alignment

Ensuring proper alignment:

```
Alignment purposes:
  Performance optimization
  Correctness requirements
  Hardware expectations

Specification:
  Per-section alignment
  Per-symbol alignment
  Region boundary alignment
```

### Symbol Definition

Creating linker symbols:

```
Symbol uses:
  Mark section boundaries
  Provide runtime information
  Enable address calculation

Common symbols:
  Section start/end
  Stack location
  Heap boundaries
```

## Entry Point

### Defining Entry

Specifying program start:

```
Entry point:
  Initial program counter
  Where execution begins
  Set by linker script

Options:
  Specific symbol
  Specific address
  Default behavior
```

### Entry Symbol

Using a symbol for entry:

```
Entry symbol:
  Named function or label
  Resolved by linker
  Becomes program start

Common names:
  _start
  main
  Platform-specific
```

## Common Patterns

### Standard Layout

Typical memory organization:

```
Standard layout pattern:
  Low addresses: Code (.text)
  After code: Read-only data (.rodata)
  After rodata: Initialized data (.data)
  After data: BSS (.bss)
  Stack at high addresses (grows down)
  Heap between BSS and stack
```

### ROM/RAM Split

Separating code and data:

```
ROM/RAM pattern:
  ROM: Code and constants
  RAM: Variables and heap

Placement:
  .text and .rodata in ROM
  .data, .bss, heap, stack in RAM
```

### Stack Placement

Positioning the stack:

```
Stack placement:
  Usually high addresses
  Grows downward
  Known top address

Definition:
  Stack symbol for top
  Size allocation
  Guard space (optional)
```

### Heap Placement

Positioning the heap:

```
Heap placement:
  After BSS typically
  Grows upward
  Known base address

Definition:
  Heap start symbol
  Size limit
  Meets stack from below
```

## zkVM-Specific Considerations

### Fixed Layout Requirements

Why layout matters:

```
Fixed layout needs:
  Proving system expects layout
  Runtime assumes structure
  No relocation at load time
  Deterministic addresses
```

### I/O Region Placement

Input/output memory:

```
I/O regions:
  Input buffer placement
  Output buffer placement
  Special access patterns

Considerations:
  Known addresses
  Appropriate permissions
  Size allocation
```

### Minimal Layout

Simplest viable layout:

```
Minimal layout:
  Code region
  Data region
  Stack/heap region

Benefits:
  Simple to understand
  Easy to verify
  Fewer constraints
```

## Layout Verification

### Bounds Checking

Verifying layout correctness:

```
Checks during linking:
  Sections fit in regions
  No overlapping sections
  Alignment satisfied
  Entry point valid
```

### Symbol Verification

Checking required symbols:

```
Symbol checks:
  All symbols resolved
  Expected symbols present
  Addresses reasonable
```

### Size Reporting

Understanding output size:

```
Size information:
  Total size per section
  Region usage
  Available space

Uses:
  Verify fit
  Optimize sizing
  Debug issues
```

## Layout Customization

### Adding Regions

Defining custom regions:

```
Custom regions:
  Special-purpose areas
  Different permissions
  Isolated functionality

Examples:
  Scratch memory
  Debug region
  Reserved areas
```

### Custom Sections

Defining special sections:

```
Custom sections:
  Application-specific
  Special attributes
  Explicit placement

Uses:
  Aligned data
  Privileged code
  Platform-specific
```

### Conditional Layout

Platform-specific layouts:

```
Conditional approaches:
  Preprocessor conditionals
  Multiple script files
  Include files

Purpose:
  Platform variations
  Configuration options
  Build variants
```

## Debugging Layout Issues

### Common Problems

Typical layout issues:

```
Common issues:
  Section too large for region
  Alignment violations
  Overlapping sections
  Missing sections
  Symbol resolution failures
```

### Diagnostic Information

Getting layout details:

```
Diagnostic outputs:
  Map file showing layout
  Symbol table
  Section sizes
  Warning messages
```

### Troubleshooting

Resolving issues:

```
Troubleshooting steps:
  Check region sizes
  Verify section assignments
  Inspect input sections
  Review alignment
  Check symbol definitions
```

## Best Practices

### Clear Organization

Organizing linker scripts:

```
Organization practices:
  Group related definitions
  Comment purposes
  Use meaningful names
  Order logically
```

### Maintainability

Keeping scripts maintainable:

```
Maintainability:
  Parameterize sizes
  Use symbols for addresses
  Avoid magic numbers
  Document constraints
```

### Portability

Writing portable scripts:

```
Portability considerations:
  Standard section names
  Common patterns
  Conditional sections
  Clear interface
```

## Key Concepts

- **Memory region**: Named address range with properties
- **Section**: Unit of code or data in executable
- **Symbol**: Named address or value
- **Entry point**: Where execution begins
- **Alignment**: Address boundary requirements
- **Static linking**: All code combined at build time

## Design Trade-offs

### Explicit vs Automatic

| Explicit Layout | Automatic Layout |
|-----------------|------------------|
| Full control | Linker decides |
| More work | Less work |
| Predictable | May vary |
| Required for zkVM | Not suitable |

### Fixed vs Flexible

| Fixed Addresses | Relocatable |
|-----------------|-------------|
| Known at build | Resolved at load |
| Simpler runtime | Flexible loading |
| zkVM requirement | Traditional programs |

### Simple vs Complex

| Simple Layout | Complex Layout |
|---------------|----------------|
| Fewer regions | Many regions |
| Easier to understand | More control |
| Faster linking | More options |
| Less flexibility | Full customization |

## Related Topics

- [Compilation Target](01-compilation-target.md) - Target specification
- [Build Process](03-build-process.md) - Overall build workflow
- [Memory Layout](../../04-zkvm-architecture/03-memory-model/01-memory-layout.md) - zkVM memory organization
- [Boot Sequence](../01-operating-system/02-boot-sequence.md) - Startup expectations

