# PIL2 Language Reference

PIL2 (Polynomial Identity Language 2) is a domain-specific language designed to describe constraint systems compatible with VADCOPS (VAriant Degree Composite Proof). It is used to define arithmetic circuits for zero-knowledge proof systems.

## Table of Contents

1. [Introduction](#introduction)
2. [Basic Concepts](#basic-concepts)
3. [Scopes and Hierarchies](#scopes-and-hierarchies)
4. [Data Types](#data-types)
5. [Variables and Constants](#variables-and-constants)
6. [Columns](#columns)
7. [Expressions](#expressions)
8. [Constraints](#constraints)
9. [Functions](#functions)
10. [Control Flow](#control-flow)
11. [Sequences](#sequences)
12. [Air Templates](#air-templates)
13. [Air Groups](#air-groups)
14. [Lookups and Permutations](#lookups-and-permutations)
15. [Range Checks](#range-checks)
16. [Connections](#connections)
17. [Hints](#hints)
18. [Containers](#containers)
19. [Include and Require](#include-and-require)
20. [Pragmas](#pragmas)
21. [Built-in Functions](#built-in-functions)
22. [Built-in Constants](#built-in-constants)

---

## Introduction

PIL2 is used to describe polynomial constraints that define the behavior of a computation. The language allows you to:

- Define witness and fixed columns, public values.
- Express polynomial constraints between columns.
- Organize computations into modular air templates
- Define hints to pass information to the prover
- Use the PIL2 Components STD library: To use lookups, permutations, and range checks for complex validations. See [pil2-components](https://github.com/0xPolygonHermez/pil2-proofman/tree/main/pil2-components)
- Building reusable components and libraries

## Basic Concepts

### Comments

```pil
// Single-line comment

/* 
   Multi-line 
   comment 
*/
```

### Numbers

Numbers can be expressed in decimal or hexadecimal format. Underscores can be used as separators for readability:

```pil
const int value1 = 1000000;
const int value2 = 1_000_000;      // Same as above, with separators
const int value3 = 0xA000_0000;    // Hexadecimal with separators
const int mask = 0xFF;             // Hexadecimal
```

### Strings

PIL2 supports regular strings and template strings:

```pil
string name = "hello";
string template_name = `prefix_${index}`;  // Template string with interpolation
```

---

## Scopes and Hierarchies

PIL2 has three main scope levels:

```
Proof > AirGroup > Air
```

### Proof Scope

The global scope. Elements defined here are accessible throughout the entire proof:

- `public` - Public inputs visible to the verifier
- `proofval` - Private values at proof level
- `challenge` - Random challenges derived from commitments (Fiat-Shamir)

### AirGroup Scope

Groups related AIRs together. An airgroup can contain multiple airs:

- `airgroupval` - Aggregated values from air instances (see [Air Group Values](#air-group-values))

### Air Scope

An **air** (Algebraic Intermediate Representation) is an instance of an **airtemplate**. When generating a proof, you can have multiple instances of the same air. When these instances are ordered/sequential, we call them **segments**.

- `airval` - Values specific to an air instance (scalar, no rows like columns)
- `col witness` - Witness (private) columns with N rows
- `col fixed` - Fixed (preprocessed) columns with N rows

### Understanding Instances and Segments

```
┌─────────────────────────────────────────────────────────────┐
│                         PROOF                               │
│  ┌───────────────────────────────────────────────────────┐  │
│  │                    AIRGROUP                           │  │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐                │  │
│  │  │  AIR    │  │  AIR    │  │  AIR    │  ...           │  │
│  │  │ inst 0  │  │ inst 1  │  │ inst 2  │                │  │
│  │  │(segment)│  │(segment)│  │(segment)│                │  │
│  │  └─────────┘  └─────────┘  └─────────┘                │  │
│  │       │            │            │                     │  │
│  │       └────────────┴────────────┘                     │  │
│  │              airgroupval (aggregated)                 │  │
│  └───────────────────────────────────────────────────────┘  │
│                                                             │
│  proofval, public, challenge (proof-level)                  │
└─────────────────────────────────────────────────────────────┘
```

### Stages

Stages represent steps in the proving protocol. For each stage, a commitment is computed. The DSL allows you to define which stage elements belong to, but the actual execution is done by the prover.

PIL2 allows you to modify the protocol and define new stages, which is why the standard library (`std` in [pil2-components](https://github.com/0xPolygonHermez/pil2-proofman/tree/main/pil2-components)) exists.

```pil
// Stage 1: Initial witness computation
col witness stage(1) early_witness;

// Stage 2: After first challenge is available
col witness stage(2) late_witness;
challenge stage(2) gamma;

// Stage 3: After second round
col witness stage(3) final_witness;
```

### Air Values (airval)

Air values are FE elements associated with a specific air instance. Unlike columns, they have no rows - they are single values per instance.

```pil
airtemplate MyAir(int N = 2**16) {
    // Air values - one value per instance
    airval my_value;
    airval counter;
    
    col witness a;
    
    // Use airval in constraints with first/last row
    // (airval is constant across all rows of the instance)
}
```

### Air Group Values (airgroupval)

Air group values have a dual nature:

1. **Inside an air instance**: Acts like an private value - you can set constraints between instance elements
2. **At airgroup/proof level**: Represents the **aggregated** value across all instances on global constraints

The aggregation function can be `sum` or `prod` (product).

```pil
airtemplate MyAir(int N = 2**16) {
    // Define airgroupval with aggregation type
    airgroupval aggregate(sum) instance_contribution;
    airgroupval aggregate(prod) instance_factor;
    
    col witness value;
    
    // Inside instance: set the contribution
    instance_contribution === value[0] + value[N-1];
}

// At proof level: use aggregated value
// The sum/product of all instance_contribution values
```

### Proof Values (proofval)

Proof values are private values at the proof level - they are global Field Elements, not per-instance.

```pil
proofval stage(1) global_counter;
proofval stage(2) computed_value;
```

### Commits

Commits group columns into a commitment scheme. A Merkle tree is computed for the committed columns, and the root becomes a public input.

This is used to bind the commitment root of a program (ROM) to the proof.

```pil
// Group columns under a commitment
commit stage(1) public(rom_root) ROM_COMMIT;

// Columns associated with this commit will be part of the Merkle tree
// rom_root will contain the Merkle root as a public input
```

---

## Data Types

### Primitive Types

| Type | Description |
|------|-------------|
| `int` | Integer values (arbitrary precision) |
| `fe` | Field elements |
| `expr` | Polynomial expressions |
| `string` | String values |

### Column Types

| Type | Description |
|------|-------------|
| `col witness` | Witness (private) columns |
| `col fixed` | Fixed (preprocessed) columns |
| `col <name>` | Custom column types |

### Special Types

| Type | Description |
|------|-------------|
| `public` | Public inputs |
| `challenge` | Verifier challenges |
| `proofval` | Proof-level private values |
| `airgroupval` | Air group level values |
| `airval` | Air level values |

---

## Variables and Constants

### Variable Declaration

```pil
int x;                          // Integer variable
int x = 10;                     // With initialization
int arr[10];                    // Array of integers
int matrix[3][4];               // 2D array

fe field_elem;                  // Field element
fe values[5];                   // Array of field elements

expr polynomial;                // Expression variable
string name = "test";           // String variable

const int CONSTANT = 42;        // Constant (immutable)
const int MASK_8 = 0xFF;

const expr flags;               // Constant expression
```

### Multiple Variable Declaration

```pil
int a, b, c;                    // Multiple variables
int [x, y, z] = [1, 2, 3];      // Multiple assignment
```

### Assignment Operators

```pil
x = 10;                         // Simple assignment
x += 5;                         // Add and assign
x -= 3;                         // Subtract and assign
x *= 2;                         // Multiply and assign
x++;                            // Increment
x--;                            // Decrement
++x;                            // Pre-increment
--x;                            // Pre-decrement
```

---

## Columns

### Witness Columns

Witness columns are private inputs provided by the prover:

```pil
col witness a;                           // Single witness column
col witness a, b, c;                     // Multiple columns
col witness values[10];                  // Array of columns
col witness matrix[3][4];                // 2D array

// With features
col witness bits(8) byte_value;          // 8-bit metadata
col witness bits(32) word;               // 32-bit metadata
col witness bits(1) flag;                // 1-bit metadata (boolean)
col witness bits(64, signed) offset;     // Signed 64-bit metadata
col witness stage(2) late_witness;       // Stage 2 witness
```

### Fixed Columns

Fixed columns contain preprocessed data known at setup time:

```pil
col fixed FIRST = [1, 0...];             // First row is 1, rest 0
col fixed STEP = [0..(N-1)];             // Values 0 to N-1
col fixed LAST = [0:(N-1), 1];           // Last row is 1

// With sequence definitions
col fixed SEQ = [1, 2, 3]:4;             // Repeat [1,2,3] 4 times
col fixed RANGE = [0..255, 255...];      // 0-255 then pad with 255
```

### Column Features

```pil
col witness bits(n) name;                // n-bit metadata (for trace compaction)
col witness bits(n, signed) name;        // Signed n-bit metadata
col witness stage(s) name;               // Specific stage
col witness virtual(size) name;          // Virtual column
```

**Important about `bits(n)`:** The `bits(n)` feature does **not** add any constraint. It is purely metadata that informs the system how many bits the witness value uses, allowing the trace to be compacted more efficiently. If you need to enforce that a value fits in n bits, you must explicitly add a range check constraint:

```pil
col witness bits(8) value;               // Metadata: value uses 8 bits
range_check(value, min: 0, max: 255);    // Explicit constraint needed!
```

### Row Offsets (Next/Previous Row Access)

```pil
a'                              // Next row: a[i+1]
a'2                             // Two rows ahead: a[i+2]
a'(n)                           // n rows ahead: a[i+n]
'a                              // Previous row: a[i-1]
2'a                             // Two rows back: a[i-2]
(n)'a                           // n rows back: a[i-n]
```

---

## Expressions

### Arithmetic Operators

```pil
a + b                           // Addition
a - b                           // Subtraction
a * b                           // Multiplication
a / b                           // Field division
a \ b                           // Integer division
a % b                           // Modulo
a ** b                          // Exponentiation
-a                              // Negation
```

### Comparison Operators

```pil
a == b                          // Equal
a != b                          // Not equal
a < b                           // Less than
a > b                           // Greater than
a <= b                          // Less than or equal
a >= b                          // Greater than or equal
```

### Logical Operators

```pil
a && b                          // Logical AND
a || b                          // Logical OR
!a                              // Logical NOT
```

### Bitwise Operators

```pil
a & b                           // Bitwise AND
a | b                           // Bitwise OR
a ^ b                           // Bitwise XOR
a << n                          // Left shift
a >> n                          // Right shift
```

### Ternary Operator

```pil
condition ? value_if_true : value_if_false
```

### Type Checking

```pil
expr is int                     // Check if expression is int type
value is expr[]                 // Check if value is array of expr
```

### Type Casting

```pil
int(expression)                 // Cast to int
fe(expression)                  // Cast to field element
expr(expression)                // Cast to expression
string(expression)              // Cast to string
col(expression)                 // Cast to column
```

### Spread Operator (`...`)

The spread operator `...` decomposes an array into its individual elements:

```pil
int arr[3] = [1, 2, 3];

// Spread array as function arguments
function_call([...arr]);        // Equivalent to function_call([1, 2, 3])

// Spread in array construction
int more[5] = [0, ...arr, 4];   // Creates [0, 1, 2, 3, 4]

// Combine arrays
int combined[] = [...arr1, ...arr2];
```

---

## Constraints

### Polynomial Identity Constraint

The `===` operator creates a polynomial identity that must hold for all rows:

```pil
a === b;                        // a must equal b for all rows
a + b === c;                    // Sum must equal c
a * b === c * d;                // Product equality

// With row offsets
a' === a + 1;                   // Next row equals current + 1
a' - a === STEP;                // Increment by STEP
```

### Witness Assignment Constraint (`<==`)

The `<==` operator does **two things**:
1. Creates a polynomial identity constraint (like `===`)
2. Creates a witness hint that tells the prover how to fill the column

```pil
c <== a + b;                    // Creates constraint AND witness hint
```

This is equivalent to:
```pil
c === a + b;                    // Constraint: c must equal a + b
@witness_hint { c: a + b };     // Hint: prover should compute c as a + b
```

Use `<==` when:
- The witness value can be directly computed from other columns
- You want to both constrain and inform the prover in one statement

Use `===` when:
- You only need the constraint without telling the prover how to compute it
- The witness is computed through a specific program

### Boolean Constraint Pattern

```pil
// Ensure x is boolean (0 or 1)
x * (1 - x) === 0;
```

### Conditional Constraints

```pil
// Constraint only when selector is 1
selector * (a - b) === 0;

// When selector is 1, a must equal b
// When selector is 0, constraint is trivially satisfied
```

---

## Functions

### Function Definition

```pil
function my_function(int a, int b): int {
    return a + b;
}

// With array parameters
function process(int values[], int len): int {
    int sum = 0;
    for (int i = 0; i < len; i++) {
        sum += values[i];
    }
    return sum;
}

// Multiple return values
function swap(int a, int b): [int, int] {
    return [b, a];
}

// With default parameters
function greet(string name, string prefix = "Hello"): string {
    return `${prefix}, ${name}!`;
}

// With expression parameters
function constrain_equal(expr a, expr b) {
    a === b;
}

// Private function (not exported)
private function helper(): int {
    return 42;
}

// Column parameters
function define_constraint(col witness a, col witness b, col fixed SEL) {
    SEL * (a - b) === 0;
}
```

### Named Arguments

```pil
// Function call with named arguments
range_check(expression: value, min: 0, max: 255, sel: is_active);

// Mixed positional and named
lookup_assumes(BUS_ID, [a, b, c], sel: selector);

// Shorthand: when variable name matches parameter name
int min = 0;
int max = 255;
expr sel = ACTIVE;
range_check(value, min:, max:, sel:);  // Equivalent to min: min, max: max, sel: sel
```

The shorthand syntax `param_name:` (with colon but no value) means "use the variable with the same name as the parameter". This avoids redundancy like `param_name: param_name`.

### Variadic Functions

```pil
function sum_all(int values...): int {
    int total = 0;
    for (int v in values) {
        total += v;
    }
    return total;
}
```

### Final Functions (Deferred Calls)

Final functions provide an event-like subscription mechanism that allows standard library functions to be called automatically when an air, airgroup, or proof scope closes. This is essential for libraries (like `std`) to add their constraints at the appropriate time.

When a scope closes, all registered final functions are executed, allowing libraries to:
- Aggregate collected lookups and generate lookup constraints
- Generate range check constraints from accumulated requests
- Generate permutation and connection constraints
- Finalize hint definitions

```pil
// Execute at end of air scope
on final air cleanup_function();

// Execute at end of airgroup scope
on final airgroup finalize_airgroup();

// Execute at end of proof scope
on final proof generate_global_hints();

// With priority (lower executes first)
on final(2) air low_priority_function();
on final(1) air high_priority_function();
```

**How it works:**

1. Library functions call `on final <scope> function_name()` to register themselves
2. When the corresponding scope closes (air, airgroup, or proof), all registered functions are invoked
3. Priority controls execution order (lower priority number = executed first)

**Example: How std_lookup works internally:**

```pil
// Inside std_lookup.pil (simplified)
function lookup_proves(const int bus_id, const expr cols[], const expr sel) {
    // Store the lookup info in a container
    container lookup_data[bus_id] {
        expr expressions[];
        // ...
    }
    
    // Register to be called when air closes
    on final air finalize_lookups();
}

function finalize_lookups() {
    // Called automatically when air scope closes
    // Generate the actual lookup constraints from collected data
}
```

This pattern allows user code to simply call `lookup_proves()` without worrying about when or how the actual constraints are generated.

---

## Control Flow

### If-Else Statements

```pil
if (condition) {
    // statements
}

if (condition) {
    // statements
} else {
    // statements
}

if (condition1) {
    // statements
} elseif (condition2) {
    // statements
} else {
    // statements
}
```

### For Loops

```pil
// Standard for loop
for (int i = 0; i < 10; i++) {
    // statements
}
```

### For-In Loops (Array Iteration)

The `in` operator allows iterating over all elements of an array. Note that PIL currently does not support dynamic arrays, so the array size must be known at compile time.

```pil
// For-in loop (iterate over literal values)
for (int value in [1, 2, 3, 4, 5]) {
    // statements - value takes 1, 2, 3, 4, 5 in sequence
}

// Iterate over a fixed-size array
int arr[5] = [10, 20, 30, 40, 50];
for (int item in arr) {
    // statements - item takes each array element
}

// Iterate over column array
col witness values[4];
for (expr v in values) {
    // Create constraints for each column
    v * (v - 1) === 0;  // Each must be boolean
}

// With index access pattern (common idiom)
for (int i = 0; i < length(arr); i++) {
    // Use arr[i] when you need the index
}
```

**Limitations:**
- Array size must be known at compile time
- Dynamic arrays are not currently supported
- The `in` operator only works with arrays, not ranges

### While Loops

```pil
while (condition) {
    // statements
}
```

### Do-While Loops

```pil
do {
    // statements
} while (condition);
```

### Switch Statements

```pil
switch (value) {
    case 0:
        // statements
    case 1, 2, 3:
        // multiple case values
    case 10..20:
        // range of values
    default:
        // default case
}
```

### Break and Continue

```pil
for (int i = 0; i < 10; i++) {
    if (i == 5) break;      // Exit loop
    if (i == 3) continue;   // Skip to next iteration
}
```

---

## Sequences

Sequences define patterns for fixed column initialization. They provide a concise way to specify repeated patterns, ranges, and series.

### Value Lists

Simple comma-separated lists of values:

```pil
[a, b, c]                       // List of values a, b, c
[1, 2, 3]                       // List: 1, 2, 3
[0, 1, 0, 1]                    // Alternating pattern
```

### Range Sequences

Ranges specify start and end values (both inclusive):

```pil
[a..b]                          // Range from a to b (inclusive)
[0..255]                        // Values 0, 1, 2, ..., 255
[1..N]                          // Values 1, 2, ..., N
```

Expressions in ranges must be in parentheses:

```pil
[0..(N-1)]                      // Values 0 to N-1
[a..(b+1)]                      // Range with expression endpoint
[(x*2)..(y*2)]                  // Both endpoints as expressions
```

### Arithmetic Sequences

Arithmetic sequences use `..+..` with increment = a1 - a0:

```pil
[a0, a1..+..]                   // Infinite arithmetic: a0, a0+(a1-a0), a0+2*(a1-a0), ...
[a0, a1..+..b]                  // Arithmetic up to b: a0, a1, ..., b

[1, 2..+..10]                   // Increment 1: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
[1, 3..+..9]                    // Increment 2: 1, 3, 5, 7, 9
[0, 5..+..20]                   // Increment 5: 0, 5, 10, 15, 20
```

### Geometric Sequences

Geometric sequences use `..*..` with ratio = a1 / a0:

```pil
[a0, a1..*..b]                  // Geometric up to b: a0, a0*(a1/a0), a0*(a1/a0)^2, ...
[a0, a1..*..]                   // Infinite geometric sequence

[1, 2..*..16]                   // Ratio 2: 1, 2, 4, 8, 16
[1, 3..*..81]                   // Ratio 3: 1, 3, 9, 27, 81
[1, GEN[BITS]..*..]             // Powers of generator
```

### Repetition (`:n`)

The colon operator `:n` repeats a pattern n times:

```pil
[a, b, c]:n                     // Repeat [a,b,c] n times
[1, 2, 3]:4                     // Result: 1,2,3,1,2,3,1,2,3,1,2,3
[0..3]:N/4                      // Repeat [0,1,2,3] N/4 times
[[1, 2], [3, 4]]:2              // Repeat nested: 1,2,3,4,1,2,3,4
[0]:100                         // 100 zeros
```

### Padding (`...`)

The `...` suffix repeats the last value or pattern to fill remaining space:

```pil
[1, 0...]                       // One 1, then 0s to fill: 1,0,0,0,...,0
[0..., 1]                       // All 0s, then one 1 at end: 0,0,0,...,0,1
[1, 2, 3, 3...]                 // 1,2,3, then 3s to fill: 1,2,3,3,3,...,3
[a, b, c]...                    // Repeat [a,b,c] pattern to fill
```

Common patterns:

```pil
col fixed FIRST = [1, 0...];    // First row is 1, rest 0
col fixed LAST = [0..., 1];     // Last row is 1, rest 0  
col fixed NOTLAST = [1..., 0];  // All 1s except last row
```

### Combined Sequences

Sequences can be nested and combined:

```pil
// Complex patterns
col fixed SEQ = [[1, 0:(N/2-1)], [0:(N/2-1), 1]];
col fixed CLOCK = [[1, 0:(CLOCKS-1)]:NUM_OPS, 0...];

// Range with repetition and padding
col fixed PATTERN = [[0..7]:8, 0...];

// Nested repetitions
col fixed NESTED = [[[1,0]:4, [0,1]:4]:N/64, 0...];
```

### Sequence Summary Table

| Syntax | Description | Example |
|--------|-------------|----------|
| `[a, b, c]` | Value list | `[1, 2, 3]` → 1,2,3 |
| `[a..b]` | Range (inclusive) | `[0..3]` → 0,1,2,3 |
| `[a0, a1..+..b]` | Arithmetic series | `[1, 3..+..7]` → 1,3,5,7 |
| `[a0, a1..*..b]` | Geometric series | `[1, 2..*..8]` → 1,2,4,8 |
| `[...]:n` | Repeat n times | `[1,2]:3` → 1,2,1,2,1,2 |
| `[...]...` | Pad/repeat to fill | `[1, 0...]` → 1,0,0,0,... |
| `[..., x]` | Pad then value | `[0..., 1]` → 0,0,...,0,1 |

---

## Air Templates

Air templates define reusable arithmetic circuit components:

### Basic Air Template

```pil
airtemplate MyAir(int N = 2**16) {
    col witness a, b, c;
    col fixed FIRST = [1, 0...];
    
    a + b === c;
}
```

### Air Template with Parameters

```pil
airtemplate Adder(int N = 2**16, int WIDTH = 32) {
    col witness bits(WIDTH) a, b;
    col witness bits(WIDTH + 1) sum;
    
    a + b === sum;
}
```

### Instantiating Air Templates

```pil
// Simple instantiation
Adder(N: 2**18, WIDTH: 64);

// With alias
Adder(N: 2**20) alias MyAdder;

// Virtual instantiation
virtual U8Air(N: 256);
```

### Virtual Instances

A **virtual air instance** does not appear in the final `pilout` file. Virtual instances are used internally by the standard library to:
- Group and aggregate data from multiple sources
- Build lookup tables without generating actual constraints
- Provide intermediate storage for library operations

```pil
// This creates a real air instance that will be in the pilout
MyAir(N: 2**16);

// This creates a virtual instance - used internally, not in pilout
virtual HelperAir(N: 256);
```

The `VIRTUAL` built-in constant equals `1` inside a virtual instantiation, allowing conditional logic:

```pil
airtemplate DualMode(int N) {
    if (VIRTUAL) {
        // Code only for virtual instances
    } else {
        // Code for real instances
    }
}
```

### Virtual Columns

**Virtual columns** are similar to temporary columns - they exist for passing data during compilation but don't appear in the final output. They're useful for intermediate calculations or for library internal use.

```pil
col witness virtual(size) temp_data;  // Virtual witness column
```

### Conditional Compilation in Templates

```pil
airtemplate Conditional(int N = 2**16, int FEATURE_ENABLED = 0) {
    col witness a;
    
    if (FEATURE_ENABLED) {
        col witness extra;
        a === extra;
    }
}
```

---

## Air Groups

Air groups organize related AIRs together:

```pil
airgroup MyGroup {
    // Air template instantiations
    Adder(N: 2**16);
    Multiplier(N: 2**16);
    
    // Shared values
    airgroupval shared_value;
}

airgroup RangeCheckGroup {
    U8Air(N: 256);
    U16Air(N: 2**16);
}
```

---

## Lookups and Permutations

Lookups and permutations are used to verify relationships between values across different tables or air instances. These features rely on the concept of "buses" to connect query (assumes) and table (proves) sides.

> **Note:** The bus infrastructure (bus IDs, bus types, and how buses connect different components) is primarily managed by the [pil2-components](https://github.com/0xPolygonHermez/pil2-proofman/tree/main/pil2-components) standard library rather than being a core DSL feature. The DSL provides the syntax for declaring lookup and permutation constraints, while the library handles the underlying bus mechanism.

### Bus Types

There are two types of buses, based on different mathematical approaches:

1. **Sum-based buses** (`std_sum_*`): Use additive constraints. The sum of all "assumes" must equal the sum of all "proves". More efficient for lookups where multiplicity matters.

2. **Product-based buses** (`std_prod_*`): Use multiplicative constraints (grand product arguments). Useful for permutation checks where the exact multiset equality must be verified.

The choice of bus type affects performance and the type of constraints generated, but is handled by the standard library functions.

### Lookup Assumes (Query Side)

```pil
// Query a lookup table
lookup_assumes(BUS_ID, [value], selector);

// Multiple values
lookup_assumes(BUS_ID, [a, b, c], sel);

// Dynamic lookup with multiple possible bus IDs
lookup_assumes_dynamic([BUS_ID1, BUS_ID2], dynamic_bus_selector, [value], sel);
```

### Lookup Proves (Table Side)

```pil
// Provide lookup table
lookup_proves(BUS_ID, [TABLE_COL], multiplicity);

// Multiple columns
lookup_proves(BUS_ID, [COL1, COL2], mul);

// Dynamic proves
lookup_proves_dynamic(opids: [ID1, ID2], busid: BUS_SELECTOR, expressions: [VAL], mul: mul);
```

### Raw Lookup

```pil
// Bidirectional lookup (positive mul = prove, negative = assume)
lookup(BUS_ID, [expressions], multiplicity);
```

### Permutation Check

```pil
permutation_assumes(opid, [col1, col2], bus_type: BUS_TYPE);
permutation_proves(opid, [col1, col2], bus_type: BUS_TYPE);
```

---

## Range Checks

Range checks verify that values fall within specified bounds:

### Basic Range Check

```pil
// Check expression is in [min, max]
range_check(expression, min: 0, max: 255, sel: selector);

// Predefined ranges (optimized)
range_check(value, min: 0, max: 255, sel: 1, predefined: 1);  // U8
range_check(value, min: 0, max: 65535, sel: 1, predefined: 1); // U16
```

### Multi-Range Check

```pil
// Check one of two ranges based on selector
multi_range_check(expression, 
    min1: 0, max1: 255, 
    min2: 256, max2: 512, 
    range_sel: range_selector, 
    sel: row_selector);
```

### Dynamic Range Check

```pil
// Get range IDs
int id_24 = dynamic_range_check_id(0, 2**24-1);
int id_16 = dynamic_range_check_id(0, 2**16-1);

// Use dynamic selector
dynamic_range_check(expression, 
    range_sel: id_24 * sel_24 + id_16 * sel_16);
```

### Group Range Check

```pil
// Check multiple expressions with same range
range_check_group([expr1, expr2, expr3], 
    min: 0, max: 255, 
    sels: [sel1, sel2, sel3]);
```

---

## Connections

Connections verify that cells in different columns/rows are permutations:

### Online Connection (Dynamic)

```pil
// Initialize connection
connection_init(CONN_ID, [col_a, col_b, col_c]);

// Connect cells
connection_update_one_cell(CONN_ID, [col_a, row1, col_b, row2]);

// Batch cell connections
connection_update_one_cell_batch(CONN_ID, [
    [col_a, 1, col_b, 2],
    [col_b, 3, col_c, 0]
]);

// Connect multiple cells in chain
connection_update_multiple_cells(CONN_ID, [col_a, 1, col_b, 2, col_c, 3]);

// Finalize connection
connection_connect(CONN_ID);
```

### Offline Connection (Static)

```pil
// Direct connection with precomputed permutation columns
col witness a, b, c;
col fixed PERM_A, PERM_B, PERM_C;  // Precomputed permutation

connection(CONN_ID, [a, b, c], [PERM_A, PERM_B, PERM_C]);
```

---

## Hints

Hints provide information to the prover:

### Simple Hints

```pil
@hint_name expression;
@hint_name [array_of_values];
@hint_name { key: value };
```

### Complex Hints

```pil
@computation_hint {
    input_a: a,
    input_b: b,
    output: c,
    operation: "multiply"
};

@table_data [
    { col: 0, values: col_data },
    { col: 1, values: other_data }
];
```

### Hints with Expressions

```pil
@range_def {
    opid: op_id,
    min: min_value,
    max: max_value,
    type: "U8"
};
```

---

## Containers

Containers organize and namespace related data. They are essential for library development and avoiding naming conflicts.

### Container Scopes

Containers are associated with one of three scopes, indicated by the prefix in their path:

| Scope | Prefix | Lifetime | Description |
|-------|--------|----------|-------------|
| **proof** | `proof.` | Entire proof | Global to the whole proof. Shared across all airgroups and airs. |
| **airgroup** | `airgroup.` | Current airgroup | Specific to an airgroup. Each airgroup has its own instance. |
| **air** | `air.` | Current air instance | Specific to an air. Each air instance has its own instance. |

```pil
// Proof-level container: shared globally
container proof.std.lookup_data {
    int bus_count = 0;
}

// Airgroup-level container: one per airgroup
container airgroup.local {
    int operations_count = 0;
}

// Air-level container: one per air instance
container air.state {
    int row_counter = 0;
    expr accumulated;
}
```

### Container Creation Semantics

**Important:** Containers are only created and initialized if they don't already exist. This is crucial for library functions that may be called multiple times.

```pil
// First call: container is created and counter initialized to 0
container air.mylib.data {
    int counter = 0;
}

// Second call (same air): container already exists, NOT re-created
// The previous value of counter is preserved
container air.mylib.data {
    int counter = 0;  // This initialization is skipped!
}

// Subsequent access uses the existing container
air.mylib.data.counter = air.mylib.data.counter + 1;
```

This behavior allows library functions to safely declare their containers:

```pil
function my_library_function(expr value) {
    // Safe to call multiple times - only created once per air
    container air.mylib {
        int call_count = 0;
        expr values[100];
    }
    
    // Increment counter (works correctly across multiple calls)
    air.mylib.call_count = air.mylib.call_count + 1;
    air.mylib.values[air.mylib.call_count - 1] = value;
}
```

### Containers

Declares path with initial contents:

```pil
container proof.std.data {  // Closed - with definitions
    int counter = 0;
    expr values[10];
}
```

### Container with Alias

```pil
// Create/access with alias for shorter references
container proof.std.data alias mydata;

// Now can use either:
proof.std.data.counter = 1;
mydata.counter = 1;  // Same thing
```

### Using Containers

The `use` statement brings a container into scope:

```pil
use proof.std.data;
use air.local alias local;

// Access container members
local.counter = local.counter + 1;
```

### Checking Container Existence

Use the `defined()` builtin to check if a container exists:

```pil
if (defined(air.mylib.data)) {
    // Container exists, can safely access
    println("Data exists with count:", air.mylib.data.count);
} else {
    // Container doesn't exist yet
    container air.mylib.data {
        int count = 0;
    }
}
```

### Practical Example: Library Pattern

This pattern is common in standard library functions:

```pil
// In std_range_check.pil
function range_check(expr value, int min, int max, expr sel) {
    // Container created once per air, even if function called many times
    container air.std.range_check {
        int check_count = 0;
        expr checks[MAX_CHECKS];
        expr selectors[MAX_CHECKS];
    }
    
    // Store this range check request
    int idx = air.std.range_check.check_count;
    air.std.range_check.checks[idx] = value;
    air.std.range_check.selectors[idx] = sel;
    air.std.range_check.check_count = idx + 1;
    
    // Register final handler (also safe to call multiple times)
    on final air finalize_range_checks();
}

function finalize_range_checks() {
    // Process all collected range checks
    for (int i = 0; i < air.std.range_check.check_count; i++) {
        // Generate actual constraints...
    }
}
```

---

## Include and Require

### Include

Include inserts the file contents at the inclusion point:

```pil
include "path/to/file.pil";
private include "private_file.pil";  // Not re-exported
public include "public_file.pil";    // Explicitly public
```

### Require

Require ensures a file is loaded only once:

```pil
require "std_lookup.pil";
require "std_range_check.pil";
private require "internal_utils.pil";
```

---

## Pragmas

Pragmas provide compiler directives:

### Debug and Profiling

```pil
#pragma debug on                // Enable debug mode
#pragma debug off               // Disable debug mode
#pragma message Compiling main  // Print compilation message
#pragma timer compile start     // Start timer
#pragma timer compile end       // End timer and print
#pragma memory mem1 start       // Start memory tracking
#pragma memory mem1 end         // End and print memory usage
#pragma debugger                // Trigger debugger breakpoint
```

### Fixed Column Configuration

```pil
#pragma fixed_size byte         // 1 byte per element
#pragma fixed_size word         // 2 bytes per element
#pragma fixed_size dword        // 4 bytes per element
#pragma fixed_size lword        // 8 bytes per element
#pragma fixed_tmp               // Mark as temporary
#pragma fixed_external          // Load from external file
#pragma fixed_load "file.bin" 0 // Load from file, column 0
```

### Feature Flags

```pil
#pragma feature my_feature      // Enable if feature is configured
my_optional_code();             // Only executed if feature enabled
```

### Transpilation

```pil
#pragma transpile option:value
transpiled_statement;
```

## Packages

Packages are used to group related functions and avoid name collisions. This is especially important for built-in functions, as being inside a package means they don't become reserved words.

### Package Declaration

```pil
package mypackage {
    function helper(): int {
        return 42;
    }
    
    function process(int x): int {
        return x * 2;
    }
}
```

### Using Package Functions

```pil
// Call function with package prefix
int result = mypackage.helper();
int processed = mypackage.process(10);
```

### Built-in Packages

The compiler provides built-in packages like `Tables` for table manipulation:

```pil
// Tables package functions
Tables.copy(src, 0, dst, 0, 100);
Tables.fill(0, col, 0, N);
int rows = Tables.num_rows(col);
```

---

## Built-in Functions

Built-in functions are provided by the compiler and are always available. They are implemented in the `builtin/` folder and are part of a package system that prevents them from becoming reserved words.

### Inspection Functions

```pil
defined(name)                   // Check if a reference/container is defined
                                // Returns 1 if defined, 0 otherwise

length(array)                   // Get the length of an array's first dimension
                                // Returns 0 if not an array

dim(array)                      // Get the number of dimensions of an array
                                // Returns 1 for strings, 0 for non-arrays

is_array(value)                 // Check if value is an array
                                // Returns 1 if array, 0 otherwise
```

**Example:**
```pil
container mydata {
    int values[10];
}

if (defined(mydata)) {
    println("mydata exists");
    int len = length(mydata.values);  // Returns 10
    int dims = dim(mydata.values);    // Returns 1
}
```

### Math Functions

```pil
log2(value)                     // Integer base-2 logarithm
                                // log2(8) returns 3
                                // log2(0) returns 0

degree(expression)              // Get polynomial degree of an expression
                                // Returns -1 if not a polynomial
```

### Output Functions

```pil
println(arg1, arg2, ...)        // Print arguments separated by spaces, with newline
                                // Accepts multiple arguments of any type

error("message")                // Print error message and abort compilation
                                // Use for unrecoverable errors

dump(value)                     // Debug dump of internal representation
                                // Useful for debugging complex expressions
```

### Type Functions

```pil
cast("type", value)             // Cast value to specified type
                                // Supported: "string", "fe"

evaluate(row, expression)       // Evaluate expression at specific row
                                // Returns the computed value
```

### Assertion Functions

```pil
assert(condition)               // Assert condition is true
assert(condition, "message")    // Assert with custom message

assert_eq(a, b)                 // Assert a equals b
assert_eq(a, b, "message")      // Assert equality with message

assert_not_eq(a, b)             // Assert a not equals b
assert_not_eq(a, b, "message") // Assert inequality with message
```

When `#pragma test` is active, failed assertions increment the test failure counter instead of aborting:

```pil
#pragma test
assert_eq(computed, expected, "Computation should match");
```

### Table Functions (Tables.* package)

Functions for manipulating fixed column data at compile time:

```pil
Tables.copy(src, src_offset, dst, dst_offset, count)
// Copy 'count' rows from src column to dst column
// src, dst: fixed columns
// Returns number of rows copied

Tables.fill(value, dst, offset, count)
// Fill 'count' rows of dst column with 'value' starting at 'offset'
// Returns number of rows filled

Tables.num_rows(col)
// Get the current number of filled rows in a fixed column

Tables.print(col, offset, count)
// Print 'count' rows from column starting at 'offset' (debug)
```

**Example:**
```pil
col fixed TABLE[256];

// Fill first 128 rows with 0
Tables.fill(0, TABLE, 0, 128);

// Fill remaining with 1
Tables.fill(1, TABLE, 128, 128);

// Check filled count
int rows = Tables.num_rows(TABLE);  // Returns 256
```

---

## Built-in Constants

| Constant | Description |
|----------|-------------|
| `PRIME` | The field prime |
| `N` | Number of rows in current air |
| `BITS` | log2(N) |
| `AIRGROUP` | Current airgroup name |
| `AIRGROUP_ID` | Current airgroup identifier |
| `AIR_ID` | Current air identifier |
| `AIR_NAME` | Current air name |
| `AIRTEMPLATE` | Current air template name |
| `VIRTUAL` | 1 if inside virtual instantiation |

---

## Complete Example

```pil
require "std_lookup.pil";
require "std_range_check.pil";

const int BUS_ID = 1000;
const int MAX_VALUE = 2**8 - 1;

// Define a simple adder with overflow check
airtemplate SafeAdder(const int N = 2**16) {
    // Input columns
    col witness bits(8) a, b;
    
    // Output column (9 bits to handle overflow)
    col witness bits(9) sum;
    
    // Overflow flag
    col witness bits(1) overflow;
    
    // Selector for active rows
    col fixed ACTIVE = [1:(N-1), 0];
    
    // Main constraint: a + b = sum
    ACTIVE * (a + b - sum) === 0;
    
    // Overflow detection
    ACTIVE * overflow * (sum - 256) === 0;
    ACTIVE * (1 - overflow) * (255 - sum + 1) === 0;
    
    // Range check inputs
    range_check(a, min: 0, max: MAX_VALUE, sel: ACTIVE, predefined: 1);
    range_check(b, min: 0, max: MAX_VALUE, sel: ACTIVE, predefined: 1);
    
    // Provide results to lookup bus
    lookup_proves(BUS_ID, [a, b, sum, overflow], mul: ACTIVE);
    
    // Hint for prover
    @adder_hint {
        inputs: [a, b],
        outputs: [sum, overflow]
    };
}

// Instantiate the air template
airgroup Arithmetic {
    SafeAdder(N: 2**18) alias MainAdder;
}
```
