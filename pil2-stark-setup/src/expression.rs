/// Index into the expression arena
pub type ExprId = usize;

/// A single expression node in the arena.
/// Fields mirror the JS expression objects from pil2-proofman-js.
#[derive(Debug, Clone)]
pub struct Expression {
    pub op: String,
    pub values: Vec<ExprId>,
    pub id: Option<usize>,
    pub dim: usize,
    pub stage: usize,
    pub exp_deg: i64,
    pub row_offset: Option<i64>,
    pub rows_offsets: Vec<i64>,
    pub value: Option<String>,
    pub boundary_id: Option<usize>,
    pub boundary: Option<String>,
    pub opening: Option<usize>,
    pub commit_id: Option<usize>,
    pub stage_id: Option<usize>,
    pub airgroup_id: Option<usize>,
    pub im_pol: bool,
    pub pol_id: Option<usize>,
    pub keep: Option<bool>,
}

impl Default for Expression {
    fn default() -> Self {
        Self {
            op: String::new(),
            values: Vec::new(),
            id: None,
            dim: 1,
            stage: 0,
            exp_deg: 0,
            row_offset: None,
            rows_offsets: Vec::new(),
            value: None,
            boundary_id: None,
            boundary: None,
            opening: None,
            commit_id: None,
            stage_id: None,
            airgroup_id: None,
            im_pol: false,
            pol_id: None,
            keep: None,
        }
    }
}

/// Arena-based expression storage.
/// Expressions reference each other by ExprId (index).
#[derive(Debug, Default)]
pub struct ExpressionArena {
    pub exprs: Vec<Expression>,
}

impl ExpressionArena {
    pub fn new() -> Self {
        Self { exprs: Vec::new() }
    }

    pub fn push(&mut self, expr: Expression) -> ExprId {
        let id = self.exprs.len();
        self.exprs.push(expr);
        id
    }

    pub fn get(&self, id: ExprId) -> &Expression {
        &self.exprs[id]
    }

    pub fn get_mut(&mut self, id: ExprId) -> &mut Expression {
        &mut self.exprs[id]
    }

    pub fn len(&self) -> usize {
        self.exprs.len()
    }

    pub fn is_empty(&self) -> bool {
        self.exprs.is_empty()
    }
}
