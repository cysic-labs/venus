//! Free calls: the parameters, the call and the results of a free call

use ziskos_hints::zisklib::{fcall_proxy, FCALL_INPUT_READY_ID};

use crate::{
    EmulationMode, InstContext, FCALL_PARAMS_MAX_SIZE, FCALL_RESULT_MAX_SIZE, INPUT_ADDR,
    MAX_INPUT_SIZE,
};

/// Implements fcall_param, free input data call parameter
#[inline(always)]
pub fn op_fcall_param(a: u64, b: u64) -> (u64, bool) {
    unimplemented!("op_fcall_param() is not implemented");
}

/// InstContext-based wrapper over op_fcall_param()
#[inline(always)]
pub fn opc_fcall_param(ctx: &mut InstContext) {
    // Set c and flag according to the spec
    ctx.c = ctx.b;
    ctx.flag = false;

    // Do nothing when emulating in consume memory reads mode;
    // data will be directly obtained from mem_reads
    if ctx.emulation_mode == EmulationMode::ConsumeMemReads {
        return;
    }

    // Get param size from a
    let words = ctx.a;

    // Get param chunk from b
    let param = ctx.b;

    // Check for consistency
    if (ctx.fcall.parameters_size + words) as usize > FCALL_PARAMS_MAX_SIZE {
        panic!(
            "opc_fcall_param({0}) called with ctx.fcall.parameters_size({1}) + param({0})>{2}",
            words, ctx.fcall.parameters_size, FCALL_PARAMS_MAX_SIZE
        );
    }

    // Store param in context
    if words == 1 {
        ctx.fcall.parameters[ctx.fcall.parameters_size as usize] = param;
        ctx.fcall.parameters_size += 1;
    } else {
        let addr = param;
        for i in 0..words {
            let value = ctx.mem.read(addr + i * 8, 8);
            ctx.fcall.parameters[(ctx.fcall.parameters_size + i) as usize] = value;
        }
        ctx.fcall.parameters_size += words;
    }
}

/// Implements fcall, free input data calls
#[inline(always)]
pub fn op_fcall(a: u64, b: u64) -> (u64, bool) {
    unimplemented!("op_fcall() is not implemented");
}

/// InstContext-based wrapper over op_fcall()
#[inline(always)]
pub fn opc_fcall(ctx: &mut InstContext) {
    // Set c and flag according to the spec
    ctx.c = ctx.b;
    ctx.flag = false;

    // Do nothing when emulating in consume memory reads mode;
    // data will be directly obtained from mem_reads
    if ctx.emulation_mode == EmulationMode::ConsumeMemReads {
        return;
    }

    // Get function id from a
    let function_id = ctx.a;

    let iresult = if function_id == FCALL_INPUT_READY_ID as u64 {
        let required_address = ctx.fcall.parameters[0];
        if required_address < INPUT_ADDR {
            panic!(
                "opc_fcall() FCALL_INPUT_READY_ID called with required_address {:#x} < {:#x}",
                required_address, INPUT_ADDR
            );
        }
        if required_address >= INPUT_ADDR + MAX_INPUT_SIZE - 1 {
            panic!(
                "opc_fcall() FCALL_INPUT_READY_ID called with required_address {:#x} > {:#x}",
                required_address,
                INPUT_ADDR + MAX_INPUT_SIZE - 1
            );
        }

        let required_bytes = required_address - INPUT_ADDR - 8 + 1; // + 1 because required_address is the address of the last required byte
        if required_bytes > ctx.input_len {
            panic!(
                "opc_fcall() FCALL_INPUT_READY_ID called with required_address {:#x} requiring {} bytes, but only {} bytes available",
                required_address,
                required_bytes,
                ctx.input_len
            );
        }
        0
    } else {
        fcall_proxy(function_id, &ctx.fcall.parameters, &mut ctx.fcall.result)
    };

    if iresult < 0 {
        panic!("opc_fcall() failed calling Fcall() function_id={function_id} iresult={iresult}");
    }

    // Copy result
    if (iresult > 0) {
        ctx.mem.free_input = ctx.fcall.result[0];
    } else {
        ctx.mem.free_input = 0;
    }
    ctx.fcall.result_got = 1;
    ctx.fcall.result_size = iresult as u64;
    ctx.fcall.parameters_size = 0;
}

/// Implements fcall_get, fcall result
#[inline(always)]
pub fn op_fcall_get(a: u64, b: u64) -> (u64, bool) {
    unimplemented!("op_fcall_get() is not implemented");
}

/// InstContext-based wrapper over op_fcall_get()
#[inline(always)]
pub fn opc_fcall_get(ctx: &mut InstContext) {
    ctx.c = ctx.b;
    ctx.flag = false;

    // Do nothing when emulating in consume memory reads mode;
    // data will be directly obtained from mem_reads
    if ctx.emulation_mode == EmulationMode::ConsumeMemReads {
        return;
    }
    // Check for consistency
    if ctx.fcall.result_size == 0 {
        panic!("opc_fcall_get() called with ctx.fcall.result_size==0");
    }
    if ctx.fcall.result_size as usize > FCALL_RESULT_MAX_SIZE {
        panic!("opc_fcall_get() called with ctx.fcall.result_size=={}>32", ctx.fcall.result_size);
    }
    if ctx.fcall.result_got > ctx.fcall.result_size {
        panic!(
            "opc_fcall_get() called with ctx.fcall.result_got({}) >= ctx.fcall.result_size {}",
            ctx.fcall.result_got, ctx.fcall.result_size
        );
    }

    // Copy the data into c and advance counter
    if ctx.fcall.result_got >= ctx.fcall.result_size {
        ctx.mem.free_input = 0;
    } else {
        ctx.mem.free_input = ctx.fcall.result[ctx.fcall.result_got as usize];
    }
    ctx.fcall.result_got += 1;
    ctx.flag = false;
}
