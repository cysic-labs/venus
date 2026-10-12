//! Teardown of the runtime a proving run owns: worker threads, channels, device streams and
//! per-run state. A `ProofMan` is reused across runs, so the teardown order matters: workers
//! must be stopped before streams are synchronized, and streams must be synchronized before
//! the buffers they write into are released.

use std::any::Any;
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::{Mutex, MutexGuard, RwLock, RwLockWriteGuard};
use std::thread::JoinHandle;

use crossbeam_channel::{Receiver, Sender};
use proofman_common::{ProofmanError, ProofmanResult};

use crate::CancellationInfo;

/// Message id on a recursive-proof channel that tells the receiving worker to exit.
pub(crate) const RECURSIVE_WORKER_STOP_ID: u64 = u64::MAX - 1;

/// Instance id on the contributions channel that tells the receiving worker to exit.
pub(crate) const CONTRIBUTION_WORKER_STOP_ID: usize = usize::MAX;

/// Worker threads spawned by a run that must be joined before the next run starts.
pub(crate) struct OwnedWorkerHandles {
    pub(crate) recursive: Vec<JoinHandle<()>>,
    pub(crate) contributions: Vec<JoinHandle<()>>,
    pub(crate) outer: Option<JoinHandle<()>>,
}

/// Locks a mutex for cleanup, recovering it if a panicked worker poisoned it.
pub(crate) fn cleanup_mutex_lock<T>(lock: &Mutex<T>) -> MutexGuard<'_, T> {
    match lock.lock() {
        Ok(guard) => guard,
        Err(poisoned) => {
            lock.clear_poison();
            poisoned.into_inner()
        }
    }
}

/// Write-locks a lock for cleanup, recovering it if a panicked worker poisoned it.
pub(crate) fn cleanup_write_lock<T>(lock: &RwLock<T>) -> RwLockWriteGuard<'_, T> {
    match lock.write() {
        Ok(guard) => guard,
        Err(poisoned) => {
            lock.clear_poison();
            poisoned.into_inner()
        }
    }
}

/// Discards every pending message and returns how many were discarded.
pub(crate) fn drain_receiver<T>(receiver: &Receiver<T>) -> usize {
    let mut drained = 0;
    while receiver.try_recv().is_ok() {
        drained += 1;
    }
    drained
}

/// Refills the witness thread pool without blocking on a full or disconnected channel.
pub(crate) fn restore_thread_permits(sender: &Sender<()>, permit_count: usize) -> ProofmanResult<()> {
    let mut failed_permits = 0;
    let mut first_error = None;

    for _ in 0..permit_count {
        if let Err(error) = sender.try_send(()) {
            failed_permits += 1;
            first_error.get_or_insert_with(|| error.to_string());
        }
    }

    if failed_permits == 0 {
        Ok(())
    } else {
        let first_error = first_error.unwrap_or_else(|| "unknown channel error".to_string());
        Err(ProofmanError::ProofmanError(format!(
            "failed to restore {failed_permits} of {permit_count} witness thread permits: {first_error}"
        )))
    }
}

fn thread_panic_message(panic: Box<dyn Any + Send + 'static>) -> String {
    if let Some(message) = panic.downcast_ref::<&str>() {
        (*message).to_string()
    } else if let Some(message) = panic.downcast_ref::<String>() {
        message.clone()
    } else {
        "unknown panic payload".to_string()
    }
}

/// Tears down the runtime of the current run in a fixed order:
///
/// 1. cancel the run so polling workers exit, then clear the proof-done callback and detach
///    the producers that feed the worker channels;
/// 2. send one stop message per owned worker and join every worker, recording panics instead
///    of propagating them;
/// 3. synchronize the device streams, so no in-flight work still writes into run state;
/// 4. drain stale channel messages and clear the per-run state.
///
/// The cancellation token stays cancelled; the caller resets it when a new run starts.
#[allow(clippy::too_many_arguments)]
pub(crate) fn reset_owned_runtime<ClearCallback, DetachProducers, SynchronizeStreams, DrainChannels, ClearState>(
    cancellation_info: &RwLock<CancellationInfo>,
    recursive_tx: &Sender<(u64, String)>,
    contributions_tx: &Sender<usize>,
    outer_finished: &AtomicBool,
    workers: OwnedWorkerHandles,
    clear_callback: ClearCallback,
    detach_producers: DetachProducers,
    synchronize_streams: SynchronizeStreams,
    drain_channels: DrainChannels,
    clear_state: ClearState,
) -> ProofmanResult<()>
where
    ClearCallback: FnOnce(),
    DetachProducers: FnOnce(),
    SynchronizeStreams: FnOnce(),
    DrainChannels: FnOnce(),
    ClearState: FnOnce() -> ProofmanResult<()>,
{
    cleanup_write_lock(cancellation_info).cancel(None);
    clear_callback();
    detach_producers();
    outer_finished.store(true, Ordering::SeqCst);

    let mut cleanup_errors = Vec::new();
    for _ in 0..workers.recursive.len() {
        if let Err(error) = recursive_tx.send((RECURSIVE_WORKER_STOP_ID, String::new())) {
            cleanup_errors.push(format!("failed to signal recursive worker: {error}"));
        }
    }
    for _ in 0..workers.contributions.len() {
        if let Err(error) = contributions_tx.send(CONTRIBUTION_WORKER_STOP_ID) {
            cleanup_errors.push(format!("failed to signal contribution worker: {error}"));
        }
    }

    for (worker_id, handle) in workers.recursive.into_iter().enumerate() {
        if let Err(panic) = handle.join() {
            cleanup_errors.push(format!("recursive worker {worker_id} panicked: {}", thread_panic_message(panic)));
        }
    }
    for (worker_id, handle) in workers.contributions.into_iter().enumerate() {
        if let Err(panic) = handle.join() {
            cleanup_errors.push(format!("contribution worker {worker_id} panicked: {}", thread_panic_message(panic)));
        }
    }
    if let Some(handle) = workers.outer {
        if let Err(panic) = handle.join() {
            cleanup_errors.push(format!("outer aggregation worker panicked: {}", thread_panic_message(panic)));
        }
    }

    synchronize_streams();
    drain_channels();
    let clear_state_result = clear_state();

    if cleanup_errors.is_empty() {
        clear_state_result
    } else {
        if let Err(error) = clear_state_result {
            cleanup_errors.push(format!("state cleanup failed: {error}"));
        }
        Err(ProofmanError::ProofmanError(cleanup_errors.join("; ")))
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crossbeam_channel::unbounded;
    use std::sync::Arc;

    fn record(events: &Mutex<Vec<&'static str>>, event: &'static str) {
        events.lock().unwrap().push(event);
    }

    fn event_position(events: &[&str], event: &str) -> usize {
        events.iter().position(|candidate| *candidate == event).unwrap()
    }

    #[test]
    fn reset_stops_every_owned_worker_before_synchronizing_and_clearing_state() {
        let cancellation_info = Arc::new(RwLock::new(CancellationInfo::default()));
        let outer_finished = AtomicBool::new(false);
        let (recursive_tx, recursive_rx) = unbounded::<(u64, String)>();
        let (contributions_tx, contributions_rx) = unbounded::<usize>();
        let events = Arc::new(Mutex::new(Vec::new()));

        // Two workers consume stop messages and two only poll the cancellation token, so two
        // recursive stop messages stay queued. Worker counts differ from any stream count.
        let mut recursive = Vec::new();
        for _ in 0..2 {
            let (receiver, events) = (recursive_rx.clone(), events.clone());
            recursive.push(std::thread::spawn(move || {
                assert_eq!(receiver.recv().unwrap().0, RECURSIVE_WORKER_STOP_ID);
                record(&events, "worker_exit");
            }));
        }
        for _ in 0..2 {
            let (cancellation_info, events) = (cancellation_info.clone(), events.clone());
            recursive.push(std::thread::spawn(move || {
                while !cancellation_info.read().unwrap().token.is_cancelled() {
                    std::thread::yield_now();
                }
                record(&events, "worker_exit");
            }));
        }
        let mut contributions = Vec::new();
        for _ in 0..3 {
            let (receiver, events) = (contributions_rx.clone(), events.clone());
            contributions.push(std::thread::spawn(move || {
                assert_eq!(receiver.recv().unwrap(), CONTRIBUTION_WORKER_STOP_ID);
                record(&events, "worker_exit");
            }));
        }

        let stale_recursive = Arc::new(Mutex::new(None));
        let result = reset_owned_runtime(
            &cancellation_info,
            &recursive_tx,
            &contributions_tx,
            &outer_finished,
            OwnedWorkerHandles { recursive, contributions, outer: None },
            || record(&events, "clear_callback"),
            || record(&events, "detach_producers"),
            || record(&events, "sync_streams"),
            || {
                *stale_recursive.lock().unwrap() = Some(drain_receiver(&recursive_rx));
                assert_eq!(drain_receiver(&contributions_rx), 0);
                record(&events, "drain_channels");
            },
            || {
                record(&events, "clear_state");
                Ok(())
            },
        );

        assert!(result.is_ok());
        assert!(cancellation_info.read().unwrap().token.is_cancelled());
        assert!(outer_finished.load(Ordering::SeqCst));
        assert_eq!(*stale_recursive.lock().unwrap(), Some(2));

        let events = events.lock().unwrap();
        assert_eq!(events.iter().filter(|event| **event == "worker_exit").count(), 7);
        let sync_streams = event_position(&events, "sync_streams");
        assert!(event_position(&events, "clear_callback") < event_position(&events, "detach_producers"));
        assert!(events.iter().enumerate().all(|(position, event)| *event != "worker_exit" || position < sync_streams));
        assert!(sync_streams < event_position(&events, "drain_channels"));
        assert!(event_position(&events, "drain_channels") < event_position(&events, "clear_state"));
    }

    #[test]
    fn reset_finishes_teardown_when_a_worker_panicked() {
        let cancellation_info = RwLock::new(CancellationInfo::default());
        let outer_finished = AtomicBool::new(false);
        let (recursive_tx, recursive_rx) = unbounded::<(u64, String)>();
        let (contributions_tx, _contributions_rx) = unbounded::<usize>();
        let synchronized = AtomicBool::new(false);
        let state_cleared = AtomicBool::new(false);

        let panicking = std::thread::spawn(|| panic!("expected reset test panic"));
        let survivor = std::thread::spawn(move || {
            assert_eq!(recursive_rx.recv().unwrap().0, RECURSIVE_WORKER_STOP_ID);
        });

        let result = reset_owned_runtime(
            &cancellation_info,
            &recursive_tx,
            &contributions_tx,
            &outer_finished,
            OwnedWorkerHandles { recursive: vec![panicking, survivor], contributions: Vec::new(), outer: None },
            || {},
            || {},
            || synchronized.store(true, Ordering::SeqCst),
            || {},
            || {
                state_cleared.store(true, Ordering::SeqCst);
                Ok(())
            },
        );

        let error = result.unwrap_err().to_string();
        assert!(error.contains("recursive worker 0 panicked: expected reset test panic"), "{error}");
        assert!(synchronized.load(Ordering::SeqCst));
        assert!(state_cleared.load(Ordering::SeqCst));
    }
}
