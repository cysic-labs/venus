#[cfg(feature = "zec-rsp")]
mod rsp;
#[cfg(not(feature = "zec-rsp"))]
mod zeth;

mod types;


pub use types::{InputGenerator, InputGeneratorResult, Network};
