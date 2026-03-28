//! Protobuf serialization for PIL compiler output.
//! Converts internal compiler state to PilOut protobuf message.
//!
//! Mirrors the JS `ProtoOut` class (pil2-compiler/src/proto_out.js).

use prost::Message;
use std::collections::HashMap;
use std::fs;
use std::io::Write;
use std::path::Path;

use crate::processor::expression::{ColRefKind, RuntimeExpr, RuntimeOp, RuntimeUnaryOp, Value};
use crate::processor::fixed_cols::FixedCols;
use crate::processor::ids::IdAllocator;
use crate::processor::references::{RefType, Reference};
use crate::processor::Processor;

/// Generated protobuf types from pilout.proto.
pub mod pilout_proto {
    include!(concat!(env!("OUT_DIR"), "/pilout.rs"));
}

/// Goldilocks prime: 2^64 - 2^32 + 1
const GOLDILOCKS_PRIME: u128 = 0xFFFFFFFF00000001;

// Symbol type constants matching the protobuf SymbolType enum.
const REF_TYPE_IM_COL: i32 = 0;
const REF_TYPE_FIXED_COL: i32 = 1;
const REF_TYPE_PERIODIC_COL: i32 = 2;
const REF_TYPE_WITNESS_COL: i32 = 3;
const REF_TYPE_PROOF_VALUE: i32 = 4;
const REF_TYPE_AIR_GROUP_VALUE: i32 = 5;
const REF_TYPE_PUBLIC_VALUE: i32 = 6;
const REF_TYPE_PUBLIC_TABLE: i32 = 7;
const REF_TYPE_CHALLENGE: i32 = 8;
const REF_TYPE_AIR_VALUE: i32 = 9;
const REF_TYPE_CUSTOM_COL: i32 = 10;

/// Convert a big integer value to variable-length big-endian bytes (matching
/// the JS `bint2buf` with variable-byte encoding).
fn bigint_to_bytes(value: i128) -> Vec<u8> {
    if value == 0 {
        return Vec::new();
    }
    // Reduce modulo Goldilocks prime to get a positive canonical representation.
    let v = if value < 0 {
        let neg = ((-value) as u128) % GOLDILOCKS_PRIME;
        if neg == 0 { 0u64 } else { (GOLDILOCKS_PRIME - neg) as u64 }
    } else {
        ((value as u128) % GOLDILOCKS_PRIME) as u64
    };
    if v == 0 {
        return Vec::new();
    }
    // Encode as big-endian, stripping leading zero bytes.
    let full = v.to_be_bytes();
    let first_nonzero = full.iter().position(|&b| b != 0).unwrap_or(full.len());
    full[first_nonzero..].to_vec()
}

/// Main serialization structure that builds the PilOut protobuf from the
/// processor's internal state.
pub struct ProtoOutBuilder<'a> {
    processor: &'a Processor,
    /// Maps internal witness column IDs to (stage, proto_index).
    witness_id_to_proto: Vec<(u32, u32)>,
    /// Maps internal fixed column IDs to (type='F'|'P', proto_index).
    fixed_id_to_proto: Vec<(char, u32)>,
    /// Maps internal custom column IDs to (stage, proto_index, commit_id).
    custom_id_to_proto: Vec<(u32, u32, u32)>,
    /// Maps internal air value IDs to (stage, proto_index, air_group_id, air_id).
    air_value_id_to_proto: Vec<(u32, u32, u32, u32)>,
}

impl<'a> ProtoOutBuilder<'a> {
    pub fn new(processor: &'a Processor) -> Self {
        Self {
            processor,
            witness_id_to_proto: Vec::new(),
            fixed_id_to_proto: Vec::new(),
            custom_id_to_proto: Vec::new(),
            air_value_id_to_proto: Vec::new(),
        }
    }

    /// Build the complete PilOut protobuf message from the processor state.
    pub fn build(&mut self) -> pilout_proto::PilOut {
        let name = if self.processor.config.name.is_empty() {
            None
        } else {
            Some(self.processor.config.name.clone())
        };

        let base_field = bigint_to_bytes(GOLDILOCKS_PRIME as i128);

        // Build air groups.
        let air_groups = self.build_air_groups();

        // Build num_challenges by stage.
        let num_challenges = self.build_stage_counts(&self.processor.challenges);

        // Build num_proof_values by stage.
        let num_proof_values = self.build_stage_counts(&self.processor.proof_values);

        // Number of public values.
        let num_public_values = self.processor.publics.len();

        // Build global expressions (flattened) and the index mapping.
        let (expressions, expr_id_map) = self.build_global_expressions();

        // Build global constraints using the remapped expression indices.
        let constraints = self.build_global_constraints(&expr_id_map);

        // Build symbols.
        let symbols = self.build_symbols();

        pilout_proto::PilOut {
            name,
            base_field,
            air_groups,
            num_challenges,
            num_proof_values,
            num_public_values,
            public_tables: Vec::new(),
            expressions,
            constraints,
            hints: Vec::new(),
            symbols,
        }
    }

    /// Build the air groups section.
    fn build_air_groups(&mut self) -> Vec<pilout_proto::AirGroup> {
        let mut result = Vec::new();
        for ag in self.processor.air_groups.iter() {
            let mut proto_ag = pilout_proto::AirGroup {
                name: Some(ag.name.clone()),
                air_group_values: Vec::new(),
                airs: Vec::new(),
            };

            // Build airs within this group.
            for air in &ag.airs {
                let proto_air = pilout_proto::Air {
                    name: Some(air.name.clone()),
                    num_rows: Some(air.rows as u32),
                    periodic_cols: Vec::new(),
                    fixed_cols: Vec::new(),
                    stage_widths: air.info.witness_cols.clone(),
                    expressions: Vec::new(),
                    constraints: Vec::new(),
                    air_values: Vec::new(),
                    aggregable: true,
                    custom_commits: Vec::new(),
                };
                proto_ag.airs.push(proto_air);
            }

            result.push(proto_ag);
        }
        result
    }

    /// Build num-per-stage counts from an IdAllocator (for challenges,
    /// proof values, etc.).
    fn build_stage_counts(&self, alloc: &IdAllocator) -> Vec<u32> {
        let mut by_stage: HashMap<u32, u32> = HashMap::new();
        for data in &alloc.datas {
            let stage = data.stage.unwrap_or(1);
            *by_stage.entry(stage).or_insert(0) += 1;
        }
        if by_stage.is_empty() {
            return Vec::new();
        }
        let max_stage = *by_stage.keys().max().unwrap();
        let mut result = vec![0u32; max_stage as usize];
        for (stage, count) in by_stage {
            if stage > 0 && (stage as usize) <= result.len() {
                result[(stage - 1) as usize] = count;
            }
        }
        result
    }

    /// Build global expressions from the processor's global constraints.
    ///
    /// Expression trees are flattened into a linear array: nested
    /// sub-expressions are emitted first and referenced by index from
    /// their parent expression via `GlobalOperand::Expression { idx }`.
    ///
    /// Returns (flattened_expressions, mapping) where mapping[i] is the
    /// flattened index of the original expression store entry i.
    fn build_global_expressions(
        &self,
    ) -> (Vec<pilout_proto::GlobalExpression>, Vec<u32>) {
        let mut result = Vec::new();
        let mut id_map = Vec::new();
        for expr in self.processor.global_constraints.all_expressions() {
            let idx = self.flatten_expr_to_global(expr, &mut result);
            id_map.push(idx);
        }
        (result, id_map)
    }

    /// Build global constraints, remapping expression indices to the
    /// flattened expression array.
    fn build_global_constraints(
        &self,
        expr_id_map: &[u32],
    ) -> Vec<pilout_proto::GlobalConstraint> {
        let mut result = Vec::new();
        for entry in self.processor.global_constraints.iter() {
            let mapped_idx = expr_id_map
                .get(entry.expr_id as usize)
                .copied()
                .unwrap_or(entry.expr_id);
            let gc = pilout_proto::GlobalConstraint {
                expression_idx: Some(pilout_proto::global_operand::Expression {
                    idx: mapped_idx,
                }),
                debug_line: Some(entry.source_ref.clone()),
            };
            result.push(gc);
        }
        result
    }

    /// Build the symbols table from the processor's reference store.
    fn build_symbols(&self) -> Vec<pilout_proto::Symbol> {
        let mut result = Vec::new();

        let symbol_types = [
            RefType::Public,
            RefType::ProofValue,
            RefType::Challenge,
            RefType::Fixed,
            RefType::Witness,
            RefType::CustomCol,
            RefType::AirGroupValue,
            RefType::AirValue,
            RefType::Intermediate,
        ];

        for (name, reference) in self.processor.references.iter_of_types(&symbol_types) {
            if let Some(sym) = self.reference_to_symbol(name, reference) {
                result.push(sym);
            }
        }

        result
    }

    /// Convert a reference to a protobuf Symbol.
    fn reference_to_symbol(&self, name: &str, reference: &Reference) -> Option<pilout_proto::Symbol> {
        let (sym_type, id, stage, air_group_id, air_id, commit_id) =
            match &reference.ref_type {
                RefType::Intermediate => (
                    REF_TYPE_IM_COL,
                    reference.id,
                    None,
                    None,
                    None,
                    None,
                ),
                RefType::Fixed => (
                    REF_TYPE_FIXED_COL,
                    reference.id,
                    Some(0u32),
                    None,
                    None,
                    None,
                ),
                RefType::Witness => (
                    REF_TYPE_WITNESS_COL,
                    reference.id,
                    None,
                    None,
                    None,
                    None,
                ),
                RefType::CustomCol => (
                    REF_TYPE_CUSTOM_COL,
                    reference.id,
                    None,
                    None,
                    None,
                    None,
                ),
                RefType::Public => (
                    REF_TYPE_PUBLIC_VALUE,
                    reference.id,
                    None,
                    None,
                    None,
                    None,
                ),
                RefType::Challenge => (
                    REF_TYPE_CHALLENGE,
                    reference.id,
                    None,
                    None,
                    None,
                    None,
                ),
                RefType::ProofValue => (
                    REF_TYPE_PROOF_VALUE,
                    reference.id,
                    None,
                    None,
                    None,
                    None,
                ),
                RefType::AirGroupValue => (
                    REF_TYPE_AIR_GROUP_VALUE,
                    reference.id,
                    None,
                    None,
                    None,
                    None,
                ),
                RefType::AirValue => (
                    REF_TYPE_AIR_VALUE,
                    reference.id,
                    None,
                    None,
                    None,
                    None,
                ),
                _ => return None,
            };

        Some(pilout_proto::Symbol {
            name: name.to_string(),
            air_group_id,
            air_id,
            r#type: sym_type,
            id,
            stage,
            dim: reference.array_dims.len() as u32,
            lengths: reference.array_dims.clone(),
            commit_id,
            debug_line: Some(reference.source_ref.clone()),
        })
    }

    /// Flatten a RuntimeExpr tree into the global expressions array.
    ///
    /// Returns the index of the newly appended expression within `out`.
    /// Sub-expressions (nested BinOp / UnaryOp) are recursively
    /// flattened first so their indices are available as operands.
    fn flatten_expr_to_global(
        &self,
        expr: &RuntimeExpr,
        out: &mut Vec<pilout_proto::GlobalExpression>,
    ) -> u32 {
        let op = match expr {
            RuntimeExpr::BinOp { op, left, right } => {
                let lhs = self.flatten_operand_to_global(left, out);
                let rhs = self.flatten_operand_to_global(right, out);
                match op {
                    RuntimeOp::Add => {
                        pilout_proto::global_expression::Operation::Add(
                            pilout_proto::global_expression::Add { lhs, rhs },
                        )
                    }
                    RuntimeOp::Sub => {
                        pilout_proto::global_expression::Operation::Sub(
                            pilout_proto::global_expression::Sub { lhs, rhs },
                        )
                    }
                    RuntimeOp::Mul => {
                        pilout_proto::global_expression::Operation::Mul(
                            pilout_proto::global_expression::Mul { lhs, rhs },
                        )
                    }
                }
            }
            RuntimeExpr::UnaryOp { op, operand } => match op {
                RuntimeUnaryOp::Neg => {
                    let value = self.flatten_operand_to_global(operand, out);
                    pilout_proto::global_expression::Operation::Neg(
                        pilout_proto::global_expression::Neg { value },
                    )
                }
            },
            // Leaf nodes (Value, ColRef) are not top-level expressions on
            // their own; wrap them in a trivial Add(x, 0) so they still get
            // an expression slot.
            _ => {
                let leaf = self.leaf_to_global_operand(expr);
                let zero = Some(pilout_proto::GlobalOperand {
                    operand: Some(pilout_proto::global_operand::Operand::Constant(
                        pilout_proto::global_operand::Constant { value: Vec::new() },
                    )),
                });
                pilout_proto::global_expression::Operation::Add(
                    pilout_proto::global_expression::Add { lhs: leaf, rhs: zero },
                )
            }
        };

        let idx = out.len() as u32;
        out.push(pilout_proto::GlobalExpression {
            operation: Some(op),
        });
        idx
    }

    /// Convert a RuntimeExpr to a global operand, flattening nested
    /// sub-expressions into `out` and referencing them by index.
    fn flatten_operand_to_global(
        &self,
        expr: &RuntimeExpr,
        out: &mut Vec<pilout_proto::GlobalExpression>,
    ) -> Option<pilout_proto::GlobalOperand> {
        match expr {
            // Nested expression: flatten recursively and reference by index.
            RuntimeExpr::BinOp { .. } | RuntimeExpr::UnaryOp { .. } => {
                let idx = self.flatten_expr_to_global(expr, out);
                Some(pilout_proto::GlobalOperand {
                    operand: Some(pilout_proto::global_operand::Operand::Expression(
                        pilout_proto::global_operand::Expression { idx },
                    )),
                })
            }
            // Leaf: delegate to non-recursive conversion.
            _ => self.leaf_to_global_operand(expr),
        }
    }

    /// Convert a leaf RuntimeExpr (Value or ColRef) to a global operand.
    fn leaf_to_global_operand(
        &self,
        expr: &RuntimeExpr,
    ) -> Option<pilout_proto::GlobalOperand> {
        let operand = match expr {
            RuntimeExpr::Value(Value::Int(v)) => {
                pilout_proto::global_operand::Operand::Constant(
                    pilout_proto::global_operand::Constant {
                        value: bigint_to_bytes(*v),
                    },
                )
            }
            RuntimeExpr::Value(Value::Fe(v)) => {
                pilout_proto::global_operand::Operand::Constant(
                    pilout_proto::global_operand::Constant {
                        value: bigint_to_bytes(*v as i128),
                    },
                )
            }
            RuntimeExpr::ColRef { col_type, id, .. } => match col_type {
                ColRefKind::Challenge => {
                    pilout_proto::global_operand::Operand::Challenge(
                        pilout_proto::global_operand::Challenge {
                            stage: 0,
                            idx: *id,
                        },
                    )
                }
                ColRefKind::ProofValue => {
                    pilout_proto::global_operand::Operand::ProofValue(
                        pilout_proto::global_operand::ProofValue {
                            stage: 0,
                            idx: *id,
                        },
                    )
                }
                ColRefKind::AirGroupValue => {
                    pilout_proto::global_operand::Operand::AirGroupValue(
                        pilout_proto::global_operand::AirGroupValue {
                            air_group_id: 0,
                            idx: *id,
                        },
                    )
                }
                ColRefKind::Public => {
                    pilout_proto::global_operand::Operand::PublicValue(
                        pilout_proto::global_operand::PublicValue { idx: *id },
                    )
                }
                _ => return None,
            },
            // BinOp/UnaryOp should not reach here; handled by
            // flatten_operand_to_global above.
            _ => return None,
        };

        Some(pilout_proto::GlobalOperand {
            operand: Some(operand),
        })
    }
}

/// Serialize the processor state and write the .pilout file.
pub fn write_pilout(processor: &Processor, path: &str) -> anyhow::Result<()> {
    let mut builder = ProtoOutBuilder::new(processor);
    let pilout = builder.build();

    eprintln!(
        "  > Proto: {} air groups, {} symbols, {} global expressions, {} global constraints",
        pilout.air_groups.len(),
        pilout.symbols.len(),
        pilout.expressions.len(),
        pilout.constraints.len(),
    );

    let encoded = pilout.encode_to_vec();
    eprintln!("  > Proto encoded size: {} bytes", encoded.len());

    let parent = Path::new(path).parent();
    if let Some(dir) = parent {
        if !dir.exists() {
            fs::create_dir_all(dir)?;
        }
    }

    let mut file = fs::File::create(path)?;
    file.write_all(&encoded)?;
    eprintln!("  > Proto written to {}", path);

    Ok(())
}

/// Write fixed column data to a binary file.
/// Each column is written as a sequence of 8-byte little-endian u64 values.
pub fn write_fixed_cols_to_file(
    fixed_cols: &FixedCols,
    num_rows: u64,
    output_dir: &str,
    air_group_id: u32,
    air_id: u32,
) -> anyhow::Result<()> {
    let dir = Path::new(output_dir);
    if !dir.exists() {
        fs::create_dir_all(dir)?;
    }

    let filename = dir.join(format!("fixed_{}_{}.bin", air_group_id, air_id));
    let mut file = fs::File::create(&filename)?;

    let mut col_count = 0u32;
    let mut total_values = 0u64;

    for id in 0..fixed_cols.len() {
        // Skip temporal and external columns.
        if let Some(data) = fixed_cols.ids.get_data(id) {
            if data.temporal || data.external {
                continue;
            }
        }
        if let Some(row_data) = fixed_cols.get_row_data(id) {
            col_count += 1;
            for row in 0..num_rows as usize {
                let val = if row < row_data.len() {
                    // Reduce modulo Goldilocks to get a u64.
                    let v = row_data[row];
                    if v < 0 {
                        let neg = ((-v) as u128) % GOLDILOCKS_PRIME;
                        if neg == 0 { 0u64 } else { (GOLDILOCKS_PRIME - neg) as u64 }
                    } else {
                        ((v as u128) % GOLDILOCKS_PRIME) as u64
                    }
                } else {
                    0u64
                };
                file.write_all(&val.to_le_bytes())?;
                total_values += 1;
            }
        }
    }

    eprintln!(
        "  > Fixed cols written to {}: {} cols, {} values",
        filename.display(),
        col_count,
        total_values
    );

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use super::pilout_proto;

    #[test]
    fn test_proto_types_exist() {
        // Verify that key protobuf types are generated and accessible.
        let _pilout = pilout_proto::PilOut::default();
        let _air_group = pilout_proto::AirGroup::default();
        let _air = pilout_proto::Air::default();
        let _symbol = pilout_proto::Symbol::default();
        let _hint = pilout_proto::Hint::default();
    }

    #[test]
    fn test_bigint_to_bytes_zero() {
        let bytes = bigint_to_bytes(0);
        assert!(bytes.is_empty());
    }

    #[test]
    fn test_bigint_to_bytes_one() {
        let bytes = bigint_to_bytes(1);
        assert_eq!(bytes, vec![1]);
    }

    #[test]
    fn test_bigint_to_bytes_large() {
        let bytes = bigint_to_bytes(0xFFFFFFFF00000001);
        assert!(!bytes.is_empty());
    }
}
