use cfg_if::cfg_if;

cfg_if! {
    if #[cfg(all(target_os = "zkvm", target_vendor = "zisk"))] {
        use core::arch::asm;
        use crate::{ziskos_fcall, ziskos_fcall_get, ziskos_fcall_param};
        use super::FCALL_MSB_POS_384_ID;
    } else {
        use crate::zisklib::fcalls_impl::msb_pos_384::msb_pos_384;
    }
}

#[allow(unused_variables)]
pub fn fcall_msb_pos_384(
    x: &[u64; 6],
    y: &[u64; 6],
    #[cfg(feature = "hints")] hints: &mut Vec<u64>,
) -> (u64, u64) {
    #[cfg(not(all(target_os = "zkvm", target_vendor = "zisk")))]
    let (limb, bit) = {
        let (i, pos) = msb_pos_384(x, y);
        #[cfg(feature = "hints")]
        {
            hints.push(2);
            hints.push(i as u64);
            hints.push(pos as u64);
        }
        (i as u64, pos as u64)
    };
    #[cfg(all(target_os = "zkvm", target_vendor = "zisk"))]
    let (limb, bit) = {
        ziskos_fcall_param!(x, 8);
        ziskos_fcall_param!(y, 8);
        ziskos_fcall!(FCALL_MSB_POS_384_ID);
        (ziskos_fcall_get(), ziskos_fcall_get())
    };

    // On the zkVM the position is prover-chosen, and callers use it as a limb index and a shift
    assert!(limb < 6 && bit < 64, "msb_pos hint out of range");
    (limb, bit)
}
