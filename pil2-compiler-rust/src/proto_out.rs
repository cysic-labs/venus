//! Protobuf serialization for PIL compiler output.
//! Converts internal compiler state to PilOut protobuf message.

#[allow(unused_imports)]
use prost::Message;

/// Generated protobuf types from pilout.proto.
pub mod pilout_proto {
    include!(concat!(env!("OUT_DIR"), "/pilout.rs"));
}

/// Serialize and write a PilOut message to the given path.
/// Full implementation forthcoming.
pub fn write_pilout(_path: &str) -> anyhow::Result<()> {
    anyhow::bail!("proto_out not yet implemented")
}

#[cfg(test)]
mod tests {
    use super::pilout_proto;

    #[test]
    fn test_proto_types_exist() {
        // Verify that key protobuf types are generated and accessible
        let _pilout = pilout_proto::PilOut::default();
        let _air_group = pilout_proto::AirGroup::default();
        let _air = pilout_proto::Air::default();
        let _symbol = pilout_proto::Symbol::default();
        let _hint = pilout_proto::Hint::default();
    }

    #[test]
    fn test_write_pilout_not_implemented() {
        let result = super::write_pilout("/dev/null");
        assert!(result.is_err());
    }
}
