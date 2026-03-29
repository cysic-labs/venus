pub mod ast;

use pest::Parser;
use pest_derive::Parser;

use ast::*;

#[derive(Parser)]
#[grammar = "parser/pil2.pest"]
pub struct Pil2Parser;

/// Parse error type returned by the public `parse` function.
#[derive(Debug)]
pub enum ParseError {
    PestError(String),
    GrammarError(String),
}

impl std::fmt::Display for ParseError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            ParseError::PestError(msg) => write!(f, "parse error: {}", msg),
            ParseError::GrammarError(msg) => write!(f, "grammar error: {}", msg),
        }
    }
}

impl std::error::Error for ParseError {}

/// Parse a PIL2 source string into an AST `Program`.
pub fn parse(source: &str) -> Result<Program, ParseError> {
    let pairs = Pil2Parser::parse(Rule::program, source)
        .map_err(|e| ParseError::PestError(format!("{}", e)))?;
    build_program(pairs)
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Parse a number string to u64, supporting decimal, hex (0x), and binary (0b).
fn parse_u64(s: &str) -> u64 {
    let cleaned = s.replace('_', "");
    if let Some(hex) = cleaned.strip_prefix("0x").or_else(|| cleaned.strip_prefix("0X")) {
        u64::from_str_radix(hex, 16).unwrap_or(0)
    } else if let Some(bin) = cleaned.strip_prefix("0b").or_else(|| cleaned.strip_prefix("0B")) {
        u64::from_str_radix(bin, 2).unwrap_or(0)
    } else {
        cleaned.parse::<u64>().unwrap_or(0)
    }
}

fn make_number_expr(s: &str) -> Expr {
    let cleaned = s.replace('_', "");
    let radix = if cleaned.starts_with("0x") || cleaned.starts_with("0X") {
        NumericRadix::Hex
    } else if cleaned.starts_with("0b") || cleaned.starts_with("0B") {
        NumericRadix::Binary
    } else {
        NumericRadix::Decimal
    };
    Expr::Number(NumericLiteral { value: cleaned, radix })
}

fn strip_quotes(s: &str) -> String {
    if s.len() >= 2 {
        s[1..s.len() - 1].to_string()
    } else {
        s.to_string()
    }
}

fn one_literal() -> Expr {
    Expr::Number(NumericLiteral {
        value: "1".to_string(),
        radix: NumericRadix::Decimal,
    })
}

fn err(msg: impl Into<String>) -> ParseError {
    ParseError::GrammarError(msg.into())
}

/// Get first inner pair by rule.
fn first_child<'a>(pair: &pest::iterators::Pair<'a, Rule>, rule: Rule) -> Option<pest::iterators::Pair<'a, Rule>> {
    pair.clone().into_inner().find(|p| p.as_rule() == rule)
}

/// Collect all inner pairs matching a given rule.
#[allow(dead_code)]
fn children<'a>(pair: &pest::iterators::Pair<'a, Rule>, rule: Rule) -> Vec<pest::iterators::Pair<'a, Rule>> {
    pair.clone().into_inner().filter(|p| p.as_rule() == rule).collect()
}

// ---------------------------------------------------------------------------
// Program
// ---------------------------------------------------------------------------

fn build_program(pairs: pest::iterators::Pairs<'_, Rule>) -> Result<Program, ParseError> {
    let mut statements = Vec::new();
    for pair in pairs {
        match pair.as_rule() {
            Rule::program => {
                for inner in pair.into_inner() {
                    if inner.as_rule() == Rule::statement {
                        let stmt = build_statement(inner)?;
                        statements.push(stmt);
                    }
                }
            }
            Rule::EOI => {}
            _ => {}
        }
    }
    Ok(Program { statements })
}

// ---------------------------------------------------------------------------
// Statements
// ---------------------------------------------------------------------------

fn build_statement(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let inner = pair.into_inner().next().ok_or_else(|| err("empty statement"))?;
    build_statement_inner(inner)
}

fn build_statement_inner(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    match pair.as_rule() {
        Rule::pragma_stmt => build_pragma(pair),
        Rule::include_stmt => build_include(pair),
        Rule::airgroup_stmt => build_airgroup(pair),
        Rule::airtemplate_stmt => build_airtemplate(pair),
        Rule::function_def_stmt => build_function_def(pair),
        Rule::col_decl_stmt => build_col_decl(pair),
        Rule::challenge_decl_stmt => build_challenge_decl(pair),
        Rule::public_decl_stmt => build_public_decl(pair),
        Rule::public_table_decl_stmt => build_public_table_decl(pair),
        Rule::proofval_decl_stmt => build_proofval_decl(pair),
        Rule::airgroupval_decl_stmt => build_airgroupval_decl(pair),
        Rule::airval_decl_stmt => build_airval_decl(pair),
        Rule::commit_decl_stmt => build_commit_decl(pair),
        Rule::var_decl_stmt => build_var_decl(pair),
        Rule::assignment_stmt => build_assignment(pair),
        Rule::constraint_stmt => build_constraint(pair),
        Rule::witness_constraint_stmt => build_witness_constraint(pair),
        Rule::if_stmt => build_if(pair),
        Rule::for_stmt => build_for(pair),
        Rule::while_stmt => build_while(pair),
        Rule::switch_stmt => build_switch(pair),
        Rule::return_stmt => build_return(pair),
        Rule::break_stmt => Ok(Statement::Break),
        Rule::continue_stmt => Ok(Statement::Continue),
        Rule::virtual_expr_stmt => build_virtual_expr(pair),
        Rule::virtual_func_call_alias_stmt => build_virtual_func_call_alias(pair),
        Rule::block_stmt => build_block(pair),
        Rule::container_stmt => build_container(pair),
        Rule::use_stmt => build_use(pair),
        Rule::package_stmt => build_package(pair),
        Rule::deferred_call_stmt => build_deferred_call(pair),
        Rule::hint_stmt => build_hint(pair),
        Rule::when_stmt => build_when(pair),
        Rule::func_call_alias_stmt => build_func_call_alias(pair),
        Rule::expr_stmt => build_expr_stmt(pair),
        other => Err(err(format!("unexpected statement rule: {:?}", other))),
    }
}

// ---------------------------------------------------------------------------
// Pragma
// ---------------------------------------------------------------------------

fn build_pragma(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let content = first_child(&pair, Rule::pragma_content)
        .map(|p| p.as_str().trim().to_string())
        .unwrap_or_default();
    Ok(Statement::Pragma(content))
}

// ---------------------------------------------------------------------------
// Include / Require
// ---------------------------------------------------------------------------

fn build_include(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let mut visibility = Visibility::Public;
    let mut kind = IncludeKind::Require;
    let mut path = StringLiteral { value: String::new(), is_template: false };

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::visibility_kw => {
                visibility = match inner.as_str() {
                    "private" => Visibility::Private,
                    _ => Visibility::Public,
                };
            }
            Rule::include_kind => {
                kind = match inner.as_str() {
                    "include" => IncludeKind::Include,
                    _ => IncludeKind::Require,
                };
            }
            Rule::flexible_string => {
                path = build_flexible_string(inner)?;
            }
            _ => {}
        }
    }
    Ok(Statement::Include(IncludeStmt { kind, visibility, path }))
}

fn build_flexible_string(pair: pest::iterators::Pair<'_, Rule>) -> Result<StringLiteral, ParseError> {
    let inner = pair.into_inner().next().ok_or_else(|| err("empty flexible_string"))?;
    match inner.as_rule() {
        Rule::string_lit => Ok(StringLiteral {
            value: strip_quotes(inner.as_str()),
            is_template: false,
        }),
        Rule::template_lit => Ok(StringLiteral {
            value: strip_quotes(inner.as_str()),
            is_template: true,
        }),
        _ => Err(err("expected string or template literal")),
    }
}

// ---------------------------------------------------------------------------
// Airgroup
// ---------------------------------------------------------------------------

fn build_airgroup(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let mut name = String::new();
    let mut stmts = Vec::new();
    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::ident => { name = inner.as_str().to_string(); }
            Rule::statement => { stmts.push(build_statement(inner)?); }
            _ => {}
        }
    }
    Ok(Statement::AirGroupDef(AirGroupDef { name, statements: stmts }))
}

// ---------------------------------------------------------------------------
// Airtemplate
// ---------------------------------------------------------------------------

fn build_airtemplate(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let mut name = String::new();
    let mut args = Vec::new();
    let mut has_args = false;
    let mut stmts = Vec::new();

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::ident => { name = inner.as_str().to_string(); }
            Rule::args_list => {
                has_args = true;
                args = build_args_list(inner)?;
            }
            Rule::statement => { stmts.push(build_statement(inner)?); }
            _ => {}
        }
    }
    Ok(Statement::AirTemplateDef(AirTemplateDef {
        name, args, has_args, statements: stmts,
    }))
}

// ---------------------------------------------------------------------------
// Function definition
// ---------------------------------------------------------------------------

fn build_function_def(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let mut name = String::new();
    let mut visibility = Visibility::Public;
    let mut is_final: Option<FinalScope> = None;
    let mut args = Vec::new();
    let mut varargs = false;
    let mut returns: Option<Vec<ReturnType>> = None;
    let mut body = Vec::new();

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::final_scope => {
                let txt = inner.as_str().trim();
                is_final = Some(if txt.contains("proof") {
                    FinalScope::Proof
                } else if txt.contains("airgroup") {
                    FinalScope::AirGroup
                } else {
                    FinalScope::Air
                });
            }
            Rule::func_visibility => {
                visibility = match inner.as_str().trim() {
                    "private" => Visibility::Private,
                    _ => Visibility::Public,
                };
            }
            Rule::name_reference => { name = inner.as_str().to_string(); }
            Rule::args_list_with_varargs => {
                let va_text = inner.as_str();
                varargs = va_text.contains("...");
                for fa in inner.into_inner() {
                    if fa.as_rule() == Rule::function_arg {
                        args.push(build_function_arg(fa)?);
                    }
                }
            }
            Rule::return_type_spec => {
                returns = Some(build_return_type_spec(inner)?);
            }
            Rule::statement => { body.push(build_statement(inner)?); }
            _ => {}
        }
    }

    Ok(Statement::FunctionDef(FunctionDef {
        name, visibility, is_final, args, varargs, returns, body,
    }))
}

fn build_return_type_spec(pair: pest::iterators::Pair<'_, Rule>) -> Result<Vec<ReturnType>, ParseError> {
    let mut result = Vec::new();
    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::single_return_type => { result.push(build_single_return_type(inner)?); }
            Rule::comma_sep_return_type => {
                for srt in inner.into_inner() {
                    if srt.as_rule() == Rule::single_return_type {
                        result.push(build_single_return_type(srt)?);
                    }
                }
            }
            _ => {}
        }
    }
    Ok(result)
}

fn build_single_return_type(pair: pest::iterators::Pair<'_, Rule>) -> Result<ReturnType, ParseError> {
    let mut type_info = BasicType { kind: TypeKind::Int, is_const: false };
    let mut dim = 0u32;
    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::basic_type => { type_info = build_basic_type(inner)?; }
            Rule::type_array_dims => {
                // Count pairs of brackets
                let text = inner.as_str();
                dim = text.matches('[').count() as u32;
            }
            _ => {}
        }
    }
    Ok(ReturnType { type_info, dim })
}

// ---------------------------------------------------------------------------
// Function arguments
// ---------------------------------------------------------------------------

fn build_args_list(pair: pest::iterators::Pair<'_, Rule>) -> Result<Vec<FunctionArg>, ParseError> {
    let mut args = Vec::new();
    for inner in pair.into_inner() {
        if inner.as_rule() == Rule::function_arg {
            args.push(build_function_arg(inner)?);
        }
    }
    Ok(args)
}

fn build_function_arg(pair: pest::iterators::Pair<'_, Rule>) -> Result<FunctionArg, ParseError> {
    let mut type_info = BasicType { kind: TypeKind::Int, is_const: false };
    let mut name = String::new();
    let mut is_array = false;
    let mut array_dims = 0u32;
    let mut default_value: Option<Expr> = None;

    let children_iter: Vec<pest::iterators::Pair<'_, Rule>> = pair.into_inner().collect();
    let mut i = 0;
    while i < children_iter.len() {
        let p = &children_iter[i];
        match p.as_rule() {
            Rule::basic_type => {
                type_info = build_basic_type(p.clone())?;
            }
            Rule::ident => {
                name = p.as_str().to_string();
            }
            Rule::type_array_dims => {
                is_array = true;
                array_dims = p.as_str().matches('[').count() as u32;
            }
            Rule::expression => {
                default_value = Some(build_expression(p.clone())?);
            }
            Rule::comma_sep_expr => {
                let exprs = build_comma_sep_expr(p.clone())?;
                default_value = Some(Expr::ArrayLiteral(exprs));
            }
            _ => {}
        }
        i += 1;
    }

    // Check if no comma_sep_expr but we have empty brackets (= [])
    // The text of the pair would contain "= []" pattern
    // This case is handled by comma_sep_expr being empty or absent

    Ok(FunctionArg { type_info, name, is_array, array_dims, default_value })
}

fn build_basic_type(pair: pest::iterators::Pair<'_, Rule>) -> Result<BasicType, ParseError> {
    let text = pair.as_str().trim();
    let is_const = text.starts_with("const");
    let kind = if text.contains("col") && text.contains("witness") {
        TypeKind::Witness
    } else if text.contains("col") && text.contains("fixed") {
        TypeKind::Fixed
    } else if text.contains("publictable") {
        TypeKind::PublicTable
    } else if text.contains("proofval") {
        TypeKind::Proof
    } else if text.contains("challenge") {
        TypeKind::Challenge
    } else if text.contains("public") {
        TypeKind::Public
    } else if text.contains("airgroup") {
        TypeKind::AirGroup
    } else if text.contains("function") {
        TypeKind::Function
    } else if text.contains("string") {
        TypeKind::StringType
    } else if text.contains("expr") {
        TypeKind::Expr
    } else if text.contains("int") {
        TypeKind::Int
    } else if text.contains("fe") {
        TypeKind::Fe
    } else if text.contains("air") {
        TypeKind::Air
    } else {
        TypeKind::Int
    };
    Ok(BasicType { kind, is_const })
}

// ---------------------------------------------------------------------------
// Column declarations
// ---------------------------------------------------------------------------

fn build_col_decl(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let inners: Vec<pest::iterators::Pair<'_, Rule>> = pair.into_inner().collect();

    let mut col_type = ColType::Witness;
    let mut features = Vec::new();
    let mut items = Vec::new();
    let mut init: Option<ColInit> = None;

    for p in &inners {
        match p.as_rule() {
            Rule::col_type_kw => {
                col_type = match p.as_str().trim() {
                    "fixed" => ColType::Fixed,
                    "witness" => ColType::Witness,
                    _ => ColType::Witness,
                };
            }
            Rule::ident => {
                // Custom col type (e.g., "col commit1 ...")
                col_type = ColType::Custom(p.as_str().to_string());
            }
            Rule::col_features => {
                features = build_col_features(p.clone())?;
            }
            Rule::col_decl_list => {
                items = build_col_decl_list(p.clone())?;
            }
            Rule::col_decl_ident => {
                items = vec![build_col_decl_ident_item(p.clone())?];
            }
            Rule::sequence_def => {
                init = Some(ColInit::Sequence(build_sequence_def(p.clone())?));
            }
            Rule::expression => {
                init = Some(ColInit::Expression(build_expression(p.clone())?));
            }
            _ => {}
        }
    }

    Ok(Statement::ColDeclaration(ColDeclaration { col_type, items, features, init }))
}

fn build_col_features(pair: pest::iterators::Pair<'_, Rule>) -> Result<Vec<ColFeature>, ParseError> {
    let mut features = Vec::new();
    for inner in pair.into_inner() {
        if inner.as_rule() == Rule::col_feature {
            features.push(build_col_feature(inner)?);
        }
    }
    Ok(features)
}

fn build_col_feature(pair: pest::iterators::Pair<'_, Rule>) -> Result<ColFeature, ParseError> {
    let mut name = String::new();
    let mut args = Vec::new();
    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::col_feature_name => { name = inner.as_str().trim().to_string(); }
            Rule::multi_expression_list => { args = build_multi_expression_list(inner)?; }
            _ => {}
        }
    }
    Ok(ColFeature { name, args })
}

fn build_col_decl_list(pair: pest::iterators::Pair<'_, Rule>) -> Result<Vec<ColDeclItem>, ParseError> {
    let mut items = Vec::new();
    for inner in pair.into_inner() {
        if inner.as_rule() == Rule::col_decl_item {
            items.push(build_col_decl_item(inner)?);
        }
    }
    Ok(items)
}

fn build_col_decl_item(pair: pest::iterators::Pair<'_, Rule>) -> Result<ColDeclItem, ParseError> {
    let mut item = ColDeclItem { name: String::new(), is_template: false, array_dims: vec![] };
    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::col_decl_ident => {
                let ident_item = build_col_decl_ident_item(inner)?;
                item.name = ident_item.name;
                item.is_template = ident_item.is_template;
            }
            Rule::decl_array_dims => {
                item.array_dims = build_decl_array_dims(inner)?;
            }
            _ => {}
        }
    }
    Ok(item)
}

fn build_col_decl_ident_item(pair: pest::iterators::Pair<'_, Rule>) -> Result<ColDeclItem, ParseError> {
    let text = pair.as_str().trim();
    let inner_children: Vec<pest::iterators::Pair<'_, Rule>> = pair.into_inner().collect();

    // Check for "air.name" pattern
    if text.starts_with("air.") {
        let name_part = if inner_children.len() > 0 {
            // Get the ident after "air."
            let last_ident = inner_children.last().unwrap();
            format!("air.{}", last_ident.as_str())
        } else {
            text.to_string()
        };
        return Ok(ColDeclItem { name: name_part, is_template: false, array_dims: vec![] });
    }

    if let Some(first) = inner_children.first() {
        match first.as_rule() {
            Rule::template_lit => {
                return Ok(ColDeclItem {
                    name: strip_quotes(first.as_str()),
                    is_template: true,
                    array_dims: vec![],
                });
            }
            Rule::ident => {
                return Ok(ColDeclItem {
                    name: first.as_str().to_string(),
                    is_template: false,
                    array_dims: vec![],
                });
            }
            _ => {}
        }
    }
    Ok(ColDeclItem { name: text.to_string(), is_template: false, array_dims: vec![] })
}

fn build_decl_array_dims(pair: pest::iterators::Pair<'_, Rule>) -> Result<Vec<Option<Expr>>, ParseError> {
    let text = pair.as_str();
    let expressions: Vec<pest::iterators::Pair<'_, Rule>> = pair.into_inner().filter(|p| p.as_rule() == Rule::expression).collect();

    // Count the number of bracket pairs
    let bracket_count = text.matches('[').count();
    let mut dims = Vec::new();
    let mut expr_idx = 0;

    // Walk through the text to determine which brackets have expressions
    let mut in_bracket = false;
    let mut bracket_start = 0;
    for (i, c) in text.char_indices() {
        if c == '[' {
            in_bracket = true;
            bracket_start = i;
        } else if c == ']' && in_bracket {
            in_bracket = false;
            let content = text[bracket_start + 1..i].trim();
            if content.is_empty() {
                dims.push(None);
            } else {
                if expr_idx < expressions.len() {
                    dims.push(Some(build_expression(expressions[expr_idx].clone())?));
                    expr_idx += 1;
                } else {
                    dims.push(None);
                }
            }
        }
    }

    if dims.is_empty() {
        // Fallback: just count brackets
        for _ in 0..bracket_count {
            dims.push(None);
        }
    }

    Ok(dims)
}

// ---------------------------------------------------------------------------
// Challenge declaration
// ---------------------------------------------------------------------------

fn build_challenge_decl(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let mut stage: Option<u64> = None;
    let mut items = Vec::new();

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::number => { stage = Some(parse_u64(inner.as_str())); }
            Rule::col_decl_list => { items = build_col_decl_list(inner)?; }
            _ => {}
        }
    }
    Ok(Statement::ChallengeDeclaration(ChallengeDeclaration { stage, items }))
}

// ---------------------------------------------------------------------------
// Public declaration
// ---------------------------------------------------------------------------

fn build_public_decl(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let mut items = Vec::new();
    let mut init_expr: Option<Expr> = None;

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::col_decl_ident => {
                items = vec![build_col_decl_ident_item(inner)?];
            }
            Rule::col_decl_list => {
                items = build_col_decl_list(inner)?;
            }
            Rule::expression => {
                init_expr = Some(build_expression(inner)?);
            }
            _ => {}
        }
    }
    Ok(Statement::PublicDeclaration(PublicDeclaration { items, init: init_expr }))
}

// ---------------------------------------------------------------------------
// Public table declaration
// ---------------------------------------------------------------------------

fn build_public_table_decl(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    // This is a placeholder -- publictable is not heavily used in the codebase
    let mut name = String::new();
    let mut exprs = Vec::new();
    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::ident => { name = inner.as_str().to_string(); }
            Rule::expression => { exprs.push(build_expression(inner)?); }
            _ => {}
        }
    }
    // Minimal representation
    let cols = exprs.pop().unwrap_or(Expr::Number(NumericLiteral { value: "0".to_string(), radix: NumericRadix::Decimal }));
    let rows = exprs.pop().unwrap_or(Expr::Number(NumericLiteral { value: "0".to_string(), radix: NumericRadix::Decimal }));
    Ok(Statement::PublicTableDeclaration(PublicTableDeclaration {
        aggregate_type: String::new(),
        aggregate_function: String::new(),
        name,
        args: exprs,
        cols,
        rows,
    }))
}

// ---------------------------------------------------------------------------
// Proofval declaration
// ---------------------------------------------------------------------------

fn build_proofval_decl(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let mut stage: Option<u64> = None;
    let mut items = Vec::new();

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::number => { stage = Some(parse_u64(inner.as_str())); }
            Rule::col_decl_list => { items = build_col_decl_list(inner)?; }
            _ => {}
        }
    }
    Ok(Statement::ProofValueDeclaration(ProofValueDeclaration { stage, items }))
}

// ---------------------------------------------------------------------------
// Airgroup value declaration
// ---------------------------------------------------------------------------

fn build_airgroupval_decl(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let mut stage: Option<u64> = None;
    let mut default_value: Option<Expr> = None;
    let mut aggregate_type: Option<String> = None;
    let mut items = Vec::new();

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::airgroupval_modifier => {
                let mod_text = inner.as_str().trim();
                if mod_text.starts_with("stage") {
                    if let Some(n) = first_child(&inner, Rule::number) {
                        stage = Some(parse_u64(n.as_str()));
                    }
                } else if mod_text.starts_with("aggregate") {
                    if let Some(id) = first_child(&inner, Rule::ident) {
                        aggregate_type = Some(id.as_str().to_string());
                    }
                } else if mod_text.starts_with("default") {
                    if let Some(e) = first_child(&inner, Rule::expression) {
                        default_value = Some(build_expression(e)?);
                    }
                }
            }
            Rule::col_decl_list => { items = build_col_decl_list(inner)?; }
            _ => {}
        }
    }
    Ok(Statement::AirGroupValueDeclaration(AirGroupValueDeclaration {
        stage, default_value, aggregate_type, items,
    }))
}

// ---------------------------------------------------------------------------
// Airval declaration
// ---------------------------------------------------------------------------

fn build_airval_decl(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let mut stage: Option<u64> = None;
    let mut items = Vec::new();

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::number => { stage = Some(parse_u64(inner.as_str())); }
            Rule::col_decl_list => { items = build_col_decl_list(inner)?; }
            _ => {}
        }
    }
    Ok(Statement::AirValueDeclaration(AirValueDeclaration { stage, items }))
}

// ---------------------------------------------------------------------------
// Commit declaration
// ---------------------------------------------------------------------------

fn build_commit_decl(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let mut stage: Option<u64> = None;
    let mut name = String::new();
    let mut publics = Vec::new();

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::number => { stage = Some(parse_u64(inner.as_str())); }
            Rule::ident => { name = inner.as_str().to_string(); }
            Rule::commit_public_ref => {
                for p in inner.into_inner() {
                    if p.as_rule() == Rule::name_id_list {
                        for nid in p.into_inner() {
                            if nid.as_rule() == Rule::name_id {
                                publics.push(nid.as_str().trim().to_string());
                            }
                        }
                    }
                }
            }
            _ => {}
        }
    }
    Ok(Statement::CommitDeclaration(CommitDeclaration { stage, publics, name }))
}

// ---------------------------------------------------------------------------
// Variable declarations
// ---------------------------------------------------------------------------

fn build_var_decl(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let text = pair.as_str().trim();
    let is_const = text.starts_with("const");

    let mut vtype = TypeKind::Int;
    let mut items = Vec::new();
    let mut init: Option<Expr> = None;
    let mut has_var_decl_list = false;
    let mut has_comma_sep_expr = false;

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::var_type_kw => {
                vtype = match inner.as_str().trim() {
                    "fe" => TypeKind::Fe,
                    "expr" => TypeKind::Expr,
                    "string" => TypeKind::StringType,
                    "function" => TypeKind::Function,
                    _ => TypeKind::Int,
                };
            }
            Rule::var_decl_item => {
                items = vec![build_var_decl_item(inner)?];
            }
            Rule::var_decl_list => {
                items = build_var_decl_list(inner)?;
                has_var_decl_list = true;
            }
            Rule::expression => {
                init = Some(build_expression(inner)?);
            }
            Rule::comma_sep_expr => {
                let exprs = build_comma_sep_expr(inner)?;
                init = Some(Expr::ArrayLiteral(exprs));
                has_comma_sep_expr = true;
            }
            _ => {}
        }
    }

    let is_multiple = has_var_decl_list && has_comma_sep_expr;
    Ok(Statement::VariableDeclaration(VariableDeclaration { is_const, vtype, items, init, is_multiple }))
}

fn build_var_decl_list(pair: pest::iterators::Pair<'_, Rule>) -> Result<Vec<VarDeclItem>, ParseError> {
    let mut items = Vec::new();
    for inner in pair.into_inner() {
        if inner.as_rule() == Rule::var_decl_item {
            items.push(build_var_decl_item(inner)?);
        }
    }
    Ok(items)
}

fn build_var_decl_item(pair: pest::iterators::Pair<'_, Rule>) -> Result<VarDeclItem, ParseError> {
    let mut name = String::new();
    let mut array_dims = Vec::new();

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::name_reference => { name = inner.as_str().to_string(); }
            Rule::var_decl_array_dims => {
                array_dims = build_decl_array_dims_generic(inner)?;
            }
            _ => {}
        }
    }
    Ok(VarDeclItem { name, array_dims })
}

fn build_decl_array_dims_generic(pair: pest::iterators::Pair<'_, Rule>) -> Result<Vec<Option<Expr>>, ParseError> {
    // Similar to build_decl_array_dims but for var_decl_array_dims
    let text = pair.as_str();
    let expressions: Vec<pest::iterators::Pair<'_, Rule>> = pair.into_inner().filter(|p| p.as_rule() == Rule::expression).collect();

    let mut dims = Vec::new();
    let mut expr_idx = 0;
    let mut in_bracket = false;
    let mut bracket_start = 0;

    for (i, c) in text.char_indices() {
        if c == '[' {
            in_bracket = true;
            bracket_start = i;
        } else if c == ']' && in_bracket {
            in_bracket = false;
            let content = text[bracket_start + 1..i].trim();
            if content.is_empty() {
                dims.push(None);
            } else if expr_idx < expressions.len() {
                dims.push(Some(build_expression(expressions[expr_idx].clone())?));
                expr_idx += 1;
            } else {
                dims.push(None);
            }
        }
    }

    if dims.is_empty() {
        let bracket_count = text.matches('[').count();
        for _ in 0..bracket_count {
            dims.push(None);
        }
    }

    Ok(dims)
}

// ---------------------------------------------------------------------------
// Assignment
// ---------------------------------------------------------------------------

fn build_assignment(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let text = pair.as_str().trim();
    let inners: Vec<pest::iterators::Pair<'_, Rule>> = pair.into_inner().collect();

    // Check for prefix ++/-- patterns
    if text.starts_with("++") {
        let target = build_name_id(inners.into_iter().find(|p| p.as_rule() == Rule::name_id).unwrap())?;
        return Ok(Statement::Assignment(Assignment {
            target, op: AssignOp::AddAssign, value: AssignValue::Expr(one_literal()),
        }));
    }
    if text.starts_with("--") {
        let target = build_name_id(inners.into_iter().find(|p| p.as_rule() == Rule::name_id).unwrap())?;
        return Ok(Statement::Assignment(Assignment {
            target, op: AssignOp::SubAssign, value: AssignValue::Expr(one_literal()),
        }));
    }

    // Check for postfix ++/--
    let trimmed = text.trim_end_matches(';').trim();
    if trimmed.ends_with("++") && !inners.iter().any(|p| p.as_rule() == Rule::assign_op) {
        let target = build_name_id(inners.into_iter().find(|p| p.as_rule() == Rule::name_id).unwrap())?;
        return Ok(Statement::Assignment(Assignment {
            target, op: AssignOp::AddAssign, value: AssignValue::Expr(one_literal()),
        }));
    }
    if trimmed.ends_with("--") && !inners.iter().any(|p| p.as_rule() == Rule::assign_op) {
        let target = build_name_id(inners.into_iter().find(|p| p.as_rule() == Rule::name_id).unwrap())?;
        return Ok(Statement::Assignment(Assignment {
            target, op: AssignOp::SubAssign, value: AssignValue::Expr(one_literal()),
        }));
    }

    // Normal assignment
    let mut target = NameId { path: String::new(), indexes: vec![], row_offset: None };
    let mut op = AssignOp::Assign;
    let mut value = AssignValue::Expr(one_literal());

    for p in inners {
        match p.as_rule() {
            Rule::name_id => { target = build_name_id(p)?; }
            Rule::assign_op => {
                op = match p.as_str().trim() {
                    "+=" => AssignOp::AddAssign,
                    "-=" => AssignOp::SubAssign,
                    "*=" => AssignOp::MulAssign,
                    _ => AssignOp::Assign,
                };
            }
            Rule::sequence_def => {
                value = AssignValue::Sequence(build_sequence_def(p)?);
            }
            Rule::expression => {
                value = AssignValue::Expr(build_expression(p)?);
            }
            _ => {}
        }
    }

    Ok(Statement::Assignment(Assignment { target, op, value }))
}

fn build_name_id(pair: pest::iterators::Pair<'_, Rule>) -> Result<NameId, ParseError> {
    let text = pair.as_str().trim();
    let inners: Vec<pest::iterators::Pair<'_, Rule>> = pair.into_inner().collect();

    let mut path = String::new();
    let mut indexes = Vec::new();
    let mut row_offset: Option<Box<Expr>> = None;

    for p in &inners {
        match p.as_rule() {
            Rule::name_optional_index => {
                let (p_path, p_idx) = build_name_optional_index(p.clone())?;
                path = p_path;
                indexes = p_idx;
            }
            Rule::number => {
                row_offset = Some(Box::new(make_number_expr(p.as_str())));
            }
            Rule::expression => {
                row_offset = Some(Box::new(build_expression(p.clone())?));
            }
            _ => {}
        }
    }

    // Check if text contains ' for row offset without explicit number
    if row_offset.is_none() && text.contains('\'') {
        row_offset = Some(Box::new(one_literal()));
    }

    Ok(NameId { path, indexes, row_offset })
}

fn build_name_optional_index(pair: pest::iterators::Pair<'_, Rule>) -> Result<(String, Vec<Expr>), ParseError> {
    let mut path = String::new();
    let mut indexes = Vec::new();

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::name_reference => { path = inner.as_str().to_string(); }
            Rule::array_index_list => {
                for idx_inner in inner.into_inner() {
                    if idx_inner.as_rule() == Rule::expression {
                        indexes.push(build_expression(idx_inner)?);
                    }
                }
            }
            _ => {}
        }
    }
    Ok((path, indexes))
}

// ---------------------------------------------------------------------------
// Constraints
// ---------------------------------------------------------------------------

fn build_constraint(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let exprs: Vec<pest::iterators::Pair<'_, Rule>> = pair.into_inner().filter(|p| p.as_rule() == Rule::expression).collect();
    if exprs.len() != 2 {
        return Err(err("constraint requires exactly two expressions"));
    }
    let left = build_expression(exprs[0].clone())?;
    let right = build_expression(exprs[1].clone())?;
    Ok(Statement::Constraint(Constraint { left, right, is_witness: false }))
}

fn build_witness_constraint(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let exprs: Vec<pest::iterators::Pair<'_, Rule>> = pair.into_inner().filter(|p| p.as_rule() == Rule::expression).collect();
    if exprs.len() != 2 {
        return Err(err("witness constraint requires exactly two expressions"));
    }
    let left = build_expression(exprs[0].clone())?;
    let right = build_expression(exprs[1].clone())?;
    Ok(Statement::Constraint(Constraint { left, right, is_witness: true }))
}

// ---------------------------------------------------------------------------
// Control flow
// ---------------------------------------------------------------------------

fn build_if(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let mut condition = Expr::Number(NumericLiteral { value: "0".to_string(), radix: NumericRadix::Decimal });
    let mut then_body = Vec::new();
    let mut else_body: Option<Vec<Statement>> = None;
    let mut got_condition = false;

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::expression if !got_condition => {
                condition = build_expression(inner)?;
                got_condition = true;
            }
            Rule::statement => {
                then_body.push(build_statement(inner)?);
            }
            Rule::else_clause => {
                else_body = Some(build_else_clause(inner)?);
            }
            Rule::single_stmt => {
                let stmt = build_single_stmt(inner)?;
                then_body.push(stmt);
            }
            _ => {}
        }
    }

    Ok(Statement::If(IfStmt {
        condition,
        then_body,
        elseif_clauses: vec![],
        else_body,
    }))
}

fn build_else_clause(pair: pest::iterators::Pair<'_, Rule>) -> Result<Vec<Statement>, ParseError> {
    let mut stmts = Vec::new();
    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::if_stmt => {
                stmts.push(build_if(inner)?);
            }
            Rule::statement => {
                stmts.push(build_statement(inner)?);
            }
            _ => {}
        }
    }
    Ok(stmts)
}

fn build_single_stmt(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let inner = pair.into_inner().next().ok_or_else(|| err("empty single_stmt"))?;
    build_statement_inner(inner)
}

fn build_for(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let mut init: Option<Statement> = None;
    let mut condition = Expr::Number(NumericLiteral { value: "0".to_string(), radix: NumericRadix::Decimal });
    let mut increment = Vec::new();
    let mut body = Vec::new();
    let mut got_condition = false;

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::for_init => {
                init = Some(build_for_init(inner)?);
            }
            Rule::expression if !got_condition => {
                condition = build_expression(inner)?;
                got_condition = true;
            }
            Rule::for_incr_list => {
                increment = build_for_incr_list(inner)?;
            }
            Rule::statement => {
                body.push(build_statement(inner)?);
            }
            Rule::single_stmt => {
                body.push(build_single_stmt(inner)?);
            }
            _ => {}
        }
    }

    Ok(Statement::For(ForStmt {
        init: Box::new(init.unwrap_or(Statement::Break)),
        condition,
        increment,
        body,
    }))
}

fn build_for_init(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let inner = pair.into_inner().next().ok_or_else(|| err("empty for_init"))?;
    match inner.as_rule() {
        Rule::var_decl_inner => build_var_decl_inner(inner),
        Rule::col_decl_inner => build_col_decl_inner(inner),
        Rule::assignment_inner => build_assignment_inner(inner),
        _ => Err(err("unexpected for_init content")),
    }
}

fn build_var_decl_inner(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let text = pair.as_str().trim();
    let is_const = text.starts_with("const");
    let mut vtype = TypeKind::Int;
    let mut item = VarDeclItem { name: String::new(), array_dims: vec![] };
    let mut init: Option<Expr> = None;

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::var_type_kw => {
                vtype = match inner.as_str().trim() {
                    "fe" => TypeKind::Fe,
                    "expr" => TypeKind::Expr,
                    "string" => TypeKind::StringType,
                    "function" => TypeKind::Function,
                    _ => TypeKind::Int,
                };
            }
            Rule::var_decl_item => { item = build_var_decl_item(inner)?; }
            Rule::expression => { init = Some(build_expression(inner)?); }
            _ => {}
        }
    }

    Ok(Statement::VariableDeclaration(VariableDeclaration {
        is_const, vtype, items: vec![item], init, is_multiple: false,
    }))
}

fn build_col_decl_inner(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let mut col_type = ColType::Witness;
    let mut features = Vec::new();
    let mut items = Vec::new();

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::col_type_kw => {
                col_type = match inner.as_str().trim() {
                    "fixed" => ColType::Fixed,
                    _ => ColType::Witness,
                };
            }
            Rule::col_features => { features = build_col_features(inner)?; }
            Rule::col_decl_list => { items = build_col_decl_list(inner)?; }
            _ => {}
        }
    }

    Ok(Statement::ColDeclaration(ColDeclaration { col_type, items, features, init: None }))
}

fn build_assignment_inner(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let text = pair.as_str().trim();
    let inners: Vec<pest::iterators::Pair<'_, Rule>> = pair.into_inner().collect();

    if text.starts_with("++") {
        let target = build_name_id(inners.into_iter().find(|p| p.as_rule() == Rule::name_id).unwrap())?;
        return Ok(Statement::Assignment(Assignment { target, op: AssignOp::AddAssign, value: AssignValue::Expr(one_literal()) }));
    }
    if text.starts_with("--") {
        let target = build_name_id(inners.into_iter().find(|p| p.as_rule() == Rule::name_id).unwrap())?;
        return Ok(Statement::Assignment(Assignment { target, op: AssignOp::SubAssign, value: AssignValue::Expr(one_literal()) }));
    }
    let trimmed = text.trim_end_matches(';').trim();
    if trimmed.ends_with("++") && !inners.iter().any(|p| p.as_rule() == Rule::assign_op) {
        let target = build_name_id(inners.into_iter().find(|p| p.as_rule() == Rule::name_id).unwrap())?;
        return Ok(Statement::Assignment(Assignment { target, op: AssignOp::AddAssign, value: AssignValue::Expr(one_literal()) }));
    }
    if trimmed.ends_with("--") && !inners.iter().any(|p| p.as_rule() == Rule::assign_op) {
        let target = build_name_id(inners.into_iter().find(|p| p.as_rule() == Rule::name_id).unwrap())?;
        return Ok(Statement::Assignment(Assignment { target, op: AssignOp::SubAssign, value: AssignValue::Expr(one_literal()) }));
    }

    let mut target = NameId { path: String::new(), indexes: vec![], row_offset: None };
    let mut op = AssignOp::Assign;
    let mut value = AssignValue::Expr(one_literal());

    for p in inners {
        match p.as_rule() {
            Rule::name_id => { target = build_name_id(p)?; }
            Rule::assign_op => {
                op = match p.as_str().trim() {
                    "+=" => AssignOp::AddAssign,
                    "-=" => AssignOp::SubAssign,
                    "*=" => AssignOp::MulAssign,
                    _ => AssignOp::Assign,
                };
            }
            Rule::expression => { value = AssignValue::Expr(build_expression(p)?); }
            _ => {}
        }
    }

    Ok(Statement::Assignment(Assignment { target, op, value }))
}

fn build_for_incr_list(pair: pest::iterators::Pair<'_, Rule>) -> Result<Vec<Assignment>, ParseError> {
    let mut result = Vec::new();
    for inner in pair.into_inner() {
        if inner.as_rule() == Rule::for_incr_item {
            result.push(build_for_incr_item(inner)?);
        }
    }
    Ok(result)
}

fn build_for_incr_item(pair: pest::iterators::Pair<'_, Rule>) -> Result<Assignment, ParseError> {
    let text = pair.as_str().trim();
    let inners: Vec<pest::iterators::Pair<'_, Rule>> = pair.into_inner().collect();

    if text.starts_with("++") {
        let target = build_name_id(inners.into_iter().find(|p| p.as_rule() == Rule::name_id).unwrap())?;
        return Ok(Assignment { target, op: AssignOp::AddAssign, value: AssignValue::Expr(one_literal()) });
    }
    if text.starts_with("--") {
        let target = build_name_id(inners.into_iter().find(|p| p.as_rule() == Rule::name_id).unwrap())?;
        return Ok(Assignment { target, op: AssignOp::SubAssign, value: AssignValue::Expr(one_literal()) });
    }
    if text.ends_with("++") && !inners.iter().any(|p| p.as_rule() == Rule::assign_op) {
        let target = build_name_id(inners.into_iter().find(|p| p.as_rule() == Rule::name_id).unwrap())?;
        return Ok(Assignment { target, op: AssignOp::AddAssign, value: AssignValue::Expr(one_literal()) });
    }
    if text.ends_with("--") && !inners.iter().any(|p| p.as_rule() == Rule::assign_op) {
        let target = build_name_id(inners.into_iter().find(|p| p.as_rule() == Rule::name_id).unwrap())?;
        return Ok(Assignment { target, op: AssignOp::SubAssign, value: AssignValue::Expr(one_literal()) });
    }

    let mut target = NameId { path: String::new(), indexes: vec![], row_offset: None };
    let mut op = AssignOp::Assign;
    let mut value = AssignValue::Expr(one_literal());

    for p in inners {
        match p.as_rule() {
            Rule::name_id => { target = build_name_id(p)?; }
            Rule::assign_op => {
                op = match p.as_str().trim() {
                    "+=" => AssignOp::AddAssign,
                    "-=" => AssignOp::SubAssign,
                    "*=" => AssignOp::MulAssign,
                    _ => AssignOp::Assign,
                };
            }
            Rule::expression => { value = AssignValue::Expr(build_expression(p)?); }
            _ => {}
        }
    }

    Ok(Assignment { target, op, value })
}

fn build_while(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let mut condition = Expr::Number(NumericLiteral { value: "0".to_string(), radix: NumericRadix::Decimal });
    let mut body = Vec::new();

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::expression => { condition = build_expression(inner)?; }
            Rule::statement => { body.push(build_statement(inner)?); }
            _ => {}
        }
    }

    Ok(Statement::While(WhileStmt { condition, body }))
}

fn build_switch(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let mut value = Expr::Number(NumericLiteral { value: "0".to_string(), radix: NumericRadix::Decimal });
    let mut cases = Vec::new();
    let mut default: Option<Vec<Statement>> = None;

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::expression => { value = build_expression(inner)?; }
            Rule::case_clause => { cases.push(build_case_clause(inner)?); }
            Rule::default_clause => {
                let mut stmts = Vec::new();
                for s in inner.into_inner() {
                    if s.as_rule() == Rule::statement {
                        stmts.push(build_statement(s)?);
                    }
                }
                default = Some(stmts);
            }
            _ => {}
        }
    }

    Ok(Statement::Switch(SwitchStmt { value, cases, default }))
}

fn build_case_clause(pair: pest::iterators::Pair<'_, Rule>) -> Result<CaseClause, ParseError> {
    let mut values = Vec::new();
    let mut body = Vec::new();

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::case_values => {
                for cv in inner.into_inner() {
                    if cv.as_rule() == Rule::case_value_item {
                        let exprs: Vec<pest::iterators::Pair<'_, Rule>> = cv.clone().into_inner().filter(|p| p.as_rule() == Rule::expression).collect();
                        if exprs.len() == 2 {
                            values.push(CaseValue::Range(
                                build_expression(exprs[0].clone())?,
                                build_expression(exprs[1].clone())?,
                            ));
                        } else if exprs.len() == 1 {
                            values.push(CaseValue::Single(build_expression(exprs[0].clone())?));
                        }
                    }
                }
            }
            Rule::statement => { body.push(build_statement(inner)?); }
            _ => {}
        }
    }

    Ok(CaseClause { values, body })
}

fn build_return(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let inners: Vec<pest::iterators::Pair<'_, Rule>> = pair.into_inner().collect();

    // Check for [expr, ...] return
    let has_comma_sep = inners.iter().any(|p| p.as_rule() == Rule::comma_sep_expr);
    if has_comma_sep {
        for p in &inners {
            if p.as_rule() == Rule::comma_sep_expr {
                let exprs = build_comma_sep_expr(p.clone())?;
                return Ok(Statement::Return(ReturnStmt { value: None, values: Some(exprs) }));
            }
        }
    }

    // Single expression return
    for p in &inners {
        if p.as_rule() == Rule::expression {
            let expr = build_expression(p.clone())?;
            return Ok(Statement::Return(ReturnStmt { value: Some(expr), values: None }));
        }
    }

    // Bare return
    Ok(Statement::Return(ReturnStmt { value: None, values: None }))
}

// ---------------------------------------------------------------------------
// Virtual expression
// ---------------------------------------------------------------------------

fn build_virtual_expr(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let mut expr = Expr::Number(NumericLiteral { value: "0".to_string(), radix: NumericRadix::Decimal });

    for inner in pair.into_inner() {
        if inner.as_rule() == Rule::expression {
            expr = build_expression(inner)?;
        }
    }

    Ok(Statement::VirtualExpr(VirtualExprStmt { expr, alias: None }))
}

// ---------------------------------------------------------------------------
// Block
// ---------------------------------------------------------------------------

fn build_block(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let mut stmts = Vec::new();
    for inner in pair.into_inner() {
        if inner.as_rule() == Rule::statement {
            stmts.push(build_statement(inner)?);
        }
    }
    Ok(Statement::Block(stmts))
}

// ---------------------------------------------------------------------------
// Container
// ---------------------------------------------------------------------------

fn build_container(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let text = pair.as_str();
    let has_body = text.contains('{');
    let _has_alias = text.contains("alias");
    let mut name = String::new();
    let mut alias: Option<String> = None;
    let mut body: Option<Vec<Statement>> = None;

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::name_reference => { name = inner.as_str().to_string(); }
            Rule::ident => { alias = Some(inner.as_str().to_string()); }
            Rule::statement => {
                if body.is_none() { body = Some(Vec::new()); }
                body.as_mut().unwrap().push(build_statement(inner)?);
            }
            _ => {}
        }
    }

    if has_body && body.is_none() {
        body = Some(Vec::new());
    }

    Ok(Statement::Container(ContainerDef { name, alias, body }))
}

// ---------------------------------------------------------------------------
// Use
// ---------------------------------------------------------------------------

fn build_use(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let mut name = String::new();
    let mut alias: Option<String> = None;

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::name_reference => { name = inner.as_str().to_string(); }
            Rule::ident => { alias = Some(inner.as_str().to_string()); }
            _ => {}
        }
    }

    Ok(Statement::Use(UseDef { name, alias }))
}

// ---------------------------------------------------------------------------
// Package
// ---------------------------------------------------------------------------

fn build_package(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let mut name = String::new();
    let mut body = Vec::new();

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::ident => { name = inner.as_str().to_string(); }
            Rule::statement => { body.push(build_statement(inner)?); }
            _ => {}
        }
    }

    Ok(Statement::Package(PackageDef { name, body }))
}

// ---------------------------------------------------------------------------
// Deferred call
// ---------------------------------------------------------------------------

fn build_deferred_call(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let mut priority: Option<Expr> = None;
    let mut scope = String::new();
    let mut function = NameRef { path: String::new(), indexes: vec![] };
    let mut args = Vec::new();

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::expression => {
                priority = Some(build_expression(inner)?);
            }
            Rule::defined_scope => {
                scope = inner.as_str().trim().to_string();
            }
            Rule::name_optional_index => {
                let (path, indexes) = build_name_optional_index(inner)?;
                function = NameRef { path, indexes };
            }
            Rule::multi_expression_list => {
                args = build_multi_expression_list(inner)?;
            }
            _ => {}
        }
    }

    Ok(Statement::DeferredCall(DeferredCall {
        event: "final".to_string(),
        priority,
        scope,
        function,
        args,
    }))
}

// ---------------------------------------------------------------------------
// Hint
// ---------------------------------------------------------------------------

fn build_hint(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let mut name = String::new();
    let mut data = HintData::Expr(Expr::Number(NumericLiteral { value: "0".to_string(), radix: NumericRadix::Decimal }));

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::hint_tok => {
                // Strip the @ prefix
                name = inner.as_str()[1..].to_string();
            }
            Rule::hint_object_pairs => {
                data = HintData::Object(build_hint_pairs(inner)?);
            }
            Rule::comma_sep_expr => {
                let exprs = build_comma_sep_expr(inner)?;
                data = HintData::Array(exprs);
            }
            Rule::expression => {
                data = HintData::Expr(build_expression(inner)?);
            }
            _ => {}
        }
    }

    Ok(Statement::Hint(HintStmt { name, data }))
}

fn build_hint_pairs(pair: pest::iterators::Pair<'_, Rule>) -> Result<Vec<(String, Expr)>, ParseError> {
    let mut pairs = Vec::new();
    for inner in pair.into_inner() {
        if inner.as_rule() == Rule::hint_pair {
            let mut key = String::new();
            let mut val: Option<Expr> = None;
            for p in inner.into_inner() {
                match p.as_rule() {
                    Rule::ident => { key = p.as_str().to_string(); }
                    Rule::expression => { val = Some(build_expression(p)?); }
                    _ => {}
                }
            }
            let value = val.unwrap_or_else(|| {
                Expr::Reference(NameId { path: key.clone(), indexes: vec![], row_offset: None })
            });
            pairs.push((key, value));
        }
    }
    Ok(pairs)
}

// ---------------------------------------------------------------------------
// When
// ---------------------------------------------------------------------------

fn build_when(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let mut condition = WhenCondition::Boundary(String::new());
    let mut body = Vec::new();
    let mut got_condition = false;

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::expression if !got_condition => {
                condition = WhenCondition::Expr(build_expression(inner)?);
                got_condition = true;
            }
            Rule::ident if !got_condition => {
                condition = WhenCondition::Boundary(inner.as_str().to_string());
                got_condition = true;
            }
            Rule::statement => { body.push(build_statement(inner)?); }
            _ => {}
        }
    }

    Ok(Statement::When(WhenStmt { condition, body }))
}

// ---------------------------------------------------------------------------
// Function call alias statement
// ---------------------------------------------------------------------------

fn build_func_call_alias(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let mut call = FunctionCall { function: NameRef { path: String::new(), indexes: vec![] }, args: vec![] };
    let mut alias: Option<String> = None;

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::func_call_expr => { call = build_func_call_expr(inner)?; }
            Rule::ident => { alias = Some(inner.as_str().to_string()); }
            Rule::flexible_string => {
                alias = Some(build_flexible_string(inner)?.value);
            }
            _ => {}
        }
    }

    Ok(Statement::ExprStatement(ExprStmt {
        expr: Expr::FunctionCall(call),
        alias,
    }))
}

fn build_virtual_func_call_alias(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let mut call = FunctionCall { function: NameRef { path: String::new(), indexes: vec![] }, args: vec![] };
    let mut alias: Option<String> = None;

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::func_call_expr => { call = build_func_call_expr(inner)?; }
            Rule::ident => { alias = Some(inner.as_str().to_string()); }
            Rule::flexible_string => {
                alias = Some(build_flexible_string(inner)?.value);
            }
            _ => {}
        }
    }

    Ok(Statement::VirtualExpr(VirtualExprStmt {
        expr: Expr::FunctionCall(call),
        alias,
    }))
}

// ---------------------------------------------------------------------------
// Expression statement
// ---------------------------------------------------------------------------

fn build_expr_stmt(pair: pest::iterators::Pair<'_, Rule>) -> Result<Statement, ParseError> {
    let expr = pair.into_inner().find(|p| p.as_rule() == Rule::expression)
        .ok_or_else(|| err("empty expr_stmt"))?;
    Ok(Statement::ExprStatement(ExprStmt {
        expr: build_expression(expr)?,
        alias: None,
    }))
}

// ---------------------------------------------------------------------------
// Expressions
// ---------------------------------------------------------------------------

fn build_expression(pair: pest::iterators::Pair<'_, Rule>) -> Result<Expr, ParseError> {
    let inner = pair.into_inner().next().ok_or_else(|| err("empty expression"))?;
    build_ternary(inner)
}

fn build_ternary(pair: pest::iterators::Pair<'_, Rule>) -> Result<Expr, ParseError> {
    let mut children: Vec<pest::iterators::Pair<'_, Rule>> = pair.into_inner().collect();

    if children.len() == 3 {
        // ternary: cond ? then : else
        let cond = build_or_expr(children.remove(0))?;
        let then_e = build_ternary(children.remove(0))?;
        let else_e = build_ternary(children.remove(0))?;
        Ok(Expr::Ternary {
            condition: Box::new(cond),
            then_expr: Box::new(then_e),
            else_expr: Box::new(else_e),
        })
    } else if children.len() == 1 {
        build_or_expr(children.remove(0))
    } else {
        Err(err("unexpected ternary structure"))
    }
}

fn build_left_assoc_binop(pairs: Vec<pest::iterators::Pair<'_, Rule>>, build_operand: fn(pest::iterators::Pair<'_, Rule>) -> Result<Expr, ParseError>) -> Result<Expr, ParseError> {
    // pairs alternates: operand, op_text, operand, op_text, operand, ...
    // But pest gives us: child1, child2, child3... where odd ones are operators and even ones are operands
    // Actually for rules like `and_expr ~ ("||" ~ and_expr)*`, pest gives us all the and_expr children
    // The operators are implicit in the rule structure.
    // We need to handle this differently.

    if pairs.len() == 1 {
        return build_operand(pairs.into_iter().next().unwrap());
    }

    let mut iter = pairs.into_iter();
    let first = iter.next().unwrap();
    let mut result = build_operand(first)?;

    for pair in iter {
        let right = build_operand(pair)?;
        // We need to figure out the operator from the parent rule
        // This approach won't work cleanly. Let me restructure.
        result = Expr::BinaryOp {
            op: BinOp::Or, // placeholder
            left: Box::new(result),
            right: Box::new(right),
        };
    }

    Ok(result)
}

fn build_or_expr(pair: pest::iterators::Pair<'_, Rule>) -> Result<Expr, ParseError> {
    let children: Vec<pest::iterators::Pair<'_, Rule>> = pair.into_inner().collect();
    if children.is_empty() {
        return Err(err("empty or_expr"));
    }
    let mut result = build_and_expr(children[0].clone())?;
    for i in 1..children.len() {
        let right = build_and_expr(children[i].clone())?;
        result = Expr::BinaryOp { op: BinOp::Or, left: Box::new(result), right: Box::new(right) };
    }
    Ok(result)
}

fn build_and_expr(pair: pest::iterators::Pair<'_, Rule>) -> Result<Expr, ParseError> {
    let children: Vec<pest::iterators::Pair<'_, Rule>> = pair.into_inner().collect();
    if children.is_empty() { return Err(err("empty and_expr")); }
    let mut result = build_bitor_expr(children[0].clone())?;
    for i in 1..children.len() {
        let right = build_bitor_expr(children[i].clone())?;
        result = Expr::BinaryOp { op: BinOp::And, left: Box::new(result), right: Box::new(right) };
    }
    Ok(result)
}

fn build_bitor_expr(pair: pest::iterators::Pair<'_, Rule>) -> Result<Expr, ParseError> {
    let children: Vec<pest::iterators::Pair<'_, Rule>> = pair.into_inner().collect();
    if children.is_empty() { return Err(err("empty bitor_expr")); }
    let mut result = build_bitxor_expr(children[0].clone())?;
    for i in 1..children.len() {
        let right = build_bitxor_expr(children[i].clone())?;
        result = Expr::BinaryOp { op: BinOp::BitOr, left: Box::new(result), right: Box::new(right) };
    }
    Ok(result)
}

fn build_bitxor_expr(pair: pest::iterators::Pair<'_, Rule>) -> Result<Expr, ParseError> {
    let children: Vec<pest::iterators::Pair<'_, Rule>> = pair.into_inner().collect();
    if children.is_empty() { return Err(err("empty bitxor_expr")); }
    let mut result = build_bitand_expr(children[0].clone())?;
    for i in 1..children.len() {
        let right = build_bitand_expr(children[i].clone())?;
        result = Expr::BinaryOp { op: BinOp::BitXor, left: Box::new(result), right: Box::new(right) };
    }
    Ok(result)
}

fn build_bitand_expr(pair: pest::iterators::Pair<'_, Rule>) -> Result<Expr, ParseError> {
    let children: Vec<pest::iterators::Pair<'_, Rule>> = pair.into_inner().collect();
    if children.is_empty() { return Err(err("empty bitand_expr")); }
    let mut result = build_equality_expr(children[0].clone())?;
    for i in 1..children.len() {
        let right = build_equality_expr(children[i].clone())?;
        result = Expr::BinaryOp { op: BinOp::BitAnd, left: Box::new(result), right: Box::new(right) };
    }
    Ok(result)
}

fn build_equality_expr(pair: pest::iterators::Pair<'_, Rule>) -> Result<Expr, ParseError> {
    let children: Vec<pest::iterators::Pair<'_, Rule>> = pair.into_inner().collect();
    if children.is_empty() { return Err(err("empty equality_expr")); }

    let mut result = build_comparison_expr(children[0].clone())?;
    let mut i = 1;
    while i < children.len() {
        if children[i].as_rule() == Rule::equality_op {
            let op = match children[i].as_str() {
                "==" => BinOp::Eq,
                "!=" => BinOp::Ne,
                _ => BinOp::Eq,
            };
            i += 1;
            if i < children.len() {
                let right = build_comparison_expr(children[i].clone())?;
                result = Expr::BinaryOp { op, left: Box::new(result), right: Box::new(right) };
            }
        }
        i += 1;
    }
    Ok(result)
}

fn build_comparison_expr(pair: pest::iterators::Pair<'_, Rule>) -> Result<Expr, ParseError> {
    let children: Vec<pest::iterators::Pair<'_, Rule>> = pair.into_inner().collect();
    if children.is_empty() { return Err(err("empty comparison_expr")); }

    let mut result = build_shift_expr(children[0].clone())?;
    let mut i = 1;
    while i < children.len() {
        if children[i].as_rule() == Rule::comparison_op {
            let op = match children[i].as_str() {
                "<" => BinOp::Lt,
                ">" => BinOp::Gt,
                "<=" => BinOp::Le,
                ">=" => BinOp::Ge,
                _ => BinOp::Lt,
            };
            i += 1;
            if i < children.len() {
                let right = build_shift_expr(children[i].clone())?;
                result = Expr::BinaryOp { op, left: Box::new(result), right: Box::new(right) };
            }
        }
        i += 1;
    }
    Ok(result)
}

fn build_shift_expr(pair: pest::iterators::Pair<'_, Rule>) -> Result<Expr, ParseError> {
    let children: Vec<pest::iterators::Pair<'_, Rule>> = pair.into_inner().collect();
    if children.is_empty() { return Err(err("empty shift_expr")); }

    let mut result = build_add_expr(children[0].clone())?;
    let mut i = 1;
    while i < children.len() {
        if children[i].as_rule() == Rule::shift_op {
            let op = match children[i].as_str() {
                "<<" => BinOp::Shl,
                ">>" => BinOp::Shr,
                _ => BinOp::Shl,
            };
            i += 1;
            if i < children.len() {
                let right = build_add_expr(children[i].clone())?;
                result = Expr::BinaryOp { op, left: Box::new(result), right: Box::new(right) };
            }
        }
        i += 1;
    }
    Ok(result)
}

fn build_add_expr(pair: pest::iterators::Pair<'_, Rule>) -> Result<Expr, ParseError> {
    let children: Vec<pest::iterators::Pair<'_, Rule>> = pair.into_inner().collect();
    if children.is_empty() { return Err(err("empty add_expr")); }

    let mut result = build_mul_expr(children[0].clone())?;
    let mut i = 1;
    while i < children.len() {
        if children[i].as_rule() == Rule::add_op {
            let op = match children[i].as_str() {
                "+" => BinOp::Add,
                "-" => BinOp::Sub,
                _ => BinOp::Add,
            };
            i += 1;
            if i < children.len() {
                let right = build_mul_expr(children[i].clone())?;
                result = Expr::BinaryOp { op, left: Box::new(result), right: Box::new(right) };
            }
        }
        i += 1;
    }
    Ok(result)
}

fn build_mul_expr(pair: pest::iterators::Pair<'_, Rule>) -> Result<Expr, ParseError> {
    let children: Vec<pest::iterators::Pair<'_, Rule>> = pair.into_inner().collect();
    if children.is_empty() { return Err(err("empty mul_expr")); }

    let mut result = build_unary_expr(children[0].clone())?;
    let mut i = 1;
    while i < children.len() {
        if children[i].as_rule() == Rule::mul_op {
            let op = match children[i].as_str() {
                "*" => BinOp::Mul,
                "/" => BinOp::Div,
                "\\" => BinOp::IntDiv,
                "%" => BinOp::Mod,
                _ => BinOp::Mul,
            };
            i += 1;
            if i < children.len() {
                let right = build_unary_expr(children[i].clone())?;
                result = Expr::BinaryOp { op, left: Box::new(result), right: Box::new(right) };
            }
        }
        i += 1;
    }
    Ok(result)
}

fn build_unary_expr(pair: pest::iterators::Pair<'_, Rule>) -> Result<Expr, ParseError> {
    let text = pair.as_str().trim();
    let mut children: Vec<pest::iterators::Pair<'_, Rule>> = pair.into_inner().collect();

    if children.is_empty() {
        return Err(err(format!("empty unary_expr: '{}'", text)));
    }

    // In pest, unary operator literals ("-", "!", "+") are not captured
    // as separate children. When the grammar matches "-" ~ unary_expr,
    // we get a single child (the inner unary_expr) and the operator is
    // only visible in the outer pair's text. Detect operators by checking
    // whether the text starts with the operator character AND the single
    // child's text is shorter (i.e., the operator is not part of the child).
    if children.len() == 1 {
        let child = children.remove(0);
        let child_text = child.as_str().trim();

        // Check if there's a unary prefix operator by comparing the
        // outer text with the child text. If the outer text starts with
        // an operator and the child text doesn't include it, we have a
        // unary op.
        if text.starts_with('-') && !child_text.starts_with('-')
            || (text.starts_with('-') && text.len() > child_text.len())
        {
            let inner_expr = match child.as_rule() {
                Rule::unary_expr => build_unary_expr(child)?,
                Rule::pow_expr => build_pow_expr(child)?,
                Rule::prefix_row_offset => build_prefix_row_offset(child)?,
                _ => build_pow_expr(child)?,
            };
            return Ok(Expr::UnaryOp { op: UnaryOp::Neg, operand: Box::new(inner_expr) });
        }
        if text.starts_with('!') && !child_text.starts_with('!')
            || (text.starts_with('!') && text.len() > child_text.len())
        {
            let inner_expr = match child.as_rule() {
                Rule::unary_expr => build_unary_expr(child)?,
                Rule::pow_expr => build_pow_expr(child)?,
                Rule::prefix_row_offset => build_prefix_row_offset(child)?,
                _ => build_pow_expr(child)?,
            };
            return Ok(Expr::UnaryOp { op: UnaryOp::Not, operand: Box::new(inner_expr) });
        }
        if text.starts_with('+') && !child_text.starts_with('+')
            || (text.starts_with('+') && text.len() > child_text.len())
        {
            return match child.as_rule() {
                Rule::unary_expr => build_unary_expr(child),
                Rule::pow_expr => build_pow_expr(child),
                Rule::prefix_row_offset => build_prefix_row_offset(child),
                _ => build_pow_expr(child),
            };
        }

        return match child.as_rule() {
            Rule::unary_expr => build_unary_expr(child),
            Rule::pow_expr => build_pow_expr(child),
            Rule::prefix_row_offset => build_prefix_row_offset(child),
            _ => build_pow_expr(child),
        };
    }

    // Two or more children: operator tokens may appear as children in
    // some pest configurations. Handle similarly.
    let operand = children.pop().unwrap();
    if text.starts_with('-') {
        let inner_expr = build_unary_expr(operand)?;
        return Ok(Expr::UnaryOp { op: UnaryOp::Neg, operand: Box::new(inner_expr) });
    }
    if text.starts_with('!') {
        let inner_expr = build_unary_expr(operand)?;
        return Ok(Expr::UnaryOp { op: UnaryOp::Not, operand: Box::new(inner_expr) });
    }
    if text.starts_with('+') {
        return build_unary_expr(operand);
    }

    // Fallback
    build_pow_expr(operand)
}

fn build_pow_expr(pair: pest::iterators::Pair<'_, Rule>) -> Result<Expr, ParseError> {
    let children: Vec<pest::iterators::Pair<'_, Rule>> = pair.into_inner().collect();
    if children.is_empty() {
        return Err(err("empty pow_expr"));
    }

    let base = build_postfix_expr(children[0].clone())?;
    if children.len() >= 2 {
        let exp = build_unary_expr(children[1].clone())?;
        Ok(Expr::BinaryOp { op: BinOp::Pow, left: Box::new(base), right: Box::new(exp) })
    } else {
        Ok(base)
    }
}

fn build_prefix_row_offset(pair: pest::iterators::Pair<'_, Rule>) -> Result<Expr, ParseError> {
    let children: Vec<pest::iterators::Pair<'_, Rule>> = pair.into_inner().collect();
    if children.is_empty() {
        return Err(err("empty prefix_row_offset"));
    }

    // Three forms:
    // 1. (expr) ' postfix_expr  → children: [expression, postfix_expr]
    // 2. number ' postfix_expr  → children: [number, postfix_expr]
    // 3. ' postfix_expr         → children: [postfix_expr]
    if children.len() >= 2 && children[0].as_rule() == Rule::expression {
        let offset = build_expression(children[0].clone())?;
        let base = build_postfix_expr(children[1].clone())?;
        Ok(Expr::RowOffset { base: Box::new(base), offset: Box::new(offset) })
    } else if children.len() >= 2 && children[0].as_rule() == Rule::number {
        let offset = make_number_expr(children[0].as_str());
        let base = build_postfix_expr(children[1].clone())?;
        Ok(Expr::RowOffset { base: Box::new(base), offset: Box::new(offset) })
    } else {
        let base = build_postfix_expr(children[0].clone())?;
        Ok(Expr::RowOffset { base: Box::new(base), offset: Box::new(one_literal()) })
    }
}

fn build_postfix_expr(pair: pest::iterators::Pair<'_, Rule>) -> Result<Expr, ParseError> {
    let children: Vec<pest::iterators::Pair<'_, Rule>> = pair.into_inner().collect();
    if children.is_empty() {
        return Err(err("empty postfix_expr"));
    }

    let mut result = build_atom_expr(children[0].clone())?;

    for i in 1..children.len() {
        if children[i].as_rule() == Rule::postfix_suffix {
            let suffix_text = children[i].as_str().trim();
            let suffix_children: Vec<pest::iterators::Pair<'_, Rule>> = children[i].clone().into_inner().collect();

            if suffix_text.starts_with("'(") {
                // Row offset with expression: ident'(expr)
                if let Some(expr_pair) = suffix_children.into_iter().find(|p| p.as_rule() == Rule::expression) {
                    let offset = build_expression(expr_pair)?;
                    result = Expr::RowOffset {
                        base: Box::new(result),
                        offset: Box::new(offset),
                    };
                }
            } else if suffix_text.starts_with("'") && suffix_children.iter().any(|p| p.as_rule() == Rule::number) {
                // Row offset with number: ident'N
                if let Some(num_pair) = suffix_children.into_iter().find(|p| p.as_rule() == Rule::number) {
                    let offset = make_number_expr(num_pair.as_str());
                    result = Expr::RowOffset {
                        base: Box::new(result),
                        offset: Box::new(offset),
                    };
                }
            } else if suffix_text == "'" {
                result = Expr::RowOffset {
                    base: Box::new(result),
                    offset: Box::new(one_literal()),
                };
            } else if suffix_text.starts_with('[') {
                // Array index
                if let Some(expr_pair) = suffix_children.into_iter().find(|p| p.as_rule() == Rule::expression) {
                    let idx = build_expression(expr_pair)?;
                    result = Expr::ArrayIndex { base: Box::new(result), index: Box::new(idx) };
                }
            } else if suffix_text.starts_with('.') {
                // Member access (ident or template literal)
                if let Some(tl_pair) = suffix_children.iter().find(|p| p.as_rule() == Rule::template_lit) {
                    result = Expr::MemberAccess { base: Box::new(result), member: strip_quotes(tl_pair.as_str()) };
                } else if let Some(ident_pair) = suffix_children.into_iter().find(|p| p.as_rule() == Rule::ident) {
                    result = Expr::MemberAccess { base: Box::new(result), member: ident_pair.as_str().to_string() };
                }
            }
        }
    }

    Ok(result)
}

fn build_atom_expr(pair: pest::iterators::Pair<'_, Rule>) -> Result<Expr, ParseError> {
    let inner = pair.into_inner().next().ok_or_else(|| err("empty atom_expr"))?;

    match inner.as_rule() {
        Rule::expression => build_expression(inner),
        Rule::number => Ok(make_number_expr(inner.as_str())),
        Rule::string_lit => Ok(Expr::StringLit(StringLiteral {
            value: strip_quotes(inner.as_str()),
            is_template: false,
        })),
        Rule::template_lit => Ok(Expr::TemplateString(strip_quotes(inner.as_str()))),
        Rule::positional_param => {
            let num_str = &inner.as_str()[1..]; // strip $
            Ok(Expr::PositionalParam(parse_u64(num_str)))
        }
        Rule::cast_expr => build_cast_expr(inner),
        Rule::func_call_expr => {
            let call = build_func_call_expr(inner)?;
            Ok(Expr::FunctionCall(call))
        }
        Rule::comma_sep_expr => {
            let exprs = build_comma_sep_expr(inner)?;
            Ok(Expr::ArrayLiteral(exprs))
        }
        Rule::keyword_dot_ident => {
            Ok(Expr::Reference(NameId {
                path: inner.as_str().to_string(),
                indexes: vec![],
                row_offset: None,
            }))
        }
        Rule::ident => {
            Ok(Expr::Reference(NameId {
                path: inner.as_str().to_string(),
                indexes: vec![],
                row_offset: None,
            }))
        }
        other => Err(err(format!("unexpected atom rule: {:?}", other))),
    }
}

fn build_cast_expr(pair: pest::iterators::Pair<'_, Rule>) -> Result<Expr, ParseError> {
    let mut cast_type = String::new();
    let mut value = Expr::Number(NumericLiteral { value: "0".to_string(), radix: NumericRadix::Decimal });

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::cast_type_kw => { cast_type = inner.as_str().to_string(); }
            Rule::expression => { value = build_expression(inner)?; }
            _ => {}
        }
    }

    Ok(Expr::Cast { cast_type, dim: 0, value: Box::new(value) })
}

fn build_func_call_expr(pair: pest::iterators::Pair<'_, Rule>) -> Result<FunctionCall, ParseError> {
    let mut function = NameRef { path: String::new(), indexes: vec![] };
    let mut args = Vec::new();

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::name_optional_index => {
                let (path, indexes) = build_name_optional_index(inner)?;
                function = NameRef { path, indexes };
            }
            Rule::multi_expression_list => {
                args = build_multi_expression_list(inner)?;
            }
            _ => {}
        }
    }

    Ok(FunctionCall { function, args })
}

// ---------------------------------------------------------------------------
// Multi-expression list
// ---------------------------------------------------------------------------

fn build_multi_expression_list(pair: pest::iterators::Pair<'_, Rule>) -> Result<Vec<CallArg>, ParseError> {
    let mut args = Vec::new();
    for inner in pair.into_inner() {
        if inner.as_rule() == Rule::multi_expression_item {
            args.push(build_multi_expression_item(inner)?);
        }
    }
    Ok(args)
}

fn build_multi_expression_item(pair: pest::iterators::Pair<'_, Rule>) -> Result<CallArg, ParseError> {
    let pair_text = pair.as_str().to_string();
    let children: Vec<pest::iterators::Pair<'_, Rule>> = pair.into_inner().collect();

    if children.is_empty() {
        return Err(err("empty multi_expression_item"));
    }

    // Named argument patterns: ident ":" ...
    if children.len() >= 2 && children[0].as_rule() == Rule::ident {
        let name = children[0].as_str().to_string();

        // Check for ident : [exprs]
        if children[1].as_rule() == Rule::comma_sep_expr {
            let exprs = build_comma_sep_expr(children[1].clone())?;
            return Ok(CallArg { name: Some(name.clone()), value: Expr::ArrayLiteral(exprs) });
        }

        // Check for ident : expression
        if children[1].as_rule() == Rule::expression {
            let expr = build_expression(children[1].clone())?;
            return Ok(CallArg { name: Some(name), value: expr });
        }
    }

    // Named argument with shorthand: ident :
    if children.len() == 1 && children[0].as_rule() == Rule::ident && pair_text.contains(':') {
        let name = children[0].as_str().to_string();
        return Ok(CallArg {
            name: Some(name.clone()),
            value: Expr::Reference(NameId { path: name, indexes: vec![], row_offset: None }),
        });
    }

    // Bare [exprs] argument
    if children[0].as_rule() == Rule::comma_sep_expr {
        let exprs = build_comma_sep_expr(children[0].clone())?;
        return Ok(CallArg { name: None, value: Expr::ArrayLiteral(exprs) });
    }

    // Simple expression argument
    if children[0].as_rule() == Rule::expression {
        let expr = build_expression(children[0].clone())?;
        return Ok(CallArg { name: None, value: expr });
    }

    // Fallback: treat first child's text as ident (for the "ident:" case)
    if children[0].as_rule() == Rule::ident {
        let name = children[0].as_str().to_string();
        return Ok(CallArg {
            name: Some(name.clone()),
            value: Expr::Reference(NameId { path: name, indexes: vec![], row_offset: None }),
        });
    }

    Err(err("unexpected multi_expression_item"))
}

fn build_comma_sep_expr(pair: pest::iterators::Pair<'_, Rule>) -> Result<Vec<Expr>, ParseError> {
    let mut result = Vec::new();
    for inner in pair.into_inner() {
        if inner.as_rule() == Rule::expression {
            result.push(build_expression(inner)?);
        }
    }
    Ok(result)
}

// ---------------------------------------------------------------------------
// Sequence definition
// ---------------------------------------------------------------------------

fn build_sequence_def(pair: pest::iterators::Pair<'_, Rule>) -> Result<SequenceDef, ParseError> {
    let text = pair.as_str().trim();
    let is_padded = text.ends_with("...") || text.ends_with("*");
    let _has_colon = text.contains("]:") || text.contains("] :");

    let mut elements = Vec::new();
    let mut repeat_times: Option<Expr> = None;

    for inner in pair.into_inner() {
        match inner.as_rule() {
            Rule::comma_sep_seq_elem => {
                elements = build_comma_sep_seq_elem(inner)?;
            }
            Rule::expression => {
                repeat_times = Some(build_expression(inner)?);
            }
            _ => {}
        }
    }

    if let Some(times) = repeat_times {
        let sub_seq = SequenceDef { elements, is_padded: false };
        let repeat_elem = SequenceElement::Repeat {
            value: Expr::Sequence(sub_seq),
            times,
        };
        if is_padded {
            Ok(SequenceDef {
                elements: vec![SequenceElement::Padding(Box::new(repeat_elem))],
                is_padded: true,
            })
        } else {
            Ok(SequenceDef {
                elements: vec![repeat_elem],
                is_padded: false,
            })
        }
    } else {
        Ok(SequenceDef { elements, is_padded })
    }
}

fn is_open_ended_placeholder(elem: &SequenceElement) -> bool {
    let t1 = match elem {
        SequenceElement::ArithSeq { t1, .. } | SequenceElement::GeomSeq { t1, .. } => t1,
        _ => return false,
    };
    matches!(t1.as_ref(), SequenceElement::Value(Expr::Reference(NameId { path, .. })) if path == "__OPEN_ENDED__")
}

fn build_comma_sep_seq_elem(pair: pest::iterators::Pair<'_, Rule>) -> Result<Vec<SequenceElement>, ParseError> {
    let mut result = Vec::new();
    for inner in pair.into_inner() {
        if inner.as_rule() == Rule::sequence_element {
            let elem = build_sequence_element(inner)?;
            // For open-ended arith/geom sequences, pop the previous element as t1
            if is_open_ended_placeholder(&elem) && !result.is_empty() {
                let prev = result.pop().unwrap();
                match elem {
                    SequenceElement::ArithSeq { t2, tn, .. } => {
                        result.push(SequenceElement::ArithSeq {
                            t1: Box::new(prev), t2, tn,
                        });
                    }
                    SequenceElement::GeomSeq { t2, tn, .. } => {
                        result.push(SequenceElement::GeomSeq {
                            t1: Box::new(prev), t2, tn,
                        });
                    }
                    _ => unreachable!(),
                }
            } else {
                result.push(elem);
            }
        }
    }
    Ok(result)
}

fn build_seq_value(pair: pest::iterators::Pair<'_, Rule>) -> Result<SequenceElement, ParseError> {
    let children: Vec<pest::iterators::Pair<'_, Rule>> = pair.into_inner().collect();
    if children.len() >= 2 {
        // expression ~ ":" ~ expression  →  Repeat { value, times }
        let value = build_expression(children[0].clone())?;
        let times = build_expression(children[1].clone())?;
        Ok(SequenceElement::Repeat { value, times })
    } else if children.len() == 1 {
        // expression  →  Value
        let expr = build_expression(children[0].clone())?;
        Ok(SequenceElement::Value(expr))
    } else {
        Err(err("empty seq_value"))
    }
}

fn build_sub_seq_elem(pair: pest::iterators::Pair<'_, Rule>) -> Result<Vec<SequenceElement>, ParseError> {
    for inner in pair.into_inner() {
        if inner.as_rule() == Rule::comma_sep_seq_elem {
            return build_comma_sep_seq_elem(inner);
        }
    }
    Err(err("empty sub_seq_elem"))
}

fn build_sequence_element(pair: pest::iterators::Pair<'_, Rule>) -> Result<SequenceElement, ParseError> {
    let text = pair.as_str().trim().to_string();
    let children: Vec<pest::iterators::Pair<'_, Rule>> = pair.into_inner().collect();

    if children.is_empty() {
        return Err(err("empty sequence_element"));
    }

    let first_rule = children[0].as_rule();

    // sub_seq_elem  (with optional ":" expression for repeat count)
    if first_rule == Rule::sub_seq_elem {
        let sub_elements = build_sub_seq_elem(children[0].clone())?;
        if children.len() >= 2 && children[1].as_rule() == Rule::expression {
            // [sub_seq] : times  →  Repeat of a Sequence
            let times = build_expression(children[1].clone())?;
            let sub_seq = SequenceDef { elements: sub_elements, is_padded: false };
            return Ok(SequenceElement::Repeat {
                value: Expr::Sequence(sub_seq),
                times,
            });
        } else {
            // plain [sub_seq]
            return Ok(SequenceElement::SubSeq(sub_elements));
        }
    }

    // All remaining alternatives use seq_value children
    let seq_values: Vec<pest::iterators::Pair<'_, Rule>> = children.iter()
        .filter(|p| p.as_rule() == Rule::seq_value)
        .cloned()
        .collect();

    if seq_values.is_empty() {
        return Err(err("sequence_element: no seq_value children"));
    }

    // Arithmetic/geometric sequences
    if text.contains("..+..") {
        if seq_values.len() >= 2 {
            let t1 = build_seq_value(seq_values[0].clone())?;
            let t2 = build_seq_value(seq_values[1].clone())?;
            let tn = if seq_values.len() >= 3 {
                Some(Box::new(build_seq_value(seq_values[2].clone())?))
            } else {
                None
            };
            return Ok(SequenceElement::ArithSeq { t1: Box::new(t1), t2: Box::new(t2), tn });
        } else {
            // Open-ended: seq_value ..+.. (only t2; t1 will be filled from prev at list level)
            let t2 = build_seq_value(seq_values[0].clone())?;
            return Ok(SequenceElement::ArithSeq {
                t1: Box::new(SequenceElement::Value(Expr::Reference(NameId {
                    path: "__OPEN_ENDED__".to_string(), indexes: vec![], row_offset: None,
                }))),
                t2: Box::new(t2),
                tn: None,
            });
        }
    }

    if text.contains("..*..") {
        if seq_values.len() >= 2 {
            let t1 = build_seq_value(seq_values[0].clone())?;
            let t2 = build_seq_value(seq_values[1].clone())?;
            let tn = if seq_values.len() >= 3 {
                Some(Box::new(build_seq_value(seq_values[2].clone())?))
            } else {
                None
            };
            return Ok(SequenceElement::GeomSeq { t1: Box::new(t1), t2: Box::new(t2), tn });
        } else {
            // Open-ended: seq_value ..*.. (only t2; t1 will be filled from prev at list level)
            let t2 = build_seq_value(seq_values[0].clone())?;
            return Ok(SequenceElement::GeomSeq {
                t1: Box::new(SequenceElement::Value(Expr::Reference(NameId {
                    path: "__OPEN_ENDED__".to_string(), indexes: vec![], row_offset: None,
                }))),
                t2: Box::new(t2),
                tn: None,
            });
        }
    }

    // Range (..)
    if text.contains("..") && !text.contains("...") && seq_values.len() == 2 {
        let sv1 = build_seq_value(seq_values[0].clone())?;
        let sv2 = build_seq_value(seq_values[1].clone())?;
        // Extract from/to and optional repeat times
        let (from, from_times) = match sv1 {
            SequenceElement::Repeat { value, times } => (value, Some(times)),
            SequenceElement::Value(v) => (v, None),
            _ => return Err(err("unexpected seq_value in range")),
        };
        let (to, to_times) = match sv2 {
            SequenceElement::Repeat { value, times } => (value, Some(times)),
            SequenceElement::Value(v) => (v, None),
            _ => return Err(err("unexpected seq_value in range")),
        };
        return Ok(SequenceElement::Range { from, to, from_times, to_times });
    }

    // Padding (...)
    if text.ends_with("...") && seq_values.len() == 1 {
        let inner = build_seq_value(seq_values[0].clone())?;
        return Ok(SequenceElement::Padding(Box::new(inner)));
    }

    // Simple value (possibly with repeat count)
    if seq_values.len() == 1 {
        return build_seq_value(seq_values[0].clone());
    }

    Err(err(&format!("unrecognized sequence_element: {}", text)))
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
