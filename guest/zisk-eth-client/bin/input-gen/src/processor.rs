use tracing::{info, warn};

pub struct ProcessingTracker {
    client_name: String,
    success_count: usize,
    error_count: usize,
}

impl ProcessingTracker {
    pub fn new(client_name: &str) -> Self {
        Self {
            client_name: client_name.to_string(),
            success_count: 0,
            error_count: 0,
        }
    }

    pub fn record_success(&mut self, item: &str) {
        self.success_count += 1;
        info!("Generated {} input for: {}", self.client_name, item);
    }

    pub fn record_error(&mut self, item: &str, error: &anyhow::Error) {
        self.error_count += 1;
        warn!(
            "Failed to generate {} input for {}: {}",
            self.client_name, item, error
        );
    }

    pub fn log_summary(&self) {
        info!(
            "Completed: {} succeeded, {} failed",
            self.success_count, self.error_count
        );
    }
}
