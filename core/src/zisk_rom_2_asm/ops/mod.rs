//! Operations: the code that computes c and the flag of every operation, by operation family

mod arithmetic;
mod big_int;
mod bitwise;
mod comparison;
mod complex;
mod curves;
mod dma;
mod fcall;
mod hash;
mod system;

use crate::{
    zisk_ops::ZiskOp, zisk_rom_2_asm::registers::REG_C, ZiskAsmContext, ZiskInst, ZiskRom2Asm,
};

impl ZiskRom2Asm {
    /// Emits the operation of an instruction, which computes c and the flag
    pub(super) fn operation_to_asm(
        ctx: &mut ZiskAsmContext,
        inst: &ZiskInst,
        code: &mut String,
        unusual_code: &mut String,
    ) {
        let opcode = inst.op;
        // Set flags to false, by default
        ctx.flag_is_always_one = false;
        ctx.flag_is_always_zero = false;

        // Prepare c context
        ctx.c.is_constant = false;
        ctx.c.constant_value = 0;
        ctx.c.is_saved = false;
        ctx.c.string_value = REG_C.to_string();

        let zisk_op = ZiskOp::try_from_code(opcode).unwrap();
        match zisk_op {
            ZiskOp::Flag => Self::flag_to_asm(ctx, code),
            ZiskOp::CopyB => Self::copyb_to_asm(ctx),
            ZiskOp::SignExtendB => Self::signextend_b_to_asm(ctx, code),
            ZiskOp::SignExtendH => Self::signextend_h_to_asm(ctx, code),
            ZiskOp::SignExtendW => Self::signextend_w_to_asm(ctx, code),
            ZiskOp::Add => Self::add_to_asm(ctx, code),
            ZiskOp::AddW => Self::add_w_to_asm(ctx, code),
            ZiskOp::Sub => Self::sub_to_asm(ctx, code),
            ZiskOp::SubW => Self::sub_w_to_asm(ctx, code),
            ZiskOp::Sll => Self::sll_to_asm(ctx, code),
            ZiskOp::SllW => Self::sll_w_to_asm(ctx, code),
            ZiskOp::Sra => Self::sra_to_asm(ctx, code),
            ZiskOp::Srl => Self::srl_to_asm(ctx, code),
            ZiskOp::SraW => Self::sra_w_to_asm(ctx, code),
            ZiskOp::SrlW => Self::srl_w_to_asm(ctx, code),
            ZiskOp::Eq => Self::eq_to_asm(ctx, code),
            ZiskOp::EqW => Self::eq_w_to_asm(ctx, code),
            ZiskOp::Ltu => Self::ltu_to_asm(ctx, code),
            ZiskOp::Lt => Self::lt_to_asm(ctx, code),
            ZiskOp::LtuW => Self::ltu_w_to_asm(ctx, code),
            ZiskOp::LtW => Self::lt_w_to_asm(ctx, code),
            ZiskOp::Leu => Self::leu_to_asm(ctx, code),
            ZiskOp::Le => Self::le_to_asm(ctx, code),
            ZiskOp::LeuW => Self::leu_w_to_asm(ctx, code),
            ZiskOp::LeW => Self::le_w_to_asm(ctx, code),
            ZiskOp::And => Self::and_to_asm(ctx, code),
            ZiskOp::Or => Self::or_to_asm(ctx, code),
            ZiskOp::Xor => Self::xor_to_asm(ctx, code),
            ZiskOp::Mulu => Self::mulu_to_asm(ctx, code),
            ZiskOp::Muluh => Self::muluh_to_asm(ctx, code),
            ZiskOp::Mulsuh => Self::mulsuh_to_asm(ctx, code),
            ZiskOp::Mul => Self::mul_to_asm(ctx, code),
            ZiskOp::Mulh => Self::mulh_to_asm(ctx, code),
            ZiskOp::MulW => Self::mul_w_to_asm(ctx, code),
            ZiskOp::Divu => Self::divu_to_asm(ctx, code),
            ZiskOp::Remu => Self::remu_to_asm(ctx, code),
            ZiskOp::Div => Self::div_to_asm(ctx, code, unusual_code),
            ZiskOp::Rem => Self::rem_to_asm(ctx, code),
            ZiskOp::DivuW => Self::divu_w_to_asm(ctx, code),
            ZiskOp::RemuW => Self::remu_w_to_asm(ctx, code),
            ZiskOp::DivW => Self::div_w_to_asm(ctx, code),
            ZiskOp::RemW => Self::rem_w_to_asm(ctx, code),
            ZiskOp::Minu => Self::minu_to_asm(ctx, code),
            ZiskOp::Min => Self::min_to_asm(ctx, code),
            ZiskOp::MinuW => Self::minu_w_to_asm(ctx, code),
            ZiskOp::MinW => Self::min_w_to_asm(ctx, code),
            ZiskOp::Maxu => Self::maxu_to_asm(ctx, code),
            ZiskOp::Max => Self::max_to_asm(ctx, code),
            ZiskOp::MaxuW => Self::maxu_w_to_asm(ctx, code),
            ZiskOp::MaxW => Self::max_w_to_asm(ctx, code),
            ZiskOp::Keccak => Self::keccak_to_asm(ctx, code, unusual_code),
            ZiskOp::Sha256 => Self::sha256_to_asm(ctx, code, unusual_code),
            ZiskOp::Blake2 => Self::blake2_to_asm(ctx, code, unusual_code),
            ZiskOp::Poseidon2 => Self::poseidon2_to_asm(ctx, code, unusual_code),
            ZiskOp::PubOut => Self::pubout_to_asm(ctx),
            ZiskOp::Arith256 => Self::arith256_to_asm(ctx, code, unusual_code),
            ZiskOp::Arith256Mod => Self::arith256_mod_to_asm(ctx, code, unusual_code),
            ZiskOp::Secp256k1Add => Self::secp256k1_add_to_asm(ctx, code, unusual_code),
            ZiskOp::Secp256k1Dbl => Self::secp256k1_dbl_to_asm(ctx, code, unusual_code),
            ZiskOp::Secp256r1Add => Self::secp256r1_add_to_asm(ctx, code, unusual_code),
            ZiskOp::Secp256r1Dbl => Self::secp256r1_dbl_to_asm(ctx, code, unusual_code),
            ZiskOp::FcallParam => Self::fcall_param_to_asm(ctx, code, unusual_code),
            ZiskOp::Fcall => Self::fcall_to_asm(ctx, code, unusual_code),
            ZiskOp::FcallGet => Self::fcall_get_to_asm(ctx, code, unusual_code),
            ZiskOp::Bn254CurveAdd => Self::bn254_curve_add_to_asm(ctx, code, unusual_code),
            ZiskOp::Bn254CurveDbl => Self::bn254_curve_dbl_to_asm(ctx, code, unusual_code),
            ZiskOp::Bn254ComplexAdd => Self::bn254_complex_add_to_asm(ctx, code, unusual_code),
            ZiskOp::Bn254ComplexSub => Self::bn254_complex_sub_to_asm(ctx, code, unusual_code),
            ZiskOp::Bn254ComplexMul => Self::bn254_complex_mul_to_asm(ctx, code, unusual_code),
            ZiskOp::Halt => Self::halt_to_asm(ctx, code),
            ZiskOp::Arith384Mod => Self::arith384_mod_to_asm(ctx, code, unusual_code),
            ZiskOp::Bls12_381CurveAdd => Self::bls12_381_curve_add_to_asm(ctx, code, unusual_code),
            ZiskOp::Bls12_381CurveDbl => Self::bls12_381_curve_dbl_to_asm(ctx, code, unusual_code),
            ZiskOp::Bls12_381ComplexAdd => {
                Self::bls12_381_complex_add_to_asm(ctx, code, unusual_code)
            }
            ZiskOp::Bls12_381ComplexSub => {
                Self::bls12_381_complex_sub_to_asm(ctx, code, unusual_code)
            }
            ZiskOp::Bls12_381ComplexMul => {
                Self::bls12_381_complex_mul_to_asm(ctx, code, unusual_code)
            }
            ZiskOp::Add256 => Self::add256_to_asm(ctx, code, unusual_code),
            ZiskOp::DmaMemCpy | ZiskOp::DmaXMemCpy => {
                Self::dma_memcpy_to_asm(ctx, inst, code, unusual_code)
            }
            ZiskOp::DmaMemCmp | ZiskOp::DmaXMemCmp => {
                Self::dma_memcmp_to_asm(ctx, inst, code, unusual_code)
            }
            ZiskOp::DmaInputCpy => Self::dma_inputcpy_to_asm(ctx, code, unusual_code),
            ZiskOp::DmaXMemSet => Self::dma_xmemset_to_asm(ctx, inst, code, unusual_code),
            ZiskOp::Dma64Aligned => unimplemented!("Internal opcode Dma64Aligned"),
            ZiskOp::DmaUnaligned => unimplemented!("Internal opcode DmaUnaligned"),
            ZiskOp::DmaPre => unimplemented!("Internal opcode DmaPre"),
            ZiskOp::DmaPost => unimplemented!("Internal opcode DmaPost"),
        }
    }
}
