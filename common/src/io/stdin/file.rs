//! A file-based implementation of ZiskStdin.
//! This module provides functionality to read input data from a file.

use anyhow::Result;
use serde::{de::DeserializeOwned, Serialize};
use std::fs::File;
use std::io::{BufReader, Seek};
use std::path::{Path, PathBuf};
use std::sync::Mutex;
use zisk_core::MAX_INPUT_SIZE;

use super::read_padded_blob;
use crate::{io::ZiskIO, read_file_limited};

/// A file-based implementation of ZiskStdin that reads from a file.
pub struct ZiskFileStdin {
    /// The path to the input file.
    path: PathBuf,

    /// Buffered reader for the file.
    reader: Mutex<BufReader<File>>,
}

impl ZiskFileStdin {
    /// Create a new FileStdin from a file path.
    pub fn new<P: AsRef<Path>>(path: P) -> std::io::Result<Self> {
        let path_buf = path.as_ref().to_path_buf();
        if !path_buf.exists() {
            return Err(std::io::Error::new(
                std::io::ErrorKind::NotFound,
                format!("Input file not found at {:?}", path_buf.display()),
            ));
        }

        let file = File::open(&path_buf)?;
        Ok(ZiskFileStdin { path: path_buf, reader: Mutex::new(BufReader::new(file)) })
    }

    fn read_raw_data(&self) -> std::io::Result<Vec<u8>> {
        let mut reader = self.reader.lock().unwrap();
        let available =
            reader.get_ref().metadata()?.len().saturating_sub(reader.stream_position()?);
        read_padded_blob(&mut *reader, available)
    }
}

impl ZiskIO for ZiskFileStdin {
    fn read_raw_bytes(&self) -> Result<Vec<u8>> {
        // Raw inputs are loaded into the input memory region, so a larger file can never be used.
        read_file_limited(&self.path, MAX_INPUT_SIZE)
            .map_err(|e| anyhow::anyhow!("Could not read inputs file: {}", e))
    }

    fn read_bytes(&self) -> Result<Vec<u8>> {
        self.read_raw_data().map_err(|e| anyhow::anyhow!("Failed to read into buffer: {}", e))
    }

    fn read_slice(&self, slice: &mut [u8]) -> Result<()> {
        let data =
            self.read_raw_data().map_err(|e| anyhow::anyhow!("Failed to read slice: {}", e))?;
        if slice.len() != data.len() {
            anyhow::bail!("Slice length mismatch: expected {}, got {}", data.len(), slice.len());
        }
        slice.copy_from_slice(&data);
        Ok(())
    }

    fn read<T: DeserializeOwned>(&self) -> Result<T> {
        let data = self
            .read_raw_data()
            .map_err(|e| anyhow::anyhow!("Failed to read data from file: {}", e))?;

        bincode::deserialize(&data)
            .map_err(|e| anyhow::anyhow!("Failed to deserialize from file: {}", e))
    }

    fn write<T: Serialize>(&self, _data: &T) {
        // This is a read-only stdin implementation
        // Writing is not supported for file-based stdin
        panic!("Write operations are not supported for FileStdin");
    }

    fn write_slice(&self, _data: &[u8]) {
        // This is a read-only stdin implementation
        // Writing is not supported for file-based stdin
        panic!("Write operations are not supported for FileStdin");
    }

    fn write_proof(&self, _proof: &[u8]) {
        // This is a read-only stdin implementation
        // Writing is not supported for file-based stdin
        panic!("Write operations are not supported for FileStdin");
    }

    fn save(&self, _path: &Path) -> Result<()> {
        // This is a read-only stdin implementation
        // Saving is not supported for file-based stdin
        panic!("Save operations are not supported for FileStdin");
    }
}
