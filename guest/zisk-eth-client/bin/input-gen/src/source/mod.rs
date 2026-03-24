pub mod eest;
pub mod rpc;

use crate::client::ExecutionClient;
use std::path::Path;

/// Source type identifier
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum SourceKind {
    Eest,
    Rpc,
}

/// Common trait for all input sources
#[async_trait::async_trait]
pub trait InputSource: Send + Sync {
    /// Identifier for the source type
    fn kind(&self) -> SourceKind;

    /// Generate ZisK inputs for the given client
    async fn generate_inputs(
        &self,
        client: &dyn ExecutionClient,
        output: &Path,
    ) -> anyhow::Result<()>;
}
