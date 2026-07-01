use crossbeam_channel::{bounded, Sender, Receiver};
use proofman_starks_lib_c::{direct_registered_h2d_done_c, register_host_memory_c, unregister_host_memory_c};
use proofman_util::create_buffer_fast;
use std::ffi::c_void;
use std::mem;
use std::sync::Arc;
use crossbeam_queue::SegQueue;
use crate::ProofCtx;
use fields::PrimeField64;
use crate::{ProofmanError, ProofmanResult};

pub struct MemoryHandler<F: PrimeField64 + Send + Sync + 'static> {
    pctx: Arc<ProofCtx<F>>,
    instance_ids_to_be_released: Arc<SegQueue<ReleaseEntry>>,
    sender: Sender<Vec<F>>,
    receiver: Receiver<Vec<F>>,
    n_buffers: usize,
    buffer_size: usize,
    registered_buffers: Vec<usize>,
}

#[derive(Clone, Copy)]
struct ReleaseEntry {
    instance_id: usize,
    remove_from_calculated: bool,
    full_reset: bool,
    h2d_stream_id: Option<u64>,
}

impl<F: PrimeField64 + Send + Sync + 'static> MemoryHandler<F> {
    pub fn new(pctx: Arc<ProofCtx<F>>, n_buffers: usize, buffer_size: usize) -> Self {
        let (tx_buffer_pool, rx_buffer_pool) = bounded(n_buffers);
        let instance_ids_to_be_released = Arc::new(SegQueue::new());
        let register_buffers = registered_witness_h2d_enabled();
        let mut registered_buffers = Vec::new();
        let mut registered_bytes = 0usize;
        for _ in 0..n_buffers {
            let mut buffer = create_buffer_fast(buffer_size);
            if register_buffers {
                let bytes = buffer_size.saturating_mul(mem::size_of::<F>());
                if let Some((base, size)) = aligned_host_range(buffer.as_mut_ptr() as usize, bytes) {
                    if register_host_memory_c(base as *mut c_void, size as u64) {
                        registered_buffers.push(base);
                        registered_bytes = registered_bytes.saturating_add(size);
                    }
                }
            }
            tx_buffer_pool.send(buffer).unwrap();
        }
        if register_buffers {
            tracing::info!(
                "MemoryHandler::registered {} witness buffers ({:.2} GB) for direct H2D",
                registered_buffers.len(),
                registered_bytes as f64 / (1024.0 * 1024.0 * 1024.0)
            );
        }

        Self {
            pctx,
            sender: tx_buffer_pool,
            receiver: rx_buffer_pool,
            instance_ids_to_be_released,
            n_buffers,
            buffer_size,
            registered_buffers,
        }
    }

    pub fn reset(&self) -> ProofmanResult<()> {
        let mut current_buffers = Vec::new();
        while let Ok(buffer) = self.receiver.try_recv() {
            current_buffers.push(buffer);
        }
        self.drain_queue_to_be_released(&mut current_buffers);

        let mut valid_buffers: Vec<Vec<F>> = Vec::with_capacity(self.n_buffers);
        for buf in current_buffers.into_iter() {
            if buf.len() == self.buffer_size {
                valid_buffers.push(buf);
            } else {
                return Err(ProofmanError::ProofmanError(format!(
                    "MemoryHandler::Found buffer with unexpected size {} (expected {}), replacing it.",
                    buf.len(),
                    self.buffer_size
                )));
            }
        }

        while valid_buffers.len() < self.n_buffers {
            tracing::warn!(
                "MemoryHandler::Not enough valid buffers (found {}), creating a new one.",
                valid_buffers.len()
            );
            valid_buffers.push(create_buffer_fast(self.buffer_size));
        }

        for buf in valid_buffers.into_iter() {
            self.sender.send(buf).unwrap();
        }

        Ok(())
    }

    pub fn take_buffer(&self) -> Vec<F> {
        loop {
            if let Ok(buffer) = self.receiver.try_recv() {
                return buffer;
            }
            if let Some(release) = self.instance_ids_to_be_released.pop() {
                match self.release_instance_entry(release, false) {
                    Some(Some(witness_buffer)) => return witness_buffer,
                    Some(None) => {}
                    None => {
                        self.instance_ids_to_be_released.push(release);
                        std::thread::sleep(std::time::Duration::from_micros(10));
                        continue;
                    }
                }
            }
            std::thread::sleep(std::time::Duration::from_micros(10));
        }
    }

    pub fn release_buffer(&self, buffer: Vec<F>) -> ProofmanResult<()> {
        if buffer.len() != self.buffer_size {
            return Err(ProofmanError::ProofmanError(format!(
                "MemoryHandler::Trying to release buffer with unexpected size {} (expected {}).",
                buffer.len(),
                self.buffer_size
            )));
        }
        self.sender.send(buffer).expect("Failed to send buffer back to pool");
        Ok(())
    }

    pub fn to_be_released_buffer(&self, instance_id: usize, remove_from_calculated: bool) {
        self.instance_ids_to_be_released.push(ReleaseEntry {
            instance_id,
            remove_from_calculated,
            full_reset: false,
            h2d_stream_id: None,
        });
    }

    pub fn to_be_released_instance_after_h2d(&self, instance_id: usize, stream_id: u64) {
        self.instance_ids_to_be_released.push(ReleaseEntry {
            instance_id,
            remove_from_calculated: false,
            full_reset: true,
            h2d_stream_id: Some(stream_id),
        });
    }

    pub fn get_n_buffers(&self) -> usize {
        self.receiver.len()
    }

    pub fn empty_queue_to_be_released(&self) {
        while !self.instance_ids_to_be_released.is_empty() {
            self.instance_ids_to_be_released.pop();
        }
    }

    pub fn release_queue_to_pool(&self) -> ProofmanResult<()> {
        let mut buffers = Vec::new();
        self.drain_queue_to_be_released(&mut buffers);
        for buffer in buffers {
            self.release_buffer(buffer)?;
        }
        Ok(())
    }

    fn drain_queue_to_be_released(&self, buffers: &mut Vec<Vec<F>>) {
        while let Some(release) = self.instance_ids_to_be_released.pop() {
            if let Some(Some(witness_buffer)) = self.release_instance_entry(release, true) {
                buffers.push(witness_buffer);
            }
        }
    }

    fn release_instance_entry(&self, release: ReleaseEntry, wait_for_h2d: bool) -> Option<Option<Vec<F>>> {
        if let Some(stream_id) = release.h2d_stream_id {
            loop {
                if direct_registered_h2d_done_c(self.pctx.get_device_buffers_ptr(), stream_id) {
                    break;
                }
                if !wait_for_h2d {
                    return None;
                }
                std::thread::sleep(std::time::Duration::from_micros(10));
            }
        }
        if release.remove_from_calculated {
            self.pctx.dctx_reset_instance_calculated(release.instance_id);
        }
        let (is_shared_buffer, witness_buffer) = if release.full_reset {
            self.pctx.free_instance(release.instance_id)
        } else {
            self.pctx.free_instance_traces(release.instance_id)
        };
        Some(is_shared_buffer.then_some(witness_buffer))
    }
}

impl<F: PrimeField64 + Send + Sync + 'static> Drop for MemoryHandler<F> {
    fn drop(&mut self) {
        for ptr in &self.registered_buffers {
            unregister_host_memory_c(*ptr as *mut c_void);
        }
    }
}

fn registered_witness_h2d_enabled() -> bool {
    std::env::var("VENUS_REGISTER_WITNESS_H2D").map(|value| !value.is_empty() && value != "0").unwrap_or(false)
}

fn aligned_host_range(ptr: usize, bytes: usize) -> Option<(usize, usize)> {
    if ptr == 0 || bytes == 0 {
        return None;
    }
    #[cfg(target_os = "linux")]
    {
        let page_size = unsafe { libc::sysconf(libc::_SC_PAGESIZE) };
        let page_size = if page_size > 0 { page_size as usize } else { 4096 };
        let base = ptr & !(page_size - 1);
        let offset = ptr - base;
        let size = (bytes + offset + page_size - 1) & !(page_size - 1);
        Some((base, size))
    }
    #[cfg(not(target_os = "linux"))]
    {
        Some((ptr, bytes))
    }
}

pub trait BufferPool<F: PrimeField64>: Send + Sync
where
    F: Send + Sync + 'static,
{
    fn take_buffer(&self) -> Vec<F>;
}

impl<F: PrimeField64 + Send + Sync + 'static> BufferPool<F> for MemoryHandler<F> {
    fn take_buffer(&self) -> Vec<F> {
        self.take_buffer()
    }
}
