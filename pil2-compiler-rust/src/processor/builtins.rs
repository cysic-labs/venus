//! Built-in functions: println, assert, assert_eq, length, dim, log2, cast,
//! defined, degree, error, evaluate, is_array, dump.
//!
//! Mirrors the JS `builtin/*.js` files. Each built-in is a function that
//! can be called from PIL2 source code at compile time.

use super::expression::Value;

/// Identifies which built-in function to call.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum BuiltinKind {
    Println,
    Assert,
    AssertEq,
    AssertNotEq,
    Length,
    Dim,
    Log2,
    Cast,
    Defined,
    Degree,
    Error,
    Evaluate,
    IsArray,
    Dump,
    Log,
}

impl BuiltinKind {
    /// Map a function name to its builtin kind.
    pub fn from_name(name: &str) -> Option<Self> {
        match name {
            "println" => Some(Self::Println),
            "assert" => Some(Self::Assert),
            "assert_eq" => Some(Self::AssertEq),
            "assert_not_eq" => Some(Self::AssertNotEq),
            "length" => Some(Self::Length),
            "dim" => Some(Self::Dim),
            "log2" => Some(Self::Log2),
            "cast" => Some(Self::Cast),
            "defined" => Some(Self::Defined),
            "degree" => Some(Self::Degree),
            "error" => Some(Self::Error),
            "evaluate" => Some(Self::Evaluate),
            "is_array" => Some(Self::IsArray),
            "dump" => Some(Self::Dump),
            "log" => Some(Self::Log),
            _ => None,
        }
    }

    pub fn name(&self) -> &'static str {
        match self {
            Self::Println => "println",
            Self::Assert => "assert",
            Self::AssertEq => "assert_eq",
            Self::AssertNotEq => "assert_not_eq",
            Self::Length => "length",
            Self::Dim => "dim",
            Self::Log2 => "log2",
            Self::Cast => "cast",
            Self::Defined => "defined",
            Self::Degree => "degree",
            Self::Error => "error",
            Self::Evaluate => "evaluate",
            Self::IsArray => "is_array",
            Self::Dump => "dump",
            Self::Log => "log",
        }
    }

    /// List all builtin names.
    pub fn all_names() -> &'static [&'static str] {
        &[
            "println",
            "assert",
            "assert_eq",
            "assert_not_eq",
            "length",
            "dim",
            "log2",
            "cast",
            "defined",
            "degree",
            "error",
            "evaluate",
            "is_array",
            "dump",
            "log",
        ]
    }
}

/// Test tracking for `#pragma test` / assert builtins.
#[derive(Debug, Clone, Default)]
pub struct TestTracker {
    pub active: bool,
    pub ok: u32,
    pub fail: u32,
    pub messages: Vec<String>,
}

/// Execute a built-in function with the given arguments.
///
/// Returns `Ok(value)` on success, or `Err(message)` on failure.
pub fn exec_builtin(
    kind: BuiltinKind,
    args: &[Value],
    source_ref: &str,
    tests: &mut TestTracker,
) -> Result<Value, String> {
    match kind {
        BuiltinKind::Println => exec_println(args),
        BuiltinKind::Assert => exec_assert(args, source_ref, tests),
        BuiltinKind::AssertEq => exec_assert_eq(args, source_ref, tests),
        BuiltinKind::AssertNotEq => exec_assert_not_eq(args, source_ref, tests),
        BuiltinKind::Length => exec_length(args),
        BuiltinKind::Dim => exec_dim(args),
        BuiltinKind::Log2 => exec_log2(args),
        BuiltinKind::Cast => exec_cast(args),
        BuiltinKind::Defined => exec_defined(args),
        BuiltinKind::Degree => exec_degree(args),
        BuiltinKind::Error => exec_error(args, source_ref),
        BuiltinKind::Evaluate => exec_evaluate(args),
        BuiltinKind::IsArray => exec_is_array(args),
        BuiltinKind::Dump => exec_dump(args),
        BuiltinKind::Log => Ok(Value::Int(0)),
    }
}

fn exec_println(args: &[Value]) -> Result<Value, String> {
    let parts: Vec<String> = args.iter().map(|a| a.to_display_string()).collect();
    println!("  > {}", parts.join(" "));
    Ok(Value::Int(0))
}

fn exec_assert(
    args: &[Value],
    source_ref: &str,
    tests: &mut TestTracker,
) -> Result<Value, String> {
    if args.is_empty() || args.len() > 2 {
        return Err("assert: expected 1 or 2 arguments".to_string());
    }
    let cond = args[0].as_bool().unwrap_or(false);
    if !cond {
        let extra = if args.len() > 1 {
            format!("{}\n", args[1].to_display_string())
        } else {
            String::new()
        };
        let msg = format!("{}Assert fails at {}", extra, source_ref);
        if tests.active {
            tests.fail += 1;
            tests.messages.push(msg);
        } else {
            return Err(msg);
        }
    } else if tests.active {
        tests.ok += 1;
    }
    Ok(Value::Int(0))
}

fn exec_assert_eq(
    args: &[Value],
    source_ref: &str,
    tests: &mut TestTracker,
) -> Result<Value, String> {
    if args.len() < 2 || args.len() > 3 {
        return Err("assert_eq: expected 2 or 3 arguments".to_string());
    }
    if args[0] != args[1] {
        let extra = if args.len() > 2 {
            format!("{}\n", args[2].to_display_string())
        } else {
            String::new()
        };
        let msg = format!(
            "{}Assert fails ({} === {}) at {}",
            extra,
            args[0].to_display_string(),
            args[1].to_display_string(),
            source_ref
        );
        if tests.active {
            tests.fail += 1;
            tests.messages.push(msg);
        } else {
            return Err(msg);
        }
    } else if tests.active {
        tests.ok += 1;
    }
    Ok(Value::Int(0))
}

fn exec_assert_not_eq(
    args: &[Value],
    source_ref: &str,
    tests: &mut TestTracker,
) -> Result<Value, String> {
    if args.len() < 2 || args.len() > 3 {
        return Err("assert_not_eq: expected 2 or 3 arguments".to_string());
    }
    if args[0] == args[1] {
        let extra = if args.len() > 2 {
            format!("{}\n", args[2].to_display_string())
        } else {
            String::new()
        };
        let msg = format!(
            "{}Assert fails ({} !== {}) at {}",
            extra,
            args[0].to_display_string(),
            args[1].to_display_string(),
            source_ref
        );
        if tests.active {
            tests.fail += 1;
            tests.messages.push(msg);
        } else {
            return Err(msg);
        }
    } else if tests.active {
        tests.ok += 1;
    }
    Ok(Value::Int(0))
}

fn exec_length(args: &[Value]) -> Result<Value, String> {
    if args.len() != 1 {
        return Err("length: expected 1 argument".to_string());
    }
    let len = match &args[0] {
        Value::Str(s) => s.len() as i128,
        Value::Array(items) => items.len() as i128,
        _ => 0,
    };
    Ok(Value::Int(len))
}

fn exec_dim(args: &[Value]) -> Result<Value, String> {
    if args.len() != 1 {
        return Err("dim: expected 1 argument".to_string());
    }
    let dim = match &args[0] {
        Value::Str(_) => 1i128,
        Value::Array(_) => 1i128, // dimensionality of 1 for any array
        _ => 0,
    };
    Ok(Value::Int(dim))
}

fn exec_log2(args: &[Value]) -> Result<Value, String> {
    if args.len() != 1 {
        return Err("log2: expected 1 argument".to_string());
    }
    let val = args[0]
        .as_int()
        .ok_or_else(|| "log2: argument must be integer".to_string())?;

    if val == 0 {
        return Ok(Value::Int(0));
    }

    let mut v = if val < 0 { -val } else { val };
    let mut result: i128 = 0;
    while v > 1 {
        v >>= 1;
        result += 1;
    }
    Ok(Value::Int(result))
}

fn exec_cast(args: &[Value]) -> Result<Value, String> {
    if args.len() != 2 {
        return Err("cast: expected 2 arguments (type, value)".to_string());
    }
    let cast_type = match &args[0] {
        Value::Str(s) => s.as_str(),
        _ => return Err("cast: first argument must be a string type name".to_string()),
    };
    match cast_type {
        "string" => Ok(Value::Str(args[1].to_display_string())),
        "fe" => {
            let v = args[1]
                .as_int()
                .ok_or_else(|| "cast to fe: value must be integer".to_string())?;
            // Wrap into field element range (simplified).
            Ok(Value::Fe(v as u64))
        }
        "int" => {
            let v = args[1]
                .as_int()
                .ok_or_else(|| "cast to int: value must be numeric".to_string())?;
            Ok(Value::Int(v))
        }
        _ => Err(format!("cast: unsupported target type '{}'", cast_type)),
    }
}

fn exec_defined(args: &[Value]) -> Result<Value, String> {
    if args.len() != 1 {
        return Err("defined: expected 1 argument".to_string());
    }
    // At the builtin level, we can only check if the value is non-void.
    // The processor handles reference-level `defined` checks before calling
    // this builtin.
    let is_defined = !matches!(&args[0], Value::Void);
    Ok(Value::Int(if is_defined { 1 } else { 0 }))
}

fn exec_degree(args: &[Value]) -> Result<Value, String> {
    if args.len() != 1 {
        return Err("degree: expected 1 argument".to_string());
    }
    // Compile-time degree analysis requires expression introspection.
    // For constant values, degree is 0.
    let degree = match &args[0] {
        Value::Int(_) | Value::Fe(_) | Value::Bool(_) => 0,
        Value::ColRef { .. } => 1,
        Value::RuntimeExpr(_) => -1i128, // unknown at compile time
        _ => 0,
    };
    Ok(Value::Int(degree))
}

fn exec_error(args: &[Value], source_ref: &str) -> Result<Value, String> {
    let msg = if args.is_empty() {
        format!("error at {}", source_ref)
    } else {
        let parts: Vec<String> = args.iter().map(|a| a.to_display_string()).collect();
        format!("{} at {}", parts.join(" "), source_ref)
    };
    Err(msg)
}

fn exec_evaluate(args: &[Value]) -> Result<Value, String> {
    // `evaluate` in the JS compiler forces compile-time evaluation.
    // For constant values, just return them.
    if args.len() != 1 {
        return Err("evaluate: expected 1 argument".to_string());
    }
    Ok(args[0].clone())
}

fn exec_is_array(args: &[Value]) -> Result<Value, String> {
    if args.len() != 1 {
        return Err("is_array: expected 1 argument".to_string());
    }
    let result = matches!(&args[0], Value::Array(_));
    Ok(Value::Int(if result { 1 } else { 0 }))
}

fn exec_dump(args: &[Value]) -> Result<Value, String> {
    for (i, arg) in args.iter().enumerate() {
        eprintln!("  [dump {}] {:?}", i, arg);
    }
    Ok(Value::Int(0))
}

#[cfg(test)]
mod tests {
    use super::*;

    fn test_tracker() -> TestTracker {
        TestTracker::default()
    }

    #[test]
    fn test_println() {
        let mut t = test_tracker();
        let result = exec_builtin(
            BuiltinKind::Println,
            &[Value::Str("hello".into()), Value::Int(42)],
            "",
            &mut t,
        );
        assert!(result.is_ok());
    }

    #[test]
    fn test_assert_pass() {
        let mut t = test_tracker();
        t.active = true;
        let r = exec_builtin(BuiltinKind::Assert, &[Value::Bool(true)], "t:1", &mut t);
        assert!(r.is_ok());
        assert_eq!(t.ok, 1);
        assert_eq!(t.fail, 0);
    }

    #[test]
    fn test_assert_fail_in_test_mode() {
        let mut t = test_tracker();
        t.active = true;
        let r = exec_builtin(BuiltinKind::Assert, &[Value::Bool(false)], "t:1", &mut t);
        assert!(r.is_ok()); // does not error in test mode
        assert_eq!(t.fail, 1);
    }

    #[test]
    fn test_assert_fail_not_test_mode() {
        let mut t = test_tracker();
        let r = exec_builtin(BuiltinKind::Assert, &[Value::Bool(false)], "t:1", &mut t);
        assert!(r.is_err());
    }

    #[test]
    fn test_assert_eq_pass() {
        let mut t = test_tracker();
        let r = exec_builtin(
            BuiltinKind::AssertEq,
            &[Value::Int(5), Value::Int(5)],
            "t:1",
            &mut t,
        );
        assert!(r.is_ok());
    }

    #[test]
    fn test_assert_eq_fail() {
        let mut t = test_tracker();
        let r = exec_builtin(
            BuiltinKind::AssertEq,
            &[Value::Int(5), Value::Int(6)],
            "t:1",
            &mut t,
        );
        assert!(r.is_err());
    }

    #[test]
    fn test_length() {
        let mut t = test_tracker();
        let r = exec_builtin(
            BuiltinKind::Length,
            &[Value::Array(vec![Value::Int(1), Value::Int(2), Value::Int(3)])],
            "",
            &mut t,
        )
        .unwrap();
        assert_eq!(r, Value::Int(3));
    }

    #[test]
    fn test_log2() {
        let mut t = test_tracker();
        assert_eq!(
            exec_builtin(BuiltinKind::Log2, &[Value::Int(1024)], "", &mut t).unwrap(),
            Value::Int(10)
        );
        assert_eq!(
            exec_builtin(BuiltinKind::Log2, &[Value::Int(1)], "", &mut t).unwrap(),
            Value::Int(0)
        );
        assert_eq!(
            exec_builtin(BuiltinKind::Log2, &[Value::Int(0)], "", &mut t).unwrap(),
            Value::Int(0)
        );
    }

    #[test]
    fn test_cast_to_string() {
        let mut t = test_tracker();
        let r = exec_builtin(
            BuiltinKind::Cast,
            &[Value::Str("string".into()), Value::Int(42)],
            "",
            &mut t,
        )
        .unwrap();
        assert_eq!(r, Value::Str("42".into()));
    }

    #[test]
    fn test_is_array() {
        let mut t = test_tracker();
        assert_eq!(
            exec_builtin(BuiltinKind::IsArray, &[Value::Array(vec![])], "", &mut t).unwrap(),
            Value::Int(1)
        );
        assert_eq!(
            exec_builtin(BuiltinKind::IsArray, &[Value::Int(5)], "", &mut t).unwrap(),
            Value::Int(0)
        );
    }

    #[test]
    fn test_error_builtin() {
        let mut t = test_tracker();
        let r = exec_builtin(
            BuiltinKind::Error,
            &[Value::Str("something failed".into())],
            "src:1",
            &mut t,
        );
        assert!(r.is_err());
        assert!(r.unwrap_err().contains("something failed"));
    }

    #[test]
    fn test_defined_builtin() {
        let mut t = test_tracker();
        assert_eq!(
            exec_builtin(BuiltinKind::Defined, &[Value::Int(5)], "", &mut t).unwrap(),
            Value::Int(1)
        );
        assert_eq!(
            exec_builtin(BuiltinKind::Defined, &[Value::Void], "", &mut t).unwrap(),
            Value::Int(0)
        );
    }
}
