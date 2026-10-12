// This example program iterates a Fibonacci recurrence `n` times and commits the result.

// Mark the main function as the entry point for ZisK
#![no_main]
ziskos::entrypoint!(main);

#[path = "../../protocol.rs"]
mod protocol;

fn main() {
    // Read the input data
    let n: u32 = ziskos::io::read();

    // Commit all outputs at once: every commit writes from the first public output slot.
    ziskos::io::commit(&protocol::compute_inner_publics(n));
}
