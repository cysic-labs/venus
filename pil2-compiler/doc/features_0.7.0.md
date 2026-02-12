## Release 0.7.0

The main features of this release are:

- Export fixed rows to external files
- Loading fixed data from external files
- Packages
- New features for fixed columns (bits, temporal)
- Virtual instantiation of AirTemplates

---

### Export fixed rows to external files
This feature allows generating values of fixed rows in an external fixed file outside of pilout. It reduces compilation time, because one of the problems was the proto generation from JavaScript. To generate it previously required a JSON with all information, which consumed a lot of memory and CPU. For example, compilation of zisk files was reduced from more than one hour to one-two minutes.

To use this feature, you can use the options `[-u|--outputdir] <output_directory> -O fixed-to-file` or option `[-f|--fixed] <fixed_files_output_directory>`.

Inside the `output_directory` or `fixed_files_output_directory` you can use variables such as AIRGROUP, AIRGROUP_ID, AIR_ID, AIR_NAME, AIRTEMPLATE with format `${<varname>}` for example `build/provingKey/${AIRGROUP}/${AIRNAME}`

### Loading fixed data from external files
Used to load data from external files. The external file contains metadata about the column name, index, and airgroup. To define this file, use the `pragma extern_fixed_file`. The scope of this pragma is the air. When a new fixed column is declared, if external files are defined, it tries to find the column inside and initialize the fixed column.

The syntax is `#pragma extern_fixed_file <filename>` where filename can be a template string. The pragma arguments are considered as space-separated literals; you cannot use variables because they are considered as text.

Example of use:
```
#pragma extern_fixed_file "../src/keccakf_fixed.bin"
```

### Packages
This feature allows you to group functions within a package, which also frees up the global namespace. This functionality was added because the number of built-ins is growing.
```
package MyLibrary {
    function duplicate(int n): int {
        return n * 2;
    }
}
MyLibrary.duplicate(3);
```
Another characteristic of packages is that, by default, functions created inside are private. You can make a function public (exportable) using the `public` keyword as follows:
```
package MyLibrary {
    public function foo(int n): int {
        return dup(n) * dup(n+1);
    }
    function dup(int n): int {
        return n * 2;
    }
}
MyLibrary.foo(3);
```

Inside a package, when calling another internal function, it is not necessary to specify the package name. When resolving a reference, the compiler first searches within the current package.

Packages also support the `use` statement with aliases, using the following syntax:
```
use MyLibrary.foo as library_foo;
```

### New Features for Fixed Columns
Columns can now define additional "features" such as:
- **temporal([<num_rows>])**: This feature was previously available via a pragma, but now you can define a fixed column as temporal. This means the column is not defined in the pilout; it is only used to facilitate the generation of other tables or to transfer information between functions.
```
col fixed temporal() my_temporal_col_with_default_rows;
col fixed temporal(8000) my_temporal_col_with_8000_rows;
```
- **bits(<num_bits>[,signed|unsigned])**: This feature adds extra information to the witness about the number of bits used for its representation. **IMPORTANT**: This feature does not add any constraint; it is only **extra information** for witness computation.
```
col witness bits(1) enable;
enable * (1 - enable) === 0;

col witness bits(16) chunks[4];
col witness bits(21) carry;
```

### Virtual Instantiation


A virtual instantiation specifies that an AirTemplate instance is virtual. This means it creates a virtual AirTemplate that will **not** be included in the final `pilout`. This mechanism allows libraries (such as `std`) to access the instance information without generating output to pilout.


#### Key characteristics:

- The special variable **`VIRTUAL`** is set to `1` inside a virtual AirTemplate, and `0` otherwise.
- The **number of rows** (`N`) in a virtual AirTemplate **does not need to be a power of 2**. This is especially useful when the AirTemplate contains a table, as it allows specifying the exact number of rows without padding.
- For security reasons, a virtual AirTemplate **cannot have constraints**. If air constraints are defined inside a virtual AirTemplate, an error will be thrown.

This feature allows users to define their air tables as virtual, without needing to split or join them. Later, a library such as `std` can manage these virtual tables, combining them into a single air with a specific number of rows or other desired configurations.

Example:
```
virtual myAirTable();
```

#### Package Tables

To efficiently manage tables, the `Tables` package was created as a built-in package.
The following functions are available:
- **num_rows(col)**: Returns the number of rows of a fixed column.
    ```
    int rows = Tables.num_rows(my_fixed_col);
    ```
- **copy(src_col, src_offset, dst_col, dst_offset, count)**: Copy `<count>` rows starting from row `<src_offset>` of `<src_col>` to `<dst_offset>` in `<dst_col>`.
    ```
    Tables.copy(big_fixed_col, 0, small_fixed_col, 16, 32);
    ```
- **fill(value, dst_col, offset, count)**: Fill `<count>` rows starting from row `<offset>` with value `<value>`.
    ```
    Tables.fill(0xFFFF, my_fixed_col, 0, 32);
    ```
- **print(col, offset, count)**: Used for debugging purposes, print `<count>` rows of `<col>` starting from row `<offset>`.
    ```
    Tables.print(my_fixed_col, 16, 32);
    ```