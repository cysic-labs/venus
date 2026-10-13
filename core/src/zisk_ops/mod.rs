//! * Defines the operations that can be executed in Zisk as part of an instruction.
//! * The macro `define_ops` is used to define every operation, including its opcode, human-readable
//!   name, type, etc.
//! * The opcode operation functions are called `op_<opcode>`, they accept 2 input parameters a and
//!   b, and return 2 output results c and flag.
//! * The `opc_<opcode>` functions are wrappers over the `op_<opcode>` functions that accept an
//!   `InstContext` (instruction context) as input/output parameter, containg a, b, c and flag
//!   attributes.

#![allow(unused)]

mod arithmetic;
mod big_int;
mod bitwise;
mod comparison;
mod complex;
mod curves;
mod dma;
mod fcall;
mod hash;
mod precompiled;
mod system;

pub use arithmetic::*;
pub use big_int::*;
pub use bitwise::*;
pub use comparison::*;
pub use complex::*;
pub use curves::*;
pub use dma::*;
pub use fcall::*;
pub use hash::*;
pub use precompiled::*;
pub use system::*;

use paste::paste;
use std::{fmt::Display, str::FromStr};

use crate::{InstContext, ZiskOperationType, ZiskRequiredOperation};

/// Determines the type of a [`ZiskOp`].
///
/// The type will be used to assign the proof generation of a main state machine operation result to
/// the corresponding secondary state machine.
/// The type can be: internal (no proof required), arith, binary, etc.
#[derive(Copy, Clone, PartialEq, Eq, Debug)]
pub enum OpType {
    Internal,
    Arith,
    ArithA32,
    ArithAm32,
    Binary,
    BinaryE,
    Keccak,
    Sha256,
    Poseidon2,
    PubOut,
    ArithEq,
    Fcall,
    ArithEq384,
    BigInt,
    Dma,
    Blake2,
}

impl From<OpType> for ZiskOperationType {
    fn from(op_type: OpType) -> Self {
        match op_type {
            OpType::Internal => ZiskOperationType::Internal,
            OpType::Arith | OpType::ArithA32 | OpType::ArithAm32 => ZiskOperationType::Arith,
            OpType::Binary => ZiskOperationType::Binary,
            OpType::BinaryE => ZiskOperationType::BinaryE,
            OpType::Keccak => ZiskOperationType::Keccak,
            OpType::Sha256 => ZiskOperationType::Sha256,
            OpType::Poseidon2 => ZiskOperationType::Poseidon2,
            OpType::PubOut => ZiskOperationType::PubOut,
            OpType::ArithEq => ZiskOperationType::ArithEq,
            OpType::Fcall => ZiskOperationType::Fcall,
            OpType::ArithEq384 => ZiskOperationType::ArithEq384,
            OpType::BigInt => ZiskOperationType::BigInt,
            OpType::Dma => ZiskOperationType::Dma,
            OpType::Blake2 => ZiskOperationType::Blake2,
        }
    }
}

impl Display for OpType {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::Internal => write!(f, "i"),
            Self::Arith => write!(f, "a"),
            Self::ArithA32 => write!(f, "a32"),
            Self::ArithAm32 => write!(f, "am32"),
            Self::Binary => write!(f, "b"),
            Self::BinaryE => write!(f, "BinaryE"),
            Self::Keccak => write!(f, "Keccak"),
            Self::Sha256 => write!(f, "Sha256"),
            Self::Poseidon2 => write!(f, "Poseidon2"),
            Self::PubOut => write!(f, "PubOut"),
            Self::ArithEq => write!(f, "Arith256"),
            Self::Fcall => write!(f, "Fcall"),
            Self::ArithEq384 => write!(f, "Arith384"),
            Self::BigInt => write!(f, "BigInt"),
            Self::Dma => write!(f, "Dma"),
            Self::Blake2 => write!(f, "Blake2"),
        }
    }
}

impl FromStr for OpType {
    type Err = InvalidOpTypeError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s {
            "i" => Ok(Self::Internal),
            "a" => Ok(Self::Arith),
            "a32" => Ok(Self::ArithA32),
            "am32" => Ok(Self::ArithAm32),
            "b" => Ok(Self::Binary),
            "be" => Ok(Self::BinaryE),
            "k" => Ok(Self::Keccak),
            "s" => Ok(Self::Sha256),
            "p" => Ok(Self::Poseidon2),
            "aeq" => Ok(Self::ArithEq),
            "fcall" => Ok(Self::Fcall),
            "aeq384" => Ok(Self::ArithEq384),
            "bint" => Ok(Self::BigInt),
            "dma" => Ok(Self::Dma),
            "bl" => Ok(Self::Blake2),
            _ => Err(InvalidOpTypeError),
        }
    }
}

#[derive(Debug, Copy, Clone)]
pub struct InvalidOpTypeError;

impl Display for InvalidOpTypeError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "invalid operation type")
    }
}

#[derive(Copy, Clone, Debug)]
pub struct InvalidNameError;

impl Display for InvalidNameError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "invalid op name")
    }
}

#[derive(Copy, Clone, Debug)]
pub struct InvalidCodeError;

impl Display for InvalidCodeError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "invalid op code")
    }
}
/// Trait for gathering operation statistics
pub trait OpStats {
    fn mem_align_read(&mut self, addr: u64, count: usize);
    fn mem_align_write(&mut self, addr: u64, count: usize);
    fn add_extras(&mut self, extras: &[(u8, usize)]);
}

/// Stats gathering function that does nothing (used as default)
#[inline(always)]
pub fn ops_none(_ctx: &InstContext, _stats: &mut dyn OpStats) {
    // No-op implementation
}

#[inline(always)]
pub fn opc_virtual(ctx: &mut InstContext) {
    unimplemented!("opc_virtual: virtual operation")
}

#[inline(always)]
pub fn op_virtual(a: u64, b: u64) -> (u64, bool) {
    unimplemented!("op_virtual: virtual operation")
}

#[inline(always)]
pub fn ops_virtual(_ctx: &InstContext, _stats: &mut dyn OpStats) {
    unimplemented!("ops_virtual: virtual operation")
}

/// Internal macro used to define all ops in the [`ZiskOp`] enum
macro_rules! define_ops {
    ( $( ($name:ident, $str_name:expr, $type:ident, $steps:expr, $code:expr, $input_size:expr, $output_size:expr, $call_fn:ident, $call_ab_fn:ident, $call_stats_fn:ident ) ),* $(,)? ) => {
		/// Represents an operation that can be executed in Zisk.
		///
		/// All relevant metadata associated with the operation can be efficiently accessed via
		/// the const methods on this enum.
        #[derive(Copy, Clone, PartialEq, Eq, Debug, Hash, PartialOrd, Ord)]
        #[repr(u8)]
        pub enum ZiskOp {
            $(
                $name = $code,
            )*
        }

        impl ZiskOp {
            $(
                paste! {
                    pub const [<$str_name:upper>]: u8 = $code;
                }
            )*
			/// Returns the (string) name of the operation
            pub const fn name(&self) -> &'static str {
                match self {
                    $(
                        Self::$name => $str_name,
                    )*
                }
            }

			/// Returns the [`OpType`] of the operation
            pub const fn op_type(&self) -> OpType {
                match self {
                    $(
                        Self::$name => OpType::$type,
                    )*
                }
            }

			/// Returns the number of steps required to execute the operation
            pub const fn steps(&self) -> u64 {
                match self {
                    $(
                        Self::$name => $steps,
                    )*
                }
            }

			/// Returns the raw op code of the operation
            pub const fn code(&self) -> u8 {
                match self {
                    $(
                        Self::$name => $code,
                    )*
                }
            }

			/// Returns the input data size of the operation
            pub const fn input_size(&self) -> u64 {
                match self {
                    $(
                        Self::$name => $input_size,
                    )*
                }
            }

			/// Returns the input data size of the operation
            pub const fn output_size(&self) -> u64 {
                match self {
                    $(
                        Self::$name => $output_size,
                    )*
                }
            }

            /// Executes the operation on the given [`InstContext`]
			#[inline(always)]
            pub fn call(&self, ctx: &mut InstContext) {
                match self {
                    $(
                        Self::$name => $call_fn(ctx),
                    )*
                }
            }

            /// Returns the call function of the operation
            pub const fn get_call_function(&self) -> fn(&mut InstContext) -> () {
                match self {
                    $(
                        Self::$name => $call_fn,
                    )*
                }
            }

            /// Executes the operation to obtain extra stats on the given [`InstContext`]
            #[inline(always)]
            pub fn call_stats(&self, ctx: &InstContext, stats: &mut dyn OpStats) {
                match self {
                    $(
                        Self::$name => $call_stats_fn(ctx, stats),
                    )*
                }
            }

            /// Returns the call function for extra stats
            pub const fn get_call_stats_function(&self) -> fn(&InstContext, &mut dyn OpStats) -> () {
                match self {
                    $(
                        Self::$name => $call_stats_fn,
                    )*
                }
            }

			/// Executes the operation on the given inputs `a` and `b`
			#[inline(always)]
            pub fn call_ab(&self, a: u64, b: u64) -> (u64, bool) {
                match self {
                    $(
                        Self::$name => $call_ab_fn(a, b),
                    )*
                }
            }

			/// Attempts to create a [`ZiskOp`] from a string name, returning an error if the
			/// name is invalid
            pub fn try_from_name(st: &str) -> Result<ZiskOp, InvalidNameError> {
                match st {
                    $(
                        $str_name => Ok(Self::$name),
                    )*
                    _ => Err(InvalidNameError)
                }
            }

			/// Attempts to create a [`ZiskOp`] from a raw op code, returning an error if the
			/// code is invalid
            pub const fn try_from_code(code: u8) -> Result<ZiskOp, InvalidCodeError> {
                match code {
                    $(
                        $code => Ok(Self::$name),
                    )*
                    _ => Err(InvalidCodeError)
                }
            }

			/// Executes opcodes, only if it does not require instruction context (e.g. it does
			/// not have to access memory).
			///
			/// Panics if the opcode is invalid or does not support this operation.
			#[inline(always)]
			pub fn execute(code: u8, a: u64, b: u64) -> (u64, bool) {
				match code {
					$(
						$code => Self::$name.call_ab(a, b),
					)*
					_ => panic!("Invalid opcode: {}", code),
				}
			}
        }
    };
}

// Cost definitions: Area x Op
const INTERNAL_COST: u64 = 0;
const BINARY_COST: u64 = 60;
const BINARY_ADD_COST: u64 = 25;
const BINARY_E_COST: u64 = 53;
const ARITHA32_COST: u64 = 95;
const ARITHAM32_COST: u64 = 95;
const KECCAK_COST: u64 = 25 * 3022;
const SHA256_COST: u64 = 72 * 121;
const POSEIDON2_COST: u64 = 14 * 75;
const ARITH_EQ_COST: u64 = 89 * 16;
const FCALL_COST: u64 = INTERNAL_COST;
const ARITH_EQ_384_COST: u64 = 79 * 24;
const ADD256_COST: u64 = 104;
const DMA_COST: u64 = 42;
const BLAKE2_COST: u64 = 24 * 205;

const DMA_64_ALIGNED_COST: u64 = 40;
const DMA_UNALIGNED_COST: u64 = 42;
const DMA_PRE_POST_COST: u64 = 88;

// const OP_DMA_64_ALIGNED: u8 = 0xda;
// const OP_DMA_UNALIGNED: u8 = 0xdb;
// const OP_DMA_PRE: u8 = 0xdc;
// const OP_DMA_POST: u8 = 0xdd;
// const OP_DMA_CMP_BYTE: u8 = 0xde;

/// Table of Zisk opcode definitions: enum, name, type, cost, code and implementation functions
/// This table is the backbone of the Zisk processor, it determines what functionality is supported,
/// and what state machine is responsible of proving the execution of every opcode, based on its
/// type.
define_ops! {
    (Flag, "flag", Internal, INTERNAL_COST, 0x00, 0, 0, opc_flag, op_flag, ops_none),
    (CopyB, "copyb", Internal, INTERNAL_COST, 0x01, 0, 0, opc_copyb, op_copyb, ops_none),
    (Minu, "minu", Binary, BINARY_COST, 0x02, 0, 0, opc_minu, op_minu, ops_none),
    (Min, "min", Binary, BINARY_COST, 0x03, 0, 0, opc_min, op_min, ops_none),
    (Maxu, "maxu", Binary, BINARY_COST, 0x04, 0, 0, opc_maxu, op_maxu, ops_none),
    (Max, "max", Binary, BINARY_COST, 0x05, 0, 0, opc_max, op_max, ops_none),
    (Ltu, "ltu", Binary, BINARY_COST, 0x06, 0, 0, opc_ltu, op_ltu, ops_none),
    (Lt, "lt", Binary, BINARY_COST, 0x07, 0, 0, opc_lt, op_lt, ops_none),
    // Opcode 0x08 is reserved for binary
    (Eq, "eq", Binary, BINARY_COST, 0x09, 0, 0, opc_eq, op_eq, ops_none),
    (Add, "add", Binary, BINARY_ADD_COST, 0x0a, 0, 0, opc_add, op_add, ops_none),
    (Sub, "sub", Binary, BINARY_COST, 0x0b, 0, 0, opc_sub, op_sub, ops_none),
    (Leu, "leu", Binary, BINARY_COST, 0x0c, 0, 0, opc_leu, op_leu, ops_none),
    (Le, "le", Binary, BINARY_COST, 0x0d, 0, 0, opc_le, op_le, ops_none),
    (And, "and", Binary, BINARY_COST, 0x0e, 0, 0, opc_and, op_and, ops_none),
    (Or, "or", Binary, BINARY_COST, 0x0f, 0, 0, opc_or, op_or, ops_none),
    (Xor, "xor", Binary, BINARY_COST, 0x10, 0, 0, opc_xor, op_xor, ops_none),
    // Opcode 0x11 is available
    (MinuW, "minu_w", Binary, BINARY_COST, 0x12, 0, 0, opc_minu_w, op_minu_w, ops_none),
    (MinW, "min_w", Binary, BINARY_COST, 0x13, 0, 0, opc_min_w, op_min_w, ops_none),
    (MaxuW, "maxu_w", Binary, BINARY_COST, 0x14, 0, 0, opc_maxu_w, op_maxu_w, ops_none),
    (MaxW, "max_w", Binary, BINARY_COST, 0x15, 0, 0, opc_max_w, op_max_w, ops_none),
    (LtuW, "ltu_w", Binary, BINARY_COST, 0x16, 0, 0, opc_ltu_w, op_ltu_w, ops_none),
    (LtW, "lt_w", Binary, BINARY_COST, 0x17, 0, 0, opc_lt_w, op_lt_w, ops_none),
    // Opcode 0x18 is reserved for binary
    (EqW, "eq_w", Binary, BINARY_COST, 0x19, 0, 0, opc_eq_w, op_eq_w, ops_none),
    (AddW, "add_w", Binary, BINARY_COST, 0x1a, 0, 0, opc_add_w, op_add_w, ops_none),
    (SubW, "sub_w", Binary, BINARY_COST, 0x1b, 0, 0, opc_sub_w, op_sub_w, ops_none),
    (LeuW, "leu_w", Binary, BINARY_COST, 0x1c, 0, 0, opc_leu_w, op_leu_w, ops_none),
    (LeW, "le_w", Binary, BINARY_COST, 0x1d, 0, 0, opc_le_w, op_le_w, ops_none),
    // Opcodes 0x1e,0x1f,0x20 are reserved for binary
    (Sll, "sll", BinaryE, BINARY_E_COST, 0x21, 0, 0, opc_sll, op_sll, ops_none),
    (Srl, "srl", BinaryE, BINARY_E_COST, 0x22, 0, 0, opc_srl, op_srl, ops_none),
    (Sra, "sra", BinaryE, BINARY_E_COST, 0x23, 0, 0, opc_sra, op_sra, ops_none),
    (SllW, "sll_w", BinaryE, BINARY_E_COST, 0x24, 0, 0, opc_sll_w, op_sll_w, ops_none),
    (SrlW, "srl_w", BinaryE, BINARY_E_COST, 0x25, 0, 0, opc_srl_w, op_srl_w, ops_none),
    (SraW, "sra_w", BinaryE, BINARY_E_COST, 0x26, 0, 0, opc_sra_w, op_sra_w, ops_none),
    (SignExtendB, "signextend_b", BinaryE, BINARY_E_COST, 0x27, 0, 0, opc_signextend_b, op_signextend_b, ops_none),
    (SignExtendH, "signextend_h", BinaryE, BINARY_E_COST, 0x28, 0, 0, opc_signextend_h, op_signextend_h, ops_none),
    (SignExtendW, "signextend_w", BinaryE, BINARY_E_COST, 0x29, 0, 0, opc_signextend_w, op_signextend_w, ops_none),
    (PubOut, "pubout", PubOut, 0, 0x30, 0, 0, opc_pubout, op_pubout, ops_none),
    // Opcodes 0x50,0x51,0x60,0x61 are reserved for binary
    (Mulu, "mulu", ArithAm32, ARITHAM32_COST, 0xb0, 0, 0, opc_mulu, op_mulu, ops_none),
    (Muluh, "muluh", ArithAm32, ARITHAM32_COST, 0xb1, 0, 0, opc_muluh, op_muluh, ops_none),
    (Mulsuh, "mulsuh", ArithAm32, ARITHAM32_COST, 0xb3, 0, 0, opc_mulsuh, op_mulsuh, ops_none),
    (Mul, "mul", ArithAm32, ARITHAM32_COST, 0xb4, 0, 0, opc_mul, op_mul, ops_none),
    (Mulh, "mulh", ArithAm32, ARITHAM32_COST, 0xb5, 0, 0, opc_mulh, op_mulh, ops_none),
    (MulW, "mul_w", ArithAm32, ARITHAM32_COST, 0xb6, 0, 0, opc_mul_w, op_mul_w, ops_none),
    (Divu, "divu", ArithAm32, ARITHAM32_COST, 0xb8, 0, 0, opc_divu, op_divu, ops_none),
    (Remu, "remu", ArithAm32, ARITHAM32_COST, 0xb9, 0, 0, opc_remu, op_remu, ops_none),
    (Div, "div", ArithAm32, ARITHAM32_COST, 0xba, 0, 0, opc_div, op_div, ops_none),
    (Rem, "rem", ArithAm32, ARITHAM32_COST, 0xbb, 0, 0, opc_rem, op_rem, ops_none),
    (DivuW, "divu_w", ArithA32, ARITHA32_COST, 0xbc, 0, 0, opc_divu_w, op_divu_w, ops_none),
    (RemuW, "remu_w", ArithA32, ARITHA32_COST, 0xbd, 0, 0, opc_remu_w, op_remu_w, ops_none),
    (DivW, "div_w", ArithA32, ARITHA32_COST, 0xbe, 0, 0, opc_div_w, op_div_w, ops_none),
    (RemW, "rem_w", ArithA32, ARITHA32_COST, 0xbf, 0, 0, opc_rem_w, op_rem_w, ops_none),
    // opcpdes 0xc0-0xcf are available
    (DmaMemCpy, "dma_memcpy", Dma, DMA_COST, 0xd0, 8, 0, opc_dma_memcpy, op_dma_memcpy, ops_dma_memcpy),
    (DmaMemCmp, "dma_memcmp", Dma, DMA_COST, 0xd1, 16, 0, opc_dma_memcmp, op_dma_memcmp, ops_dma_memcmp),
    (DmaInputCpy, "dma_inputcpy", Dma, DMA_COST, 0xd2, 8, 0, opc_dma_inputcpy, op_dma_inputcpy, ops_dma_inputcpy),
    (DmaXMemCpy, "dma_xmemcpy", Dma, DMA_COST, 0xd6, 8, 0, opc_dma_xmemcpy, op_dma_xmemcpy, ops_dma_xmemcpy),
    (DmaXMemCmp, "dma_xmemcmp", Dma, DMA_COST, 0xd7, 16, 0, opc_dma_xmemcmp, op_dma_xmemcmp, ops_dma_xmemcmp),
    (DmaXMemSet, "dma_xmemset", Dma, DMA_COST, 0xd9, 8, 0, opc_dma_xmemset, op_dma_xmemset, ops_dma_xmemset),
    // opcodes 0xd2-0xd9 future reserved for dma operations (memset, memcpy256, memcmp256)
    (Dma64Aligned, "_dma_64_aligned", Dma, DMA_64_ALIGNED_COST, 0xda, 8, 0, opc_virtual, op_virtual, ops_virtual),
    (DmaUnaligned, "_dma_unaligned", Dma, DMA_UNALIGNED_COST, 0xdb, 8, 0, opc_virtual, op_virtual, ops_virtual),
    (DmaPre, "_dma_pre", Dma, DMA_PRE_POST_COST, 0xdc, 8, 0, opc_virtual, op_virtual, ops_virtual),
    (DmaPost, "_dma_post", Dma, DMA_PRE_POST_COST, 0xdd, 8, 0, opc_virtual, op_virtual, ops_virtual),
    // opcodes 0xda-0xdf reserved for dma extra operations (costs)
    // opcodes 0xe0 is available
    (Arith384Mod, "arith384_mod", ArithEq384, ARITH_EQ_384_COST, 0xe2, 232, 48, opc_arith384_mod, op_arith384_mod, ops_arith384_mod),
    (Bls12_381CurveAdd, "bls12_381_curve_add", ArithEq384, ARITH_EQ_384_COST, 0xe3, 208, 96, opc_bls12_381_curve_add, op_bls12_381_curve_add, ops_bls12_381_curve_add),
    (Bls12_381CurveDbl, "bls12_381_curve_dbl", ArithEq384, ARITH_EQ_384_COST, 0xe4, 96, 96, opc_bls12_381_curve_dbl, op_bls12_381_curve_dbl, ops_bls12_381_curve_dbl),
    (Bls12_381ComplexAdd, "bls12_381_complex_add", ArithEq384, ARITH_EQ_384_COST, 0xe5, 208, 96, opc_bls12_381_complex_add, op_bls12_381_complex_add, ops_bls12_381_complex_add),
    (Bls12_381ComplexSub, "bls12_381_complex_sub", ArithEq384, ARITH_EQ_384_COST, 0xe6, 208, 96, opc_bls12_381_complex_sub, op_bls12_381_complex_sub, ops_bls12_381_complex_sub),
    (Bls12_381ComplexMul, "bls12_381_complex_mul", ArithEq384, ARITH_EQ_384_COST, 0xe7, 208, 96, opc_bls12_381_complex_mul, op_bls12_381_complex_mul, ops_bls12_381_complex_mul),
    (Add256, "add256", BigInt, ADD256_COST, 0xf0, 104, 32, opc_add256, op_add256, ops_add256),
    (Keccak, "keccak", Keccak, KECCAK_COST, 0xf1, 200, 200, opc_keccak, op_keccak, ops_none),
    (Arith256, "arith256", ArithEq, ARITH_EQ_COST, 0xf2, 136, 64, opc_arith256, op_arith256, ops_arith256),
    (Arith256Mod, "arith256_mod", ArithEq, ARITH_EQ_COST, 0xf3, 168, 32, opc_arith256_mod, op_arith256_mod, ops_arith256_mod),
    (Secp256k1Add, "secp256k1_add", ArithEq, ARITH_EQ_COST, 0xf4, 144, 64, opc_secp256k1_add, op_secp256k1_add, ops_secp256k1_add),
    (Secp256k1Dbl, "secp256k1_dbl", ArithEq, ARITH_EQ_COST, 0xf5, 64, 64, opc_secp256k1_dbl, op_secp256k1_dbl, ops_secp256k1_dbl),
    (Secp256r1Add, "secp256r1_add", ArithEq, ARITH_EQ_COST, 0xe8, 144, 64, opc_secp256r1_add, op_secp256r1_add, ops_secp256r1_add),
    (Secp256r1Dbl, "secp256r1_dbl", ArithEq, ARITH_EQ_COST, 0xe9, 64, 64, opc_secp256r1_dbl, op_secp256r1_dbl, ops_secp256r1_dbl),
    (Blake2, "blake2", Blake2, BLAKE2_COST, 0xea, 280 , 128, opc_blake2, op_blake2, ops_blake2),
    (FcallParam, "fcall_param", Fcall, FCALL_COST, 0xf6, 0, 0, opc_fcall_param, op_fcall_param, ops_none),
    (Fcall, "fcall", Fcall, FCALL_COST, 0xf7, 0, 0, opc_fcall, op_fcall, ops_none),
    (FcallGet, "fcall_get", Fcall, FCALL_COST, 0xf8, 0, 0, opc_fcall_get, op_fcall_get, ops_none),
    (Sha256, "sha256", Sha256, SHA256_COST, 0xf9, 112, 112, opc_sha256, op_sha256, ops_sha256),
    (Poseidon2, "poseidon2", Poseidon2, POSEIDON2_COST, 0xe1, 128, 128, opc_poseidon2, op_poseidon2, ops_poseidon2),
    (Bn254CurveAdd, "bn254_curve_add", ArithEq, ARITH_EQ_COST, 0xfa, 144, 64, opc_bn254_curve_add, op_bn254_curve_add, ops_bn254_curve_add),
    (Bn254CurveDbl, "bn254_curve_dbl", ArithEq, ARITH_EQ_COST, 0xfb, 64, 64, opc_bn254_curve_dbl, op_bn254_curve_dbl, ops_bn254_curve_dbl),
    (Bn254ComplexAdd, "bn254_complex_add", ArithEq, ARITH_EQ_COST, 0xfc, 144, 64, opc_bn254_complex_add, op_bn254_complex_add, ops_bn254_complex_add),
    (Bn254ComplexSub, "bn254_complex_sub", ArithEq, ARITH_EQ_COST, 0xfd, 144, 64, opc_bn254_complex_sub, op_bn254_complex_sub, ops_bn254_complex_sub),
    (Bn254ComplexMul, "bn254_complex_mul", ArithEq, ARITH_EQ_COST, 0xfe, 144, 64, opc_bn254_complex_mul, op_bn254_complex_mul, ops_bn254_complex_mul),
    // halt reads no memory: with input_size 0 it is not a precompile, so replaying a failed
    // execution consumes no memory reads for it
    (Halt, "halt", Internal, INTERNAL_COST, 0xff, 0, 0, opc_halt, op_halt, ops_none),
}

impl From<ZiskRequiredOperation> for ZiskOp {
    fn from(value: ZiskRequiredOperation) -> Self {
        ZiskOp::try_from_code(value.opcode).unwrap()
    }
}
