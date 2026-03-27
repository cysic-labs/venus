/// Hand-written lexer for PIL2 that produces tokens consumed by the LALRPOP
/// grammar.  The lexer is implemented as an iterator of `(usize, Token, usize)`
/// triples (start-position, token, end-position) which is the format LALRPOP
/// expects from an external lexer.

use std::fmt;

// ---------------------------------------------------------------------------
// Token
// ---------------------------------------------------------------------------

#[derive(Clone, Debug, PartialEq)]
pub enum Token {
    // -- keywords --
    Col,
    Witness,
    Fixed,
    Container,
    Declare,
    Use,
    Alias,
    Include,
    Require,
    In,
    Is,
    PublicTable,
    Public,
    Constant,
    Const,
    ProofValue,
    AirGroupValue,
    AirValue,
    AirGroup,
    AirTemplate,
    Air,
    Proof,
    Commit,
    Package,
    Virtual,
    Int,
    Fe,
    Expr,
    TString,
    Challenge,
    For,
    While,
    Do,
    Break,
    Continue,
    If,
    ElseIf,
    Else,
    Switch,
    Case,
    Default,
    When,
    Aggregate,
    Stage,
    On,
    Private,
    Final,
    Function,
    Return,

    // -- literals --
    /// Decimal or hex integer (stored as string, underscores already stripped)
    Number(String),
    /// Double-quoted string content (without quotes)
    StringLit(String),
    /// Backtick template string content (without backticks)
    TemplateLit(String),

    // -- identifiers --
    Identifier(String),
    /// `@hint_name` (without the `@`)
    Hint(String),
    /// `$0`, `$1` ... (stores the number)
    PositionalParam(String),

    // -- pragma --
    /// `#pragma ...` (stores the content after `#pragma\s+`)
    Pragma(String),

    // -- operators --
    Plus,
    Minus,
    Star,
    Slash,
    Backslash,
    Percent,
    Pow,         // **
    Inc,         // ++
    Dec,         // --
    PlusAssign,  // +=
    MinusAssign, // -=
    StarAssign,  // *=
    TripleEq,    // ===
    ArrowLeft,   // <==
    EqEq,        // ==
    Ne,          // !=
    Le,          // <=
    Ge,          // >=
    Lt,          // <
    Gt,          // >
    Shl,         // <<
    Shr,         // >>
    And,         // &&
    Or,          // ||
    BitAnd,      // &
    BitOr,       // |
    BitXor,      // ^
    Not,         // !
    Eq,          // =

    // -- delimiters --
    LParen,
    RParen,
    LBracket,
    RBracket,
    LBrace,
    RBrace,
    Semicolon,
    Comma,
    Dot,
    Colon,
    ColonColon,  // ::
    Apostrophe,  // '
    Question,    // ?

    // -- dots --
    DotsFill,     // ...
    DotsRange,    // ..
    DotsArithSeq, // ..+..
    DotsGeomSeq,  // ..*..
}

impl fmt::Display for Token {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Token::Col => write!(f, "col"),
            Token::Witness => write!(f, "witness"),
            Token::Fixed => write!(f, "fixed"),
            Token::Container => write!(f, "container"),
            Token::Declare => write!(f, "declare"),
            Token::Use => write!(f, "use"),
            Token::Alias => write!(f, "alias"),
            Token::Include => write!(f, "include"),
            Token::Require => write!(f, "require"),
            Token::In => write!(f, "in"),
            Token::Is => write!(f, "is"),
            Token::PublicTable => write!(f, "publictable"),
            Token::Public => write!(f, "public"),
            Token::Constant => write!(f, "constant"),
            Token::Const => write!(f, "const"),
            Token::ProofValue => write!(f, "proofval"),
            Token::AirGroupValue => write!(f, "airgroupval"),
            Token::AirValue => write!(f, "airval"),
            Token::AirGroup => write!(f, "airgroup"),
            Token::AirTemplate => write!(f, "airtemplate"),
            Token::Air => write!(f, "air"),
            Token::Proof => write!(f, "proof"),
            Token::Commit => write!(f, "commit"),
            Token::Package => write!(f, "package"),
            Token::Virtual => write!(f, "virtual"),
            Token::Int => write!(f, "int"),
            Token::Fe => write!(f, "fe"),
            Token::Expr => write!(f, "expr"),
            Token::TString => write!(f, "string"),
            Token::Challenge => write!(f, "challenge"),
            Token::For => write!(f, "for"),
            Token::While => write!(f, "while"),
            Token::Do => write!(f, "do"),
            Token::Break => write!(f, "break"),
            Token::Continue => write!(f, "continue"),
            Token::If => write!(f, "if"),
            Token::ElseIf => write!(f, "elseif"),
            Token::Else => write!(f, "else"),
            Token::Switch => write!(f, "switch"),
            Token::Case => write!(f, "case"),
            Token::Default => write!(f, "default"),
            Token::When => write!(f, "when"),
            Token::Aggregate => write!(f, "aggregate"),
            Token::Stage => write!(f, "stage"),
            Token::On => write!(f, "on"),
            Token::Private => write!(f, "private"),
            Token::Final => write!(f, "final"),
            Token::Function => write!(f, "function"),
            Token::Return => write!(f, "return"),
            Token::Number(n) => write!(f, "{}", n),
            Token::StringLit(s) => write!(f, "\"{}\"", s),
            Token::TemplateLit(s) => write!(f, "`{}`", s),
            Token::Identifier(s) => write!(f, "{}", s),
            Token::Hint(s) => write!(f, "@{}", s),
            Token::PositionalParam(s) => write!(f, "${}", s),
            Token::Pragma(s) => write!(f, "#pragma {}", s),
            Token::Plus => write!(f, "+"),
            Token::Minus => write!(f, "-"),
            Token::Star => write!(f, "*"),
            Token::Slash => write!(f, "/"),
            Token::Backslash => write!(f, "\\"),
            Token::Percent => write!(f, "%"),
            Token::Pow => write!(f, "**"),
            Token::Inc => write!(f, "++"),
            Token::Dec => write!(f, "--"),
            Token::PlusAssign => write!(f, "+="),
            Token::MinusAssign => write!(f, "-="),
            Token::StarAssign => write!(f, "*="),
            Token::TripleEq => write!(f, "==="),
            Token::ArrowLeft => write!(f, "<=="),
            Token::EqEq => write!(f, "=="),
            Token::Ne => write!(f, "!="),
            Token::Le => write!(f, "<="),
            Token::Ge => write!(f, ">="),
            Token::Lt => write!(f, "<"),
            Token::Gt => write!(f, ">"),
            Token::Shl => write!(f, "<<"),
            Token::Shr => write!(f, ">>"),
            Token::And => write!(f, "&&"),
            Token::Or => write!(f, "||"),
            Token::BitAnd => write!(f, "&"),
            Token::BitOr => write!(f, "|"),
            Token::BitXor => write!(f, "^"),
            Token::Not => write!(f, "!"),
            Token::Eq => write!(f, "="),
            Token::LParen => write!(f, "("),
            Token::RParen => write!(f, ")"),
            Token::LBracket => write!(f, "["),
            Token::RBracket => write!(f, "]"),
            Token::LBrace => write!(f, "{{"),
            Token::RBrace => write!(f, "}}"),
            Token::Semicolon => write!(f, ";"),
            Token::Comma => write!(f, ","),
            Token::Dot => write!(f, "."),
            Token::Colon => write!(f, ":"),
            Token::ColonColon => write!(f, "::"),
            Token::Apostrophe => write!(f, "'"),
            Token::Question => write!(f, "?"),
            Token::DotsFill => write!(f, "..."),
            Token::DotsRange => write!(f, ".."),
            Token::DotsArithSeq => write!(f, "..+.."),
            Token::DotsGeomSeq => write!(f, "..*.."),
        }
    }
}

// ---------------------------------------------------------------------------
// Lexer error
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, PartialEq)]
pub struct LexError {
    pub position: usize,
    pub message: String,
}

impl fmt::Display for LexError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "lex error at position {}: {}", self.position, self.message)
    }
}

impl std::error::Error for LexError {}

// ---------------------------------------------------------------------------
// Lexer
// ---------------------------------------------------------------------------

pub struct Lexer<'input> {
    input: &'input str,
    chars: Vec<(usize, char)>,
    pos: usize,
}

impl<'input> Lexer<'input> {
    pub fn new(input: &'input str) -> Self {
        let chars: Vec<(usize, char)> = input.char_indices().collect();
        Self { input, chars, pos: 0 }
    }

    fn peek_char(&self) -> Option<(usize, char)> {
        self.chars.get(self.pos).copied()
    }

    fn advance(&mut self) -> Option<(usize, char)> {
        let result = self.chars.get(self.pos).copied();
        if result.is_some() {
            self.pos += 1;
        }
        result
    }

    fn peek_char_at(&self, offset: usize) -> Option<char> {
        self.chars.get(self.pos + offset).map(|&(_, c)| c)
    }

    fn byte_pos(&self) -> usize {
        self.chars.get(self.pos).map(|&(i, _)| i).unwrap_or(self.input.len())
    }

    fn skip_whitespace_and_comments(&mut self) {
        loop {
            // skip whitespace
            while let Some((_, c)) = self.peek_char() {
                if c.is_whitespace() {
                    self.advance();
                } else {
                    break;
                }
            }

            // check for comments
            if let (Some(c1), Some(c2)) = (self.peek_char_at(0), self.peek_char_at(1)) {
                if c1 == '/' && c2 == '/' {
                    // single-line comment: skip to end of line
                    while let Some((_, c)) = self.advance() {
                        if c == '\n' {
                            break;
                        }
                    }
                    continue;
                }
                if c1 == '/' && c2 == '*' {
                    // multi-line comment: skip to */
                    self.advance(); // consume /
                    self.advance(); // consume *
                    let mut depth = 1;
                    while depth > 0 {
                        match self.advance() {
                            Some((_, '*')) => {
                                if let Some((_, '/')) = self.peek_char() {
                                    self.advance();
                                    depth -= 1;
                                }
                            }
                            None => break,
                            _ => {}
                        }
                    }
                    continue;
                }
            }

            break;
        }
    }

    fn read_identifier_or_keyword(&mut self, start_byte: usize) -> (usize, Token, usize) {
        while let Some((_, c)) = self.peek_char() {
            if c.is_alphanumeric() || c == '_' || c == '$' {
                self.advance();
            } else {
                break;
            }
        }
        let end = self.byte_pos();
        let word = &self.input[start_byte..end];
        let tok = match word {
            "col" => Token::Col,
            "witness" => Token::Witness,
            "fixed" => Token::Fixed,
            "container" => Token::Container,
            "declare" => Token::Declare,
            "use" => Token::Use,
            "alias" => Token::Alias,
            "include" => Token::Include,
            "require" => Token::Require,
            "in" => Token::In,
            "is" => Token::Is,
            "publictable" => Token::PublicTable,
            "public" => Token::Public,
            "constant" => Token::Constant,
            "const" => Token::Const,
            "proofval" => Token::ProofValue,
            "airgroupval" => Token::AirGroupValue,
            "airval" => Token::AirValue,
            "airgroup" => Token::AirGroup,
            "airtemplate" => Token::AirTemplate,
            "air" => Token::Air,
            "proof" => Token::Proof,
            "commit" => Token::Commit,
            "package" => Token::Package,
            "virtual" => Token::Virtual,
            "int" => Token::Int,
            "fe" => Token::Fe,
            "expr" => Token::Expr,
            "string" => Token::TString,
            "challenge" => Token::Challenge,
            "for" => Token::For,
            "while" => Token::While,
            "do" => Token::Do,
            "break" => Token::Break,
            "continue" => Token::Continue,
            "if" => Token::If,
            "elseif" => Token::ElseIf,
            "else" => Token::Else,
            "switch" => Token::Switch,
            "case" => Token::Case,
            "default" => Token::Default,
            "when" => Token::When,
            "aggregate" => Token::Aggregate,
            "stage" => Token::Stage,
            "on" => Token::On,
            "private" => Token::Private,
            "final" => Token::Final,
            "function" => Token::Function,
            "return" => Token::Return,
            _ => Token::Identifier(word.to_string()),
        };
        (start_byte, tok, end)
    }

    fn read_number(&mut self, start_byte: usize) -> (usize, Token, usize) {
        // Check for 0x prefix
        let first = self.input.as_bytes().get(start_byte).copied().unwrap_or(b'0');
        if first == b'0' {
            if let Some(next) = self.peek_char_at(0) {
                if next == 'x' || next == 'X' {
                    self.advance(); // consume 'x'
                    while let Some((_, c)) = self.peek_char() {
                        if c.is_ascii_hexdigit() || c == '_' {
                            self.advance();
                        } else {
                            break;
                        }
                    }
                    let end = self.byte_pos();
                    let raw = &self.input[start_byte..end];
                    let cleaned = raw.replace('_', "");
                    return (start_byte, Token::Number(cleaned), end);
                }
                if next == 'b' || next == 'B' {
                    self.advance(); // consume 'b'
                    while let Some((_, c)) = self.peek_char() {
                        if c == '0' || c == '1' || c == '_' {
                            self.advance();
                        } else {
                            break;
                        }
                    }
                    let end = self.byte_pos();
                    let raw = &self.input[start_byte..end];
                    let cleaned = raw.replace('_', "");
                    return (start_byte, Token::Number(cleaned), end);
                }
            }
        }
        // decimal
        while let Some((_, c)) = self.peek_char() {
            if c.is_ascii_digit() || c == '_' {
                self.advance();
            } else {
                break;
            }
        }
        let end = self.byte_pos();
        let raw = &self.input[start_byte..end];
        let cleaned = raw.replace('_', "");
        (start_byte, Token::Number(cleaned), end)
    }

    fn read_string(&mut self, quote: char) -> Result<(usize, Token, usize), LexError> {
        let start = self.byte_pos() - 1; // we already consumed the opening quote
        let mut content = String::new();
        loop {
            match self.advance() {
                Some((_, c)) if c == quote => {
                    let end = self.byte_pos();
                    let tok = if quote == '"' {
                        Token::StringLit(content)
                    } else {
                        Token::TemplateLit(content)
                    };
                    return Ok((start, tok, end));
                }
                Some((_, c)) => {
                    content.push(c);
                }
                None => {
                    return Err(LexError {
                        position: start,
                        message: "unterminated string literal".to_string(),
                    });
                }
            }
        }
    }

    fn read_pragma(&mut self, start_byte: usize) -> (usize, Token, usize) {
        // We've already matched `#pragma`, now skip whitespace and grab to end of line
        while let Some((_, c)) = self.peek_char() {
            if c == ' ' || c == '\t' {
                self.advance();
            } else {
                break;
            }
        }
        let content_start = self.byte_pos();
        while let Some((_, c)) = self.peek_char() {
            if c == '\n' || c == '\r' {
                break;
            }
            self.advance();
        }
        let end = self.byte_pos();
        let content = self.input[content_start..end].trim().to_string();
        (start_byte, Token::Pragma(content), end)
    }

    fn next_token(&mut self) -> Option<Result<(usize, Token, usize), LexError>> {
        self.skip_whitespace_and_comments();

        let (byte_off, ch) = self.peek_char()?;
        let start = byte_off;

        // pragma: `#pragma`
        if ch == '#' {
            let remaining = &self.input[start..];
            if remaining.starts_with("#pragma") {
                // consume `#pragma`
                for _ in 0..7 {
                    self.advance();
                }
                return Some(Ok(self.read_pragma(start)));
            }
        }

        // identifiers and keywords
        if ch.is_alphabetic() || ch == '_' {
            self.advance(); // consume the first char
            return Some(Ok(self.read_identifier_or_keyword(start)));
        }

        // hint: @identifier
        if ch == '@' {
            self.advance(); // consume @
            let hint_start = self.byte_pos();
            while let Some((_, c)) = self.peek_char() {
                if c.is_alphanumeric() || c == '_' {
                    self.advance();
                } else {
                    break;
                }
            }
            let end = self.byte_pos();
            let name = self.input[hint_start..end].to_string();
            return Some(Ok((start, Token::Hint(name), end)));
        }

        // positional param: $N
        if ch == '$' {
            self.advance(); // consume $
            let num_start = self.byte_pos();
            while let Some((_, c)) = self.peek_char() {
                if c.is_ascii_digit() {
                    self.advance();
                } else {
                    break;
                }
            }
            let end = self.byte_pos();
            let num = self.input[num_start..end].to_string();
            return Some(Ok((start, Token::PositionalParam(num), end)));
        }

        // numbers
        if ch.is_ascii_digit() {
            self.advance(); // consume first digit
            return Some(Ok(self.read_number(start)));
        }

        // strings
        if ch == '"' {
            self.advance();
            return Some(self.read_string('"'));
        }
        if ch == '`' {
            self.advance();
            return Some(self.read_string('`'));
        }

        // multi-char operators and dots
        // Must check longest match first

        // ..+.. and ..*..
        if ch == '.' {
            // look ahead for dot sequences
            let c1 = self.peek_char_at(1);
            let c2 = self.peek_char_at(2);
            let c3 = self.peek_char_at(3);
            let c4 = self.peek_char_at(4);

            // ..+..
            if c1 == Some('.') && c2 == Some('+') && c3 == Some('.') && c4 == Some('.') {
                for _ in 0..5 { self.advance(); }
                return Some(Ok((start, Token::DotsArithSeq, start + 5)));
            }
            // ..*..
            if c1 == Some('.') && c2 == Some('*') && c3 == Some('.') && c4 == Some('.') {
                for _ in 0..5 { self.advance(); }
                return Some(Ok((start, Token::DotsGeomSeq, start + 5)));
            }
            // ...
            if c1 == Some('.') && c2 == Some('.') {
                for _ in 0..3 { self.advance(); }
                return Some(Ok((start, Token::DotsFill, start + 3)));
            }
            // ..
            if c1 == Some('.') {
                for _ in 0..2 { self.advance(); }
                return Some(Ok((start, Token::DotsRange, start + 2)));
            }
            // single dot
            self.advance();
            return Some(Ok((start, Token::Dot, start + 1)));
        }

        // ===
        if ch == '=' {
            let c1 = self.peek_char_at(1);
            let c2 = self.peek_char_at(2);
            if c1 == Some('=') && c2 == Some('=') {
                for _ in 0..3 { self.advance(); }
                return Some(Ok((start, Token::TripleEq, start + 3)));
            }
            if c1 == Some('=') {
                for _ in 0..2 { self.advance(); }
                return Some(Ok((start, Token::EqEq, start + 2)));
            }
            self.advance();
            return Some(Ok((start, Token::Eq, start + 1)));
        }

        // <==, <<, <=, <
        if ch == '<' {
            let c1 = self.peek_char_at(1);
            let c2 = self.peek_char_at(2);
            if c1 == Some('=') && c2 == Some('=') {
                for _ in 0..3 { self.advance(); }
                return Some(Ok((start, Token::ArrowLeft, start + 3)));
            }
            if c1 == Some('<') {
                for _ in 0..2 { self.advance(); }
                return Some(Ok((start, Token::Shl, start + 2)));
            }
            if c1 == Some('=') {
                for _ in 0..2 { self.advance(); }
                return Some(Ok((start, Token::Le, start + 2)));
            }
            self.advance();
            return Some(Ok((start, Token::Lt, start + 1)));
        }

        // >>, >=, >
        if ch == '>' {
            let c1 = self.peek_char_at(1);
            if c1 == Some('>') {
                for _ in 0..2 { self.advance(); }
                return Some(Ok((start, Token::Shr, start + 2)));
            }
            if c1 == Some('=') {
                for _ in 0..2 { self.advance(); }
                return Some(Ok((start, Token::Ge, start + 2)));
            }
            self.advance();
            return Some(Ok((start, Token::Gt, start + 1)));
        }

        // **, +=, +, ++
        if ch == '+' {
            let c1 = self.peek_char_at(1);
            if c1 == Some('+') {
                for _ in 0..2 { self.advance(); }
                return Some(Ok((start, Token::Inc, start + 2)));
            }
            if c1 == Some('=') {
                for _ in 0..2 { self.advance(); }
                return Some(Ok((start, Token::PlusAssign, start + 2)));
            }
            self.advance();
            return Some(Ok((start, Token::Plus, start + 1)));
        }

        // --, -=, -
        if ch == '-' {
            let c1 = self.peek_char_at(1);
            if c1 == Some('-') {
                for _ in 0..2 { self.advance(); }
                return Some(Ok((start, Token::Dec, start + 2)));
            }
            if c1 == Some('=') {
                for _ in 0..2 { self.advance(); }
                return Some(Ok((start, Token::MinusAssign, start + 2)));
            }
            self.advance();
            return Some(Ok((start, Token::Minus, start + 1)));
        }

        // **, *=, *
        if ch == '*' {
            let c1 = self.peek_char_at(1);
            if c1 == Some('*') {
                for _ in 0..2 { self.advance(); }
                return Some(Ok((start, Token::Pow, start + 2)));
            }
            if c1 == Some('=') {
                for _ in 0..2 { self.advance(); }
                return Some(Ok((start, Token::StarAssign, start + 2)));
            }
            self.advance();
            return Some(Ok((start, Token::Star, start + 1)));
        }

        // !=, !
        if ch == '!' {
            let c1 = self.peek_char_at(1);
            if c1 == Some('=') {
                for _ in 0..2 { self.advance(); }
                return Some(Ok((start, Token::Ne, start + 2)));
            }
            self.advance();
            return Some(Ok((start, Token::Not, start + 1)));
        }

        // &&, &
        if ch == '&' {
            let c1 = self.peek_char_at(1);
            if c1 == Some('&') {
                for _ in 0..2 { self.advance(); }
                return Some(Ok((start, Token::And, start + 2)));
            }
            self.advance();
            return Some(Ok((start, Token::BitAnd, start + 1)));
        }

        // ||, |
        if ch == '|' {
            let c1 = self.peek_char_at(1);
            if c1 == Some('|') {
                for _ in 0..2 { self.advance(); }
                return Some(Ok((start, Token::Or, start + 2)));
            }
            self.advance();
            return Some(Ok((start, Token::BitOr, start + 1)));
        }

        // ::, :
        if ch == ':' {
            let c1 = self.peek_char_at(1);
            if c1 == Some(':') {
                for _ in 0..2 { self.advance(); }
                return Some(Ok((start, Token::ColonColon, start + 2)));
            }
            self.advance();
            return Some(Ok((start, Token::Colon, start + 1)));
        }

        // single-char tokens
        self.advance();
        let tok = match ch {
            '/' => Token::Slash,
            '\\' => Token::Backslash,
            '%' => Token::Percent,
            '^' => Token::BitXor,
            '(' => Token::LParen,
            ')' => Token::RParen,
            '[' => Token::LBracket,
            ']' => Token::RBracket,
            '{' => Token::LBrace,
            '}' => Token::RBrace,
            ';' => Token::Semicolon,
            ',' => Token::Comma,
            '\'' => Token::Apostrophe,
            '?' => Token::Question,
            _ => {
                return Some(Err(LexError {
                    position: start,
                    message: format!("unexpected character '{}'", ch),
                }));
            }
        };
        Some(Ok((start, tok, start + ch.len_utf8())))
    }
}

impl<'input> Iterator for Lexer<'input> {
    type Item = Result<(usize, Token, usize), LexError>;

    fn next(&mut self) -> Option<Self::Item> {
        self.next_token()
    }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

#[cfg(test)]
mod tests {
    use super::*;

    fn lex_all(input: &str) -> Vec<Token> {
        Lexer::new(input)
            .map(|r| r.expect("lex error"))
            .map(|(_, tok, _)| tok)
            .collect()
    }

    #[test]
    fn test_keywords() {
        let tokens = lex_all("col witness fixed airgroup airtemplate");
        assert_eq!(
            tokens,
            vec![Token::Col, Token::Witness, Token::Fixed, Token::AirGroup, Token::AirTemplate]
        );
    }

    #[test]
    fn test_numbers() {
        let tokens = lex_all("42 0xFF 0xA0_B0 1_000");
        assert_eq!(
            tokens,
            vec![
                Token::Number("42".into()),
                Token::Number("0xFF".into()),
                Token::Number("0xA0B0".into()),
                Token::Number("1000".into()),
            ]
        );
    }

    #[test]
    fn test_operators() {
        let tokens = lex_all("=== == != <= >= << >> && || ** += -= *= <==");
        assert_eq!(
            tokens,
            vec![
                Token::TripleEq, Token::EqEq, Token::Ne, Token::Le, Token::Ge,
                Token::Shl, Token::Shr, Token::And, Token::Or, Token::Pow,
                Token::PlusAssign, Token::MinusAssign, Token::StarAssign, Token::ArrowLeft,
            ]
        );
    }

    #[test]
    fn test_dots() {
        let tokens = lex_all(".. ... ..+.. ..*.. .");
        assert_eq!(
            tokens,
            vec![Token::DotsRange, Token::DotsFill, Token::DotsArithSeq, Token::DotsGeomSeq, Token::Dot]
        );
    }

    #[test]
    fn test_strings() {
        let tokens = lex_all(r#""hello" `world`"#);
        assert_eq!(
            tokens,
            vec![Token::StringLit("hello".into()), Token::TemplateLit("world".into())]
        );
    }

    #[test]
    fn test_comments_skipped() {
        let tokens = lex_all("a // comment\nb /* block */ c");
        assert_eq!(
            tokens,
            vec![
                Token::Identifier("a".into()),
                Token::Identifier("b".into()),
                Token::Identifier("c".into()),
            ]
        );
    }

    #[test]
    fn test_hint_and_positional() {
        let tokens = lex_all("@myHint $3");
        assert_eq!(
            tokens,
            vec![Token::Hint("myHint".into()), Token::PositionalParam("3".into())]
        );
    }

    #[test]
    fn test_pragma() {
        let tokens = lex_all("#pragma arg -I pil\n");
        assert_eq!(tokens, vec![Token::Pragma("arg -I pil".into())]);
    }

    #[test]
    fn test_hex_with_underscore() {
        let tokens = lex_all("0xA000_0000");
        assert_eq!(tokens, vec![Token::Number("0xA0000000".into())]);
    }

    #[test]
    fn test_delimiters() {
        let tokens = lex_all("( ) [ ] { } ; , : :: ' ?");
        assert_eq!(
            tokens,
            vec![
                Token::LParen, Token::RParen, Token::LBracket, Token::RBracket,
                Token::LBrace, Token::RBrace, Token::Semicolon, Token::Comma,
                Token::Colon, Token::ColonColon, Token::Apostrophe, Token::Question,
            ]
        );
    }
}
