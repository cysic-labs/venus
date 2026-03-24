#[cfg(not(all(target_os = "zkvm", target_vendor = "zisk")))]
use revm::precompile::DefaultCrypto;

mod ffi;
mod impls;

#[derive(Debug)]
pub struct CustomEvmCrypto {
    #[cfg(not(all(target_os = "zkvm", target_vendor = "zisk")))]
    default_crypto: DefaultCrypto,
}

impl Default for CustomEvmCrypto {
    fn default() -> Self {
        Self {
            #[cfg(not(all(target_os = "zkvm", target_vendor = "zisk")))]
            default_crypto: DefaultCrypto,
        }
    }
}
