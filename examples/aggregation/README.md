# Aggregation Example

The inner guest commits `InnerPublics { n, module, value }`. The aggregation guest reads an `AggregationAuthorization` holding a final setup verification key and a program verification key for each inner proof, verifies each proof with `ziskos::io::verify_zisk_proof_for_program`, requires its outputs to be exactly `InnerPublics` with zero trailing output slots, and commits the authorization together with both outputs as its `AggregationStatement`.

A wrapped proof from `prepare_send_proof` ends with the final verification key of the setup that produced it. A proof made with a self-built setup carries that setup's key, so the embedded key is accepted only when it equals the authorized one.

The authorization is not trusted merely because the guest received it. The outer verifier must:

1. Verify the aggregation proof with the locally trusted aggregation program key.
2. Compare the committed final setup keys and inner program keys with locally derived values.
3. Compare the committed inner outputs with the expected application outputs.

The host does all three: it loads the final setup keys from its proving key, takes the inner program key from `setup`, and checks the committed statement after verifying the aggregation proof.

These checks rely on the final proof binding its public values, the program key and the outputs, to the proven execution, so that a valid proof cannot advertise other publics.
