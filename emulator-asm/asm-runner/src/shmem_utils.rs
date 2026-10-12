use libc::{
    c_uint, close, fstat, mmap, munmap, shm_open, shm_unlink, MAP_FAILED, MAP_SHARED, PROT_READ,
    S_IRUSR, S_IWUSR,
};
use std::{ffi::CString, fmt::Debug, io, mem::MaybeUninit, os::raw::c_void, ptr};

use anyhow::{anyhow, Result};

pub enum AsmSharedMemoryMode {
    ReadOnly,
    ReadWrite,
}

pub struct AsmSharedMemory<H: AsmShmemHeader> {
    _fd: i32,
    mapped_ptr: *mut c_void,
    mapped_size: usize,
    shmem_name: String,
    _phantom: std::marker::PhantomData<H>,
}

unsafe impl<H: AsmShmemHeader> Send for AsmSharedMemory<H> {}
unsafe impl<H: AsmShmemHeader> Sync for AsmSharedMemory<H> {}

pub trait AsmShmemHeader: Debug {
    fn allocated_size(&self) -> u64;
}

/// Header of a chunk in the assembly emulator output, followed by `payload_len()` `u64` words.
///
/// # Safety
/// Implementors must be `repr(C)` structs made only of integer fields, so that any bytes read
/// from shared memory form a valid value.
pub unsafe trait AsmShmemChunk {
    fn payload_len(&self) -> u64;
}

#[cfg(all(target_os = "linux", target_arch = "x86_64"))]
impl<H: AsmShmemHeader> Drop for AsmSharedMemory<H> {
    fn drop(&mut self) {
        self.unmap().unwrap_or_else(|err| {
            tracing::error!("Failed to unmap shared memory '{}': {}", self.shmem_name, err)
        });
        unsafe { close(self._fd) };
    }
}

impl<H: AsmShmemHeader> AsmSharedMemory<H> {
    pub fn open_and_map(name: &str, _unlock_mapped_memory: bool) -> Result<Self> {
        unsafe {
            if name.is_empty() {
                return Err(anyhow::anyhow!("Shared memory name {name} cannot be empty"));
            }

            let c_name = CString::new(name)
                .map_err(|_| anyhow::anyhow!("Shared memory name contains null byte"))?;

            let fd =
                shm_open(c_name.as_ptr(), libc::O_RDONLY, S_IRUSR as c_uint | S_IWUSR as c_uint);
            if fd == -1 {
                let err = io::Error::last_os_error();
                return Err(anyhow::anyhow!("shm_open('{name}') failed: {err}"));
            }

            // Unlink the shared memory object to ensure it is removed after use
            // This is necessary to avoid leaving stale shared memory objects
            // in the system, especially if the program crashes or exits unexpectedly.
            // Note: This does not affect the current mapping, it just ensures that
            // the shared memory object is removed from the filesystem namespace.
            if shm_unlink(c_name.as_ptr()) != 0 {
                let err = io::Error::last_os_error();
                close(fd);
                return Err(anyhow::anyhow!("shm_unlink('{name}') failed: {err}"));
            }

            #[cfg(not(all(target_os = "linux", target_arch = "x86_64")))]
            let flags = MAP_SHARED;
            #[cfg(all(target_os = "linux", target_arch = "x86_64"))]
            let mut flags = MAP_SHARED;
            #[cfg(all(target_os = "linux", target_arch = "x86_64"))]
            if !_unlock_mapped_memory {
                flags |= libc::MAP_LOCKED;
            }

            // Pages past the end of the backing object raise SIGBUS when touched, so every mapping
            // below must fit in it.
            let object_size = match shmem_object_size(fd) {
                Ok(size) => size,
                Err(err) => {
                    close(fd);
                    return Err(anyhow::anyhow!("fstat failed for '{name}': {err}"));
                }
            };

            let size_header = size_of::<H>();
            if object_size < size_header {
                close(fd);
                return Err(anyhow::anyhow!(
                    "Shared memory '{name}' is smaller than its header \
                     ({object_size} < {size_header} bytes)"
                ));
            }

            let mapped_ptr = mmap(ptr::null_mut(), size_header, PROT_READ, flags, fd, 0);
            if mapped_ptr == MAP_FAILED {
                let err = io::Error::last_os_error();
                close(fd);
                return Err(anyhow::anyhow!(
                    "mmap failed for '{name}': {err:?} ({size_header} bytes)",
                ));
            }

            let header = (mapped_ptr as *const H).read();

            if munmap(mapped_ptr, size_header) != 0 {
                let err = io::Error::last_os_error();
                close(fd);
                return Err(anyhow::anyhow!("munmap failed for '{name}': {err}"));
            }

            // The producer advertises the size to map; it must cover the header and fit in the
            // backing object.
            let allocated_size = header.allocated_size();
            if allocated_size < size_header as u64 || allocated_size > object_size as u64 {
                close(fd);
                return Err(anyhow::anyhow!(
                    "Shared memory '{name}' allocated size {allocated_size} is outside \
                     [{size_header}..={object_size}]"
                ));
            }
            let allocated_size = allocated_size as usize;

            let mapped_ptr = mmap(ptr::null_mut(), allocated_size, PROT_READ, flags, fd, 0);

            if mapped_ptr == MAP_FAILED {
                let err = io::Error::last_os_error();
                close(fd);
                return Err(anyhow::anyhow!(
                    "mmap failed for '{name}': {err:?} ({size_header} bytes)",
                ));
            }

            Ok(Self {
                _fd: fd,
                mapped_ptr,
                mapped_size: allocated_size,
                shmem_name: name.to_string(),
                _phantom: std::marker::PhantomData::<H>,
            })
        }
    }

    pub fn unmap(&mut self) -> Result<()> {
        unsafe {
            if munmap(self.mapped_ptr, self.mapped_size) != 0 {
                tracing::error!("munmap failed: {:?}", io::Error::last_os_error());
                return Err(anyhow::anyhow!(
                    "munmap failed for '{}': {}",
                    self.shmem_name,
                    io::Error::last_os_error()
                ));
            }
            tracing::trace!("Unmapped shared memory '{}'", self.shmem_name);
        }
        self.mapped_ptr = ptr::null_mut();
        self.mapped_size = 0;

        Ok(())
    }

    pub fn map_header(&self) -> H {
        if !self.is_mapped() {
            panic!("Shared memory '{}' is not mapped, cannot read header", self.shmem_name);
        }

        unsafe { (self.mapped_ptr as *const H).read() }
    }

    pub fn is_mapped(&self) -> bool {
        !self.mapped_ptr.is_null()
    }

    pub fn header_ptr(&self) -> *mut c_void {
        self.mapped_ptr
    }

    pub fn mapped_ptr(&self) -> *mut c_void {
        self.mapped_ptr
    }

    pub fn data_ptr(&self) -> *mut c_void {
        // Skip the header size to get the data pointer
        unsafe { self.mapped_ptr.add(size_of::<H>()) }
    }

    /// Returns the mapped area after the header as whole `u64` words.
    pub fn data_words(&self) -> &[u64] {
        if !self.is_mapped() {
            return &[];
        }
        let len = (self.mapped_size - size_of::<H>()) / size_of::<u64>();
        // SAFETY: open_and_map only maps sizes that cover the header, so these words lie inside
        // the mapping, which stays alive while `self` is borrowed.
        unsafe { std::slice::from_raw_parts(self.data_ptr() as *const u64, len) }
    }
}

/// Returns the size in bytes of the shared memory object behind `fd`.
pub(crate) fn shmem_object_size(fd: i32) -> io::Result<usize> {
    let mut stat = MaybeUninit::<libc::stat>::uninit();
    if unsafe { fstat(fd, stat.as_mut_ptr()) } != 0 {
        return Err(io::Error::last_os_error());
    }
    // SAFETY: fstat succeeded, so it initialized `stat`.
    let size = unsafe { stat.assume_init() }.st_size;
    usize::try_from(size).map_err(|_| io::Error::new(io::ErrorKind::InvalidData, "invalid size"))
}

pub fn open_shmem(name: &str, flags: i32, mode: u32) -> Result<i32> {
    let c_name = CString::new(name)?;
    let fd = unsafe { shm_open(c_name.as_ptr(), flags, mode) };

    if fd == -1 {
        #[cfg(not(all(target_os = "linux", target_arch = "x86_64")))]
        {
            return Err(anyhow!(format!("shm_open('{name}') failed")));
        }

        #[cfg(all(target_os = "linux", target_arch = "x86_64"))]
        {
            let errno_value = unsafe { *libc::__errno_location() };
            let err = io::Error::from_raw_os_error(errno_value);
            let err2 = io::Error::last_os_error();
            return Err(anyhow!(format!(
                "shm_open('{name}') failed: libc::errno:{err} #### last_os_error:{err2}"
            )));
        }
    }

    Ok(fd)
}

#[cfg(all(target_os = "linux", target_arch = "x86_64"))]
pub fn map(fd: i32, size: usize, prot: i32, unlock_mapped_memory: bool, desc: &str) -> *mut c_void {
    let mut flags = MAP_SHARED;
    if !unlock_mapped_memory {
        flags |= libc::MAP_LOCKED;
    }
    let mapped = unsafe { mmap(ptr::null_mut(), size, prot, flags, fd, 0) };
    if mapped == MAP_FAILED {
        let err = io::Error::last_os_error();
        panic!("mmap failed for '{desc}': {err:?} ({size} bytes)");
    }
    mapped
}

#[cfg(not(all(target_os = "linux", target_arch = "x86_64")))]
pub fn map(_: i32, _: usize, _: i32, _: bool, _: &str) -> *mut c_void {
    ptr::null_mut()
}

/// Unmaps memory at the given raw pointer.
///
/// # Safety
/// The caller must ensure that:
/// - `ptr` was returned by a successful call to `mmap`,
/// - `size` matches the original mapped size,
/// - the region pointed to by `ptr` is not already unmapped.
pub unsafe fn unmap(ptr: *mut c_void, size: usize) {
    if munmap(ptr, size) != 0 {
        tracing::error!("munmap failed: {:?}", io::Error::last_os_error());
    }
}
