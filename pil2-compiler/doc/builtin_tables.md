# Builtin Package: `Tables`

`Tables` is a built-in package for working with **fixed columns**. Every function
takes a single fixed column (not an array of columns) and operates on a row
range of it.

## Conventions

- **Ranges** are given as `offset` and `count` and are half-open:
  `[offset, offset + count)`.
- For the **analysis** and **comparison** builtins, `offset` (default `0`) and
  `count` (default: to the end of the column) are optional. For the **basic
  operations** (`copy`, `fill`, `print`) all arguments are required.
- All functions operate on the **raw stored values** of the column; no modular
  field reduction is applied to the comparisons.
- Boolean-style results are returned as `1` (true) or `0` (false).
- Reading a row that was never set (possible in columns holding values wider
  than 64 bits) raises an error reporting the global row index.

## Contents

- [Basic operations](#basic-operations)
  - [num_rows](#num_rows)
  - [get_value](#get_value)
  - [copy](#copy)
  - [fill](#fill)
  - [print](#print)
- [Comparison builtins](#comparison-builtins)
  - [is_constant](#is_constant)
  - [is_sequence](#is_sequence)
  - [signature](#signature)
  - [are_equals](#are_equals)
  - [comparative_signature](#comparative_signature)
  - [compatible_offset](#compatible_offset)
- [Table analysis](#table-analysis)
  - [analyze](#analyze)
  - [get_analyzed_type](#get_analyzed_type)
  - [get_analyzed_signature](#get_analyzed_signature)
  - [get_analyzed_comparative_signature](#get_analyzed_comparative_signature)
  - [get_analyzed_size](#get_analyzed_size)
  - [get_analyzed_range_values](#get_analyzed_range_values)
  - [get_analyzed_bits](#get_analyzed_bits)
  - [get_analyzed_params](#get_analyzed_params)
  - [get_analyzed_cycle](#get_analyzed_cycle)
  - [get_analyzed_partitions](#get_analyzed_partitions)

---

## Basic operations

### num_rows

**`Tables.num_rows(col)`** → the number of rows of a fixed column.

```
int rows = Tables.num_rows(my_fixed_col);
```

### get_value

**`Tables.get_value(col, index)`** → the value stored at row `index`. Reading
past the last row (or a negative index) is an error.

```
int v = Tables.get_value(my_fixed_col, 3);
```

The column can be given in any form that evaluates to a single fixed column: the
column name, an array element, an `expr` variable holding it, or a `col fixed`
function argument. Virtual (`temporal(n)`) and non-virtual columns work alike.

### copy

**`Tables.copy(src, src_offset, dst, dst_offset, count)`** → copies `count` rows
starting at row `src_offset` of `src` into `dst` starting at `dst_offset`.

When both columns use the same storage width the rows are copied as a single
block; otherwise they are copied element by element, resizing the destination
if a value does not fit its current width.

```
Tables.copy(big_fixed_col, 0, small_fixed_col, 16, 32);
```

### fill

**`Tables.fill(value, dst, offset, count)`** → fills `count` rows of `dst`
starting at `offset` with `value`.

```
Tables.fill(0xFFFF, my_fixed_col, 0, 32);
```

### print

**`Tables.print(col, offset, count)`** → prints `count` rows of `col` starting at
`offset`. Intended for debugging.

```
Tables.print(my_fixed_col, 16, 32);
```

---

## Comparison builtins

### is_constant

**`Tables.is_constant(col, offset, count)`** → `1` if every value in the range is
equal, `0` otherwise. An empty range or a single value is trivially constant.

```
// whole column constant?
assert_eq(Tables.is_constant(col), 1);
// only rows [0, 8) constant?
assert_eq(Tables.is_constant(col, 0, 8), 1);
```

### is_sequence

**`Tables.is_sequence(col, offset, count, delta)`** → `1` if the range is an
arithmetic progression (`value[i+1] == value[i] + delta`), `0` otherwise.
If `delta` is omitted it is inferred from the first two values of the range
(i.e. it just checks "is this an arithmetic progression?").

```
// arithmetic progression with any step?
assert_eq(Tables.is_sequence(col), 1);
// specifically step 1 over the first 8 rows?
assert_eq(Tables.is_sequence(col, 0, 8, 1), 1);
```

A constant column is a delta-0 sequence: `Tables.is_sequence(col, 0, N, 0) == 1`.

### signature

**`Tables.signature(col, offset, count)`** → a non-cryptographic 64-bit hash of
the range. It is order- and length-sensitive: two ranges hash equal **iff** they
hold the same values in the same order. Meant to cheaply detect whether two
tables are identical; not resistant to adversarial collisions (~2⁻⁶⁴ chance).

```
// equal iff the two columns hold the same data
assert_eq(Tables.signature(a) == Tables.signature(b), 1);
```

### are_equals

**`Tables.are_equals(src1, offset1, src2, offset2, count)`** → `1` if
`src1[offset1 + i] == src2[offset2 + i]` for every `i` in `[0, count)`, `0`
otherwise. The two windows may start at different offsets, and columns of
different byte widths are compared by value. An empty range (`count == 0`) is
trivially equal.

`count` is optional. When omitted, both windows extend to the end of their
column; if the remaining lengths differ, the windows are simply **not equal**
(returns `0`). An **explicit** `count` that exceeds either column is an error.

```
// are a[0..8) and b[0..8) equal?
assert_eq(Tables.are_equals(a, 0, b, 0, 8), 1);
// are the whole tables equal? (different sizes -> 0, no need to check num_rows)
assert_eq(Tables.are_equals(a, 0, b, 0), 1);
```

This is an exact, element-by-element check (no collision risk, unlike comparing
signatures).

### comparative_signature

**`Tables.comparative_signature(col, offset, count)`** → a signature that is
invariant to:

- a **value shift** (`delta`): the column's minimum is subtracted first, so a
  table `T` and `T + delta` produce the same signature;
- a **cyclic row rotation** (`row_offset`): values are aggregated with
  commutative power sums, so row order does not change the result.

Two tables can be *compatible* — equal up to some `row_offset` and `delta` — only
if their comparative signatures match. A match is a **candidate** that still has
to be confirmed with [compatible_offset](#compatible_offset), because the
aggregation is permutation-invariant (looser than rotation-invariant).

```
if (Tables.comparative_signature(a) == Tables.comparative_signature(b)) {
    // a and b are candidates: confirm and get the shift
    int r = Tables.compatible_offset(a, 0, b, 0, N);
    ...
}
```

### compatible_offset

**`Tables.compatible_offset(src1, offset1, src2, offset2, count)`** → the
`row_offset` `r` that makes `src2` a shifted copy of `src1`, or `-1` if they are
not compatible (`count` is optional, defaulting to `src1.rows - offset1`).

When `r >= 0` the following holds:

```
src2[offset2 + i] == src1[offset1 + ((i + r) mod count)] + delta
```

so `delta` is recovered trivially:

```
delta = src2[offset2] - src1[offset1 + r]
```

Internally each window is normalized by subtracting its own minimum (cancelling
`delta`), then a cyclic-rotation match is found with KMP in `O(count)`.

```
int r = Tables.compatible_offset(a, 0, b, 0, N);
// r == -1  -> not compatible
// r >= 0   -> b[i] == a[(i + r) mod N] + (b[0] - a[r])
```

---

## Table analysis

`Tables.analyze` inspects a fixed column in a **single pass** and returns an
integer **analysis id**. That id is then passed as the first argument to the
`get_analyzed_*` builtins to read the different results, so the column is scanned
only once.

### analyze

**`Tables.analyze(col, offset, count)`** → an analysis id (`offset` and `count`
optional).

```
int id = Tables.analyze(col);
int kind = Tables.get_analyzed_type(id);
```

### get_analyzed_type

**`Tables.get_analyzed_type(id)`** → the detected pattern type. When several
patterns match, the lowest-numbered (most specific) one is reported.

| value | type                | meaning                                                              |
|-------|---------------------|---------------------------------------------------------------------|
| `0`   | nothing             | no recognizable pattern                                             |
| `1`   | constant            | all values are equal                                               |
| `2`   | sequential          | `value[i+1] == value[i] + delta`                                    |
| `3`   | constant-partitions | every 2¹⁶ partition is constant (only when `count` is a multiple of 2¹⁶) |
| `4`   | cycle               | an arithmetic ramp repeated: `value[i] == first + (i mod len)*delta` |

### get_analyzed_signature

**`Tables.get_analyzed_signature(id)`** → the content signature of the analyzed
range (same non-cryptographic hash as [signature](#signature)).

### get_analyzed_comparative_signature

**`Tables.get_analyzed_comparative_signature(id)`** → the comparative signature of
the analyzed range: the same value [comparative_signature](#comparative_signature)
returns for that range, but taken from the single analysis pass. Use it to filter
compatible-table candidates without scanning the columns again, then confirm with
[compatible_offset](#compatible_offset).

```
int ida = Tables.analyze(a);
int idb = Tables.analyze(b);
if (Tables.get_analyzed_comparative_signature(ida) == Tables.get_analyzed_comparative_signature(idb)) {
    int r = Tables.compatible_offset(a, 0, b, 0, N);   // -1 if not compatible
    if (r >= 0) {
        int delta = b[0] - a[r];                       // b[i] == a[(i + r) mod N] + delta
    }
}
```

### get_analyzed_size

**`Tables.get_analyzed_size(id)`** → `int[2]` = `[offset, size]`, the range that
was analyzed.

```
const int sz[2] = Tables.get_analyzed_size(id);   // sz[0]=offset, sz[1]=size
```

### get_analyzed_range_values

**`Tables.get_analyzed_range_values(id)`** → `int[2]` = `[min, max]`, the minimum
and maximum value found.

```
const int rv[2] = Tables.get_analyzed_range_values(id);
```

### get_analyzed_bits

**`Tables.get_analyzed_bits(id)`** → the number of bits needed to represent every
analyzed value, derived from `min` and `max`. If the values are signed
(`min < 0`), the returned bit count is **negative** (two's-complement width).

> Note: fixed columns store field elements, so stored values are always
> non-negative; the signed (negative) result only occurs on raw value arrays
> whose minimum is negative.

### get_analyzed_params

**`Tables.get_analyzed_params(id)`** → the minimal parameters that regenerate the
detected pattern, as an `int` array:

| type                    | result             |
|-------------------------|--------------------|
| `1` constant            | `[constant_value]` |
| `2` sequential          | `[first_value, delta]` |
| `4` cycle               | `[first_element]`  |
| `0` nothing / `3` parts | *error*            |

```
const int p[2] = Tables.get_analyzed_params(id);   // sequential: [first, delta]
```

### get_analyzed_cycle

**`Tables.get_analyzed_cycle(id)`** → `int[3]` = `[cycle_length, repetitions, delta]`.
Only valid when the type is `4` (cycle); errors otherwise.

```
const int c[3] = Tables.get_analyzed_cycle(id);    // [length, repetitions, delta]
```

### get_analyzed_partitions

**`Tables.get_analyzed_partitions(id)`** → the constant value of each partition,
as an `int` array. Only valid when the type is `3` (constant-partitions);
errors otherwise.

Partitions are computed on 2¹⁶ chunks and then **compacted** to the minimum
number of uniform partitions: while every adjacent pair of chunks shares the same
constant, the list is halved. For example, a `2^20` block whose constant changes
every `2^17` returns 8 values instead of 16 (the caller knows the total size, so
each returned partition spans `2^20 / 8`).

```
const int parts[2] = Tables.get_analyzed_partitions(id);   // e.g. [5, 9]
```
