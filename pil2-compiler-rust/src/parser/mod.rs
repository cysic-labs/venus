pub mod ast;
pub mod lexer;

// The LALRPOP-generated parser module.
// The build script compiles grammar.lalrpop into grammar.rs in OUT_DIR.
#[allow(
    clippy::all,
    unused_parens,
    unused_imports,
    dead_code,
    unreachable_patterns
)]
mod grammar {
    include!(concat!(env!("OUT_DIR"), "/parser/grammar.rs"));
}

use ast::Program;
use lexer::{Lexer, LexError};

/// Parse error type returned by the public `parse` function.
#[derive(Debug)]
pub enum ParseError {
    LexError(LexError),
    GrammarError(String),
}

impl std::fmt::Display for ParseError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            ParseError::LexError(e) => write!(f, "{}", e),
            ParseError::GrammarError(msg) => write!(f, "parse error: {}", msg),
        }
    }
}

impl std::error::Error for ParseError {}

/// Parse a PIL2 source string into an AST `Program`.
pub fn parse(source: &str) -> Result<Program, ParseError> {
    let lexer = Lexer::new(source);
    grammar::ProgramParser::new()
        .parse(lexer)
        .map_err(|e| match e {
            lalrpop_util::ParseError::User { error } => ParseError::LexError(error),
            other => ParseError::GrammarError(format!("{}", other)),
        })
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

#[cfg(test)]
mod tests {
    use super::*;
    use crate::parser::ast::*;

    #[test]
    fn test_parse_empty() {
        let prog = parse("").unwrap();
        assert!(prog.statements.is_empty());
    }

    #[test]
    fn test_parse_require() {
        let prog = parse(r#"require "std_lookup.pil""#).unwrap();
        assert_eq!(prog.statements.len(), 1);
        match &prog.statements[0] {
            Statement::Include(inc) => {
                assert_eq!(inc.kind, IncludeKind::Require);
                assert_eq!(inc.path.value, "std_lookup.pil");
            }
            other => panic!("expected Include, got {:?}", other),
        }
    }

    #[test]
    fn test_parse_multiple_requires() {
        let source = r#"
            require "std_lookup.pil"
            require "std_permutation.pil"
        "#;
        let prog = parse(source).unwrap();
        assert_eq!(prog.statements.len(), 2);
    }

    #[test]
    fn test_parse_const_int() {
        let source = "const int BOOT_ADDR = 0x1000;";
        let prog = parse(source).unwrap();
        assert_eq!(prog.statements.len(), 1);
        match &prog.statements[0] {
            Statement::VariableDeclaration(vd) => {
                assert!(vd.is_const);
                assert_eq!(vd.vtype, TypeKind::Int);
                assert_eq!(vd.items[0].name, "BOOT_ADDR");
            }
            other => panic!("expected VariableDeclaration, got {:?}", other),
        }
    }

    #[test]
    fn test_parse_airgroup() {
        let source = r#"
            airgroup MyGroup {
                col witness a, b;
                col fixed ZERO = [0]*;
            }
        "#;
        let prog = parse(source).unwrap();
        assert_eq!(prog.statements.len(), 1);
        match &prog.statements[0] {
            Statement::AirGroupDef(ag) => {
                assert_eq!(ag.name, "MyGroup");
                assert!(ag.statements.len() >= 2);
            }
            other => panic!("expected AirGroupDef, got {:?}", other),
        }
    }

    #[test]
    fn test_parse_minimal() {
        let source = r#"
            airgroup MyGroup {
                air MyAir(int N = 2**16) {
                    col witness a, b;
                    col fixed ZERO = [0]*;
                    a * (1 - a) === 0;
                }
            }
        "#;
        let prog = parse(source).unwrap();
        assert_eq!(prog.statements.len(), 1);
        match &prog.statements[0] {
            Statement::AirGroupDef(ag) => {
                assert_eq!(ag.name, "MyGroup");
                // The body should contain one air template definition
                assert!(!ag.statements.is_empty());
            }
            other => panic!("expected AirGroupDef, got {:?}", other),
        }
    }

    #[test]
    fn test_parse_constraint() {
        let source = "a * (1 - a) === 0;";
        let prog = parse(source).unwrap();
        assert_eq!(prog.statements.len(), 1);
        match &prog.statements[0] {
            Statement::Constraint(c) => {
                assert!(!c.is_witness);
            }
            other => panic!("expected Constraint, got {:?}", other),
        }
    }

    #[test]
    fn test_parse_expression_arithmetic() {
        let source = "const int X = 2 ** 16 - 1;";
        let prog = parse(source).unwrap();
        assert_eq!(prog.statements.len(), 1);
        match &prog.statements[0] {
            Statement::VariableDeclaration(vd) => {
                assert!(vd.init.is_some());
            }
            other => panic!("expected VariableDeclaration, got {:?}", other),
        }
    }

    #[test]
    fn test_parse_function_call_with_named_args() {
        let source = "lookup_assumes(DUAL_RANGE_BYTE_ID, expressions: [byte_a, byte_b], sel: sel);";
        let prog = parse(source).unwrap();
        assert_eq!(prog.statements.len(), 1);
    }

    #[test]
    fn test_parse_if_else() {
        let source = r#"
            if (x == 0) {
                y = 1;
            } else {
                y = 2;
            }
        "#;
        let prog = parse(source).unwrap();
        assert_eq!(prog.statements.len(), 1);
        match &prog.statements[0] {
            Statement::If(if_stmt) => {
                assert!(if_stmt.else_body.is_some());
            }
            other => panic!("expected If, got {:?}", other),
        }
    }

    #[test]
    fn test_parse_for_loop() {
        let source = r#"
            for (int i = 0; i < N; i = i + 1) {
                x = x + 1;
            }
        "#;
        let prog = parse(source).unwrap();
        assert_eq!(prog.statements.len(), 1);
        match &prog.statements[0] {
            Statement::For(_) => {}
            other => panic!("expected For, got {:?}", other),
        }
    }

    #[test]
    fn test_parse_function_def() {
        let source = r#"
            function lookup_assumes(const int opid, const expr expressions[], const expr sel = 1) {
                return;
            }
        "#;
        let prog = parse(source).unwrap();
        assert_eq!(prog.statements.len(), 1);
        match &prog.statements[0] {
            Statement::FunctionDef(fd) => {
                assert_eq!(fd.name, "lookup_assumes");
                assert_eq!(fd.args.len(), 3);
            }
            other => panic!("expected FunctionDef, got {:?}", other),
        }
    }

    #[test]
    fn test_parse_pragma() {
        let source = "#pragma arg -I pil\n";
        let prog = parse(source).unwrap();
        assert_eq!(prog.statements.len(), 1);
        match &prog.statements[0] {
            Statement::Pragma(p) => {
                assert_eq!(p, "arg -I pil");
            }
            other => panic!("expected Pragma, got {:?}", other),
        }
    }

    #[test]
    fn test_parse_airtemplate() {
        let source = r#"
            airtemplate Main(int N = 2**21, int RC = 2) {
                col fixed SEGMENT_L1 = [1,0...];
                col witness a[RC];
            }
        "#;
        let prog = parse(source).unwrap();
        assert_eq!(prog.statements.len(), 1);
        match &prog.statements[0] {
            Statement::AirTemplateDef(at) => {
                assert_eq!(at.name, "Main");
                assert!(at.has_args);
                assert_eq!(at.args.len(), 2);
            }
            other => panic!("expected AirTemplateDef, got {:?}", other),
        }
    }

    #[test]
    fn test_parse_public_declaration() {
        let source = "public inputs[32];";
        let prog = parse(source).unwrap();
        assert_eq!(prog.statements.len(), 1);
        match &prog.statements[0] {
            Statement::PublicDeclaration(_) => {}
            other => panic!("expected PublicDeclaration, got {:?}", other),
        }
    }

    #[test]
    fn test_parse_proofval() {
        let source = "proofval enable_input_data;";
        let prog = parse(source).unwrap();
        assert_eq!(prog.statements.len(), 1);
        match &prog.statements[0] {
            Statement::ProofValueDeclaration(pv) => {
                assert_eq!(pv.items.len(), 1);
                assert_eq!(pv.items[0].name, "enable_input_data");
            }
            other => panic!("expected ProofValueDeclaration, got {:?}", other),
        }
    }

    #[test]
    fn test_parse_airval() {
        let source = "airval main_last_segment;";
        let prog = parse(source).unwrap();
        assert_eq!(prog.statements.len(), 1);
        match &prog.statements[0] {
            Statement::AirValueDeclaration(av) => {
                assert_eq!(av.items.len(), 1);
            }
            other => panic!("expected AirValueDeclaration, got {:?}", other),
        }
    }

    #[test]
    fn test_parse_col_witness_with_features() {
        let source = "col witness bits(32) a[RC];";
        let prog = parse(source).unwrap();
        assert_eq!(prog.statements.len(), 1);
        match &prog.statements[0] {
            Statement::ColDeclaration(cd) => {
                assert_eq!(cd.col_type, ColType::Witness);
                assert_eq!(cd.features.len(), 1);
                assert_eq!(cd.features[0].name, "bits");
            }
            other => panic!("expected ColDeclaration, got {:?}", other),
        }
    }

    #[test]
    fn test_parse_ternary() {
        let source = "const expr X = flag ? a : b;";
        let prog = parse(source).unwrap();
        match &prog.statements[0] {
            Statement::VariableDeclaration(vd) => {
                match vd.init.as_ref().unwrap() {
                    Expr::Ternary { .. } => {}
                    other => panic!("expected Ternary, got {:?}", other),
                }
            }
            other => panic!("expected VariableDeclaration, got {:?}", other),
        }
    }

    #[test]
    fn test_parse_switch() {
        let source = r#"
            switch (x) {
                case 1:
                    y = 1;
                case 2:
                    y = 2;
                default:
                    y = 0;
            }
        "#;
        let prog = parse(source).unwrap();
        assert_eq!(prog.statements.len(), 1);
        match &prog.statements[0] {
            Statement::Switch(sw) => {
                assert_eq!(sw.cases.len(), 2);
                assert!(sw.default.is_some());
            }
            other => panic!("expected Switch, got {:?}", other),
        }
    }

    #[test]
    fn test_parse_virtual_expr() {
        let source = r#"virtual DualRange(id: DUAL_RANGE_7_BITS_ID, min1: 0, max1: 127, min2: 0, max2: 127) alias DualRange7Bits;"#;
        let prog = parse(source).unwrap();
        assert_eq!(prog.statements.len(), 1);
        match &prog.statements[0] {
            Statement::VirtualExpr(ve) => {
                assert_eq!(ve.alias.as_deref(), Some("DualRange7Bits"));
            }
            other => panic!("expected VirtualExpr, got {:?}", other),
        }
    }

    #[test]
    fn test_parse_row_offset() {
        // Expression a' used in a constraint
        let source = "a' === b;";
        let prog = parse(source).unwrap();
        match &prog.statements[0] {
            Statement::Constraint(c) => {
                match &c.left {
                    Expr::RowOffset { .. } => {}
                    other => panic!("expected RowOffset, got {:?}", other),
                }
            }
            other => panic!("expected Constraint, got {:?}", other),
        }
    }
}
