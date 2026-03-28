/// AST node types for the PIL2 language.
///
/// This module defines the abstract syntax tree produced by the parser.
/// The structure mirrors the semantic categories found in the Jison grammar:
/// programs, declarations, statements, expressions, and column types.

// ---------------------------------------------------------------------------
// Source location
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, PartialEq, Default)]
pub struct Span {
    pub start: usize,
    pub end: usize,
}

// ---------------------------------------------------------------------------
// Top-level program
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, PartialEq)]
pub struct Program {
    pub statements: Vec<Statement>,
}

// ---------------------------------------------------------------------------
// Statements
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, PartialEq)]
pub enum Statement {
    /// `include "file.pil"` or `require "file.pil"`
    Include(IncludeStmt),

    /// `#pragma ...`
    Pragma(String),

    /// `airgroup Name { ... }`
    AirGroupDef(AirGroupDef),

    /// `airtemplate Name(args) { ... }` or `airtemplate Name { ... }`
    AirTemplateDef(AirTemplateDef),

    /// `function name(args) { ... }`
    FunctionDef(FunctionDef),

    /// `col witness ...` / `col fixed ...`
    ColDeclaration(ColDeclaration),

    /// `challenge ...`
    ChallengeDeclaration(ChallengeDeclaration),

    /// `public ...`
    PublicDeclaration(PublicDeclaration),

    /// `proofval ...`
    ProofValueDeclaration(ProofValueDeclaration),

    /// `airgroupval ...`
    AirGroupValueDeclaration(AirGroupValueDeclaration),

    /// `airval ...`
    AirValueDeclaration(AirValueDeclaration),

    /// Variable declaration: `int x = 5;` / `const int Y = 10;`
    VariableDeclaration(VariableDeclaration),

    /// Assignment: `x = expr;`, `x += expr;`
    Assignment(Assignment),

    /// Constraint: `lhs === rhs`
    Constraint(Constraint),

    /// `if (cond) { ... } else { ... }`
    If(IfStmt),

    /// `for (init; cond; incr) { ... }`
    For(ForStmt),

    /// `while (cond) { ... }`
    While(WhileStmt),

    /// `switch (expr) { case ...: ... }`
    Switch(SwitchStmt),

    /// `return expr;`
    Return(ReturnStmt),

    /// `break;`
    Break,

    /// `continue;`
    Continue,

    /// Expression used as a statement (e.g. function call)
    ExprStatement(ExprStmt),

    /// `container Name { ... }` or `container Name`
    Container(ContainerDef),

    /// `use Name` / `use Name alias Alias`
    Use(UseDef),

    /// `virtual expr`
    VirtualExpr(VirtualExprStmt),

    /// `package Name { ... }`
    Package(PackageDef),

    /// `on final air func(args)`
    DeferredCall(DeferredCall),

    /// `commit stage(...) public(...) name`
    CommitDeclaration(CommitDeclaration),

    /// Hint: `@name { ... }` / `@name [...]` / `@name expr`
    Hint(HintStmt),

    /// `when (cond) stmt` or `when boundary stmt`
    When(WhenStmt),

    /// Bare scope: `{ ... }`
    Block(Vec<Statement>),

    /// `publictable ...`
    PublicTableDeclaration(PublicTableDeclaration),
}

// ---------------------------------------------------------------------------
// Include / require
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, PartialEq)]
pub struct IncludeStmt {
    pub kind: IncludeKind,
    pub visibility: Visibility,
    pub path: StringLiteral,
}

#[derive(Debug, Clone, PartialEq)]
pub enum IncludeKind {
    Include,
    Require,
}

#[derive(Debug, Clone, PartialEq)]
pub enum Visibility {
    Public,
    Private,
}

// ---------------------------------------------------------------------------
// Airgroup / airtemplate
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, PartialEq)]
pub struct AirGroupDef {
    pub name: String,
    pub statements: Vec<Statement>,
}

#[derive(Debug, Clone, PartialEq)]
pub struct AirTemplateDef {
    pub name: String,
    pub args: Vec<FunctionArg>,
    pub has_args: bool,
    pub statements: Vec<Statement>,
}

// ---------------------------------------------------------------------------
// Function definition
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, PartialEq)]
pub struct FunctionDef {
    pub name: String,
    pub visibility: Visibility,
    pub is_final: Option<FinalScope>,
    pub args: Vec<FunctionArg>,
    pub varargs: bool,
    pub returns: Option<Vec<ReturnType>>,
    pub body: Vec<Statement>,
}

#[derive(Debug, Clone, PartialEq)]
pub enum FinalScope {
    Air,
    Proof,
    AirGroup,
}

#[derive(Debug, Clone, PartialEq)]
pub struct FunctionArg {
    pub type_info: BasicType,
    pub name: String,
    pub is_array: bool,
    pub array_dims: u32,
    pub default_value: Option<Expr>,
}

#[derive(Debug, Clone, PartialEq)]
pub struct ReturnType {
    pub type_info: BasicType,
    pub dim: u32,
}

// ---------------------------------------------------------------------------
// Basic types
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, PartialEq)]
pub struct BasicType {
    pub kind: TypeKind,
    pub is_const: bool,
}

#[derive(Debug, Clone, PartialEq)]
pub enum TypeKind {
    Int,
    Fe,
    Expr,
    StringType,
    Witness,
    Fixed,
    Challenge,
    Public,
    PublicTable,
    Proof,
    AirGroup,
    Air,
    Function,
    Custom(String),
}

// ---------------------------------------------------------------------------
// Column declarations
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, PartialEq)]
pub struct ColDeclaration {
    pub col_type: ColType,
    pub items: Vec<ColDeclItem>,
    pub features: Vec<ColFeature>,
    /// For `col fixed NAME = expr`
    pub init: Option<ColInit>,
}

#[derive(Debug, Clone, PartialEq)]
pub enum ColType {
    Witness,
    Fixed,
    Custom(String),
}

#[derive(Debug, Clone, PartialEq)]
pub struct ColDeclItem {
    pub name: String,
    pub is_template: bool,
    pub array_dims: Vec<Option<Expr>>,
}

#[derive(Debug, Clone, PartialEq)]
pub struct ColFeature {
    pub name: String,
    pub args: Vec<CallArg>,
}

#[derive(Debug, Clone, PartialEq)]
pub enum ColInit {
    Expression(Expr),
    Sequence(SequenceDef),
}

// ---------------------------------------------------------------------------
// Challenge / public / proofval / airgroupval / airval declarations
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, PartialEq)]
pub struct ChallengeDeclaration {
    pub stage: Option<u64>,
    pub items: Vec<ColDeclItem>,
}

#[derive(Debug, Clone, PartialEq)]
pub struct PublicDeclaration {
    pub items: Vec<ColDeclItem>,
    pub init: Option<Expr>,
}

#[derive(Debug, Clone, PartialEq)]
pub struct PublicTableDeclaration {
    pub aggregate_type: String,
    pub aggregate_function: String,
    pub name: String,
    pub args: Vec<Expr>,
    pub cols: Expr,
    pub rows: Expr,
}

#[derive(Debug, Clone, PartialEq)]
pub struct ProofValueDeclaration {
    pub stage: Option<u64>,
    pub items: Vec<ColDeclItem>,
}

#[derive(Debug, Clone, PartialEq)]
pub struct AirGroupValueDeclaration {
    pub stage: Option<u64>,
    pub default_value: Option<Expr>,
    pub aggregate_type: Option<String>,
    pub items: Vec<ColDeclItem>,
}

#[derive(Debug, Clone, PartialEq)]
pub struct AirValueDeclaration {
    pub stage: Option<u64>,
    pub items: Vec<ColDeclItem>,
}

#[derive(Debug, Clone, PartialEq)]
pub struct CommitDeclaration {
    pub stage: Option<u64>,
    pub publics: Vec<String>,
    pub name: String,
}

// ---------------------------------------------------------------------------
// Variable declaration
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, PartialEq)]
pub struct VariableDeclaration {
    pub is_const: bool,
    pub vtype: TypeKind,
    pub items: Vec<VarDeclItem>,
    pub init: Option<Expr>,
    pub is_multiple: bool,
}

#[derive(Debug, Clone, PartialEq)]
pub struct VarDeclItem {
    pub name: String,
    pub array_dims: Vec<Option<Expr>>,
}

// ---------------------------------------------------------------------------
// Assignment
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, PartialEq)]
pub struct Assignment {
    pub target: NameId,
    pub op: AssignOp,
    pub value: AssignValue,
}

#[derive(Debug, Clone, PartialEq)]
pub enum AssignOp {
    Assign,
    AddAssign,
    SubAssign,
    MulAssign,
}

#[derive(Debug, Clone, PartialEq)]
pub enum AssignValue {
    Expr(Expr),
    Sequence(SequenceDef),
}

// ---------------------------------------------------------------------------
// Constraint
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, PartialEq)]
pub struct Constraint {
    pub left: Expr,
    pub right: Expr,
    pub is_witness: bool,
}

// ---------------------------------------------------------------------------
// Control flow
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, PartialEq)]
pub struct IfStmt {
    pub condition: Expr,
    pub then_body: Vec<Statement>,
    pub elseif_clauses: Vec<ElseIfClause>,
    pub else_body: Option<Vec<Statement>>,
}

#[derive(Debug, Clone, PartialEq)]
pub struct ElseIfClause {
    pub condition: Expr,
    pub body: Vec<Statement>,
}

#[derive(Debug, Clone, PartialEq)]
pub struct ForStmt {
    pub init: Box<Statement>,
    pub condition: Expr,
    pub increment: Vec<Assignment>,
    pub body: Vec<Statement>,
}

#[derive(Debug, Clone, PartialEq)]
pub struct WhileStmt {
    pub condition: Expr,
    pub body: Vec<Statement>,
}

#[derive(Debug, Clone, PartialEq)]
pub struct SwitchStmt {
    pub value: Expr,
    pub cases: Vec<CaseClause>,
    pub default: Option<Vec<Statement>>,
}

#[derive(Debug, Clone, PartialEq)]
pub struct CaseClause {
    pub values: Vec<CaseValue>,
    pub body: Vec<Statement>,
}

#[derive(Debug, Clone, PartialEq)]
pub enum CaseValue {
    Single(Expr),
    Range(Expr, Expr),
}

#[derive(Debug, Clone, PartialEq)]
pub struct ReturnStmt {
    pub value: Option<Expr>,
    pub values: Option<Vec<Expr>>,
}

// ---------------------------------------------------------------------------
// Expression statement / virtual expr
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, PartialEq)]
pub struct ExprStmt {
    pub expr: Expr,
    pub alias: Option<String>,
}

#[derive(Debug, Clone, PartialEq)]
pub struct VirtualExprStmt {
    pub expr: Expr,
    pub alias: Option<String>,
}

// ---------------------------------------------------------------------------
// Container / Use / Package
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, PartialEq)]
pub struct ContainerDef {
    pub name: String,
    pub alias: Option<String>,
    pub body: Option<Vec<Statement>>,
}

#[derive(Debug, Clone, PartialEq)]
pub struct UseDef {
    pub name: String,
    pub alias: Option<String>,
}

#[derive(Debug, Clone, PartialEq)]
pub struct PackageDef {
    pub name: String,
    pub body: Vec<Statement>,
}

// ---------------------------------------------------------------------------
// Deferred call
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, PartialEq)]
pub struct DeferredCall {
    pub event: String,
    pub priority: Option<Expr>,
    pub scope: String,
    pub function: NameRef,
    pub args: Vec<CallArg>,
}

// ---------------------------------------------------------------------------
// Hint
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, PartialEq)]
pub struct HintStmt {
    pub name: String,
    pub data: HintData,
}

#[derive(Debug, Clone, PartialEq)]
pub enum HintData {
    Expr(Expr),
    Object(Vec<(String, Expr)>),
    Array(Vec<Expr>),
}

// ---------------------------------------------------------------------------
// When
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, PartialEq)]
pub struct WhenStmt {
    pub condition: WhenCondition,
    pub body: Vec<Statement>,
}

#[derive(Debug, Clone, PartialEq)]
pub enum WhenCondition {
    Expr(Expr),
    Boundary(String),
}

// ---------------------------------------------------------------------------
// Expressions
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, PartialEq)]
pub enum Expr {
    /// Integer literal
    Number(NumericLiteral),

    /// String literal
    StringLit(StringLiteral),

    /// Template string (backtick)
    TemplateString(String),

    /// Reference to a name: `foo`, `a.b.c`, `air.x`
    Reference(NameId),

    /// Binary operation: `a + b`, `a * b`, etc.
    BinaryOp {
        op: BinOp,
        left: Box<Expr>,
        right: Box<Expr>,
    },

    /// Unary operation: `-x`, `!x`
    UnaryOp {
        op: UnaryOp,
        operand: Box<Expr>,
    },

    /// Ternary: `cond ? then : else`
    Ternary {
        condition: Box<Expr>,
        then_expr: Box<Expr>,
        else_expr: Box<Expr>,
    },

    /// Function/template call: `func(args)`
    FunctionCall(FunctionCall),

    /// Array/index access: `a[i]`
    ArrayIndex {
        base: Box<Expr>,
        index: Box<Expr>,
    },

    /// Member access: `a.b`
    MemberAccess {
        base: Box<Expr>,
        member: String,
    },

    /// Row offset: `a'`, `a'2`
    RowOffset {
        base: Box<Expr>,
        offset: Box<Expr>,
    },

    /// Cast: `int(x)`, `fe(x)`, `expr(x)`
    Cast {
        cast_type: String,
        dim: u32,
        value: Box<Expr>,
    },

    /// Array/expression list literal: `[a, b, c]`
    ArrayLiteral(Vec<Expr>),

    /// Spread: `...expr`
    Spread(Box<Expr>),

    /// Positional parameter: `$0`, `$1`, etc.
    PositionalParam(u64),

    /// Sequence definition (fixed column initializer)
    Sequence(SequenceDef),
}

// ---------------------------------------------------------------------------
// Numeric / string literals
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, PartialEq)]
pub struct NumericLiteral {
    pub value: String,
    pub radix: NumericRadix,
}

#[derive(Debug, Clone, PartialEq)]
pub enum NumericRadix {
    Decimal,
    Hex,
    Binary,
}

#[derive(Debug, Clone, PartialEq)]
pub struct StringLiteral {
    pub value: String,
    pub is_template: bool,
}

// ---------------------------------------------------------------------------
// Name references (dotted paths with optional indices and row offset)
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, PartialEq)]
pub struct NameRef {
    pub path: String,
    pub indexes: Vec<Expr>,
}

/// A fully resolved name with optional array indices and row offset.
#[derive(Debug, Clone, PartialEq)]
pub struct NameId {
    pub path: String,
    pub indexes: Vec<Expr>,
    pub row_offset: Option<Box<Expr>>,
}

// ---------------------------------------------------------------------------
// Function call
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, PartialEq)]
pub struct FunctionCall {
    pub function: NameRef,
    pub args: Vec<CallArg>,
}

/// A call argument can be positional or named (`name: value`).
#[derive(Debug, Clone, PartialEq)]
pub struct CallArg {
    pub name: Option<String>,
    pub value: Expr,
}

// ---------------------------------------------------------------------------
// Binary / unary operators
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, PartialEq)]
pub enum BinOp {
    Add,
    Sub,
    Mul,
    Div,
    IntDiv,
    Mod,
    Pow,
    Eq,
    Ne,
    Lt,
    Gt,
    Le,
    Ge,
    And,
    Or,
    BitAnd,
    BitOr,
    BitXor,
    Shl,
    Shr,
    In,
}

#[derive(Debug, Clone, PartialEq)]
pub enum UnaryOp {
    Neg,
    Not,
}

// ---------------------------------------------------------------------------
// Sequence definition (for fixed column initialization)
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, PartialEq)]
pub struct SequenceDef {
    pub elements: Vec<SequenceElement>,
    pub is_padded: bool,
}

#[derive(Debug, Clone, PartialEq)]
pub enum SequenceElement {
    Value(Expr),
    Repeat { value: Expr, times: Expr },
    Range { from: Expr, to: Expr, from_times: Option<Expr>, to_times: Option<Expr> },
    ArithSeq { t1: Box<SequenceElement>, t2: Box<SequenceElement>, tn: Option<Box<SequenceElement>> },
    GeomSeq { t1: Box<SequenceElement>, t2: Box<SequenceElement>, tn: Option<Box<SequenceElement>> },
    Padding(Box<SequenceElement>),
    SubSeq(Vec<SequenceElement>),
}
