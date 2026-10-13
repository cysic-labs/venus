use core::panic;
use std::collections::HashMap;

use zisk_common::{CheckPoint, ChunkId, CollectCounter};

use crate::{
    DmaCheckPoint, DmaCollectCounters, DmaInstanceInfo, DMA_COUNTER_INPUTCPY, DMA_COUNTER_MEMCMP,
    DMA_COUNTER_MEMCPY, DMA_COUNTER_MEMSET,
};
#[derive(Debug)]
pub struct DmaInstancesBuilder {
    pub tag: String,
    pub current_chunk: Option<ChunkId>,
    pub max_instances: usize,
    pub rows: usize,
    pub rows_available: usize,
    pub instances: Vec<DmaInstanceInfo>,
    pub count_memcpy_rows: usize,
    pub count_memset_rows: usize,
    pub count_memcmp_rows: usize,
    pub count_inputcpy_rows: usize,
    pub skip_memcpy_rows: usize,
    pub skip_memset_rows: usize,
    pub skip_memcmp_rows: usize,
    pub skip_inputcpy_rows: usize,
    pub count_inputs: usize,
}

impl DmaInstancesBuilder {
    pub fn new(tag: &str, max_instances: usize, rows: usize) -> Self {
        Self {
            tag: tag.to_string(),
            current_chunk: None,
            max_instances,
            rows,
            rows_available: 0,
            instances: Vec::new(),
            skip_memcpy_rows: 0,
            skip_memset_rows: 0,
            skip_memcmp_rows: 0,
            skip_inputcpy_rows: 0,
            count_memcpy_rows: 0,
            count_memset_rows: 0,
            count_memcmp_rows: 0,
            count_inputcpy_rows: 0,
            count_inputs: 0,
        }
    }
    pub fn count_to_skip(&mut self) {
        self.skip_memcpy_rows += self.count_memcpy_rows;
        self.skip_memset_rows += self.count_memset_rows;
        self.skip_memcmp_rows += self.count_memcmp_rows;
        self.skip_inputcpy_rows += self.count_inputcpy_rows;
        self.count_memcpy_rows = 0;
        self.count_memset_rows = 0;
        self.count_memcmp_rows = 0;
        self.count_inputcpy_rows = 0;
        self.count_inputs = 0;
    }
    pub fn reset_count_and_skip(&mut self) {
        self.skip_memcpy_rows = 0;
        self.skip_memset_rows = 0;
        self.skip_memcmp_rows = 0;
        self.skip_inputcpy_rows = 0;
        self.count_memcpy_rows = 0;
        self.count_memset_rows = 0;
        self.count_memcmp_rows = 0;
        self.count_inputcpy_rows = 0;
        self.count_inputs = 0;
    }

    pub fn open_new_instance(&mut self) {
        if self.rows_available > 0 {
            panic!(
                "[{}] Cannot open new instance, rows still available: {}",
                self.tag, self.rows_available
            );
        }
        if self.instances.len() >= self.max_instances {
            println!("{:?}", self);
            panic!(
                "[{}] Too many instances {} max: {}, cannot create more",
                self.tag,
                self.instances.len(),
                self.max_instances
            );
        }
        self.instances.push(DmaInstanceInfo { chunks: HashMap::new(), last_chunk: None });
        self.rows_available = self.rows;
    }
    pub fn flush_current_chunk(&mut self) {
        if let Some(chunk_id) = self.current_chunk {
            if self.count_memcpy_rows == 0
                && self.count_inputcpy_rows == 0
                && self.count_memset_rows == 0
                && self.count_memcmp_rows == 0
            {
                return;
            }
            if self.instances.is_empty() {
                self.open_new_instance();
            }
            let collect_counters = DmaCollectCounters {
                memcpy: CollectCounter::new(
                    self.skip_memcpy_rows as u32,
                    self.count_memcpy_rows as u32,
                ),
                inputcpy: CollectCounter::new(
                    self.skip_inputcpy_rows as u32,
                    self.count_inputcpy_rows as u32,
                ),
                memset: CollectCounter::new(
                    self.skip_memset_rows as u32,
                    self.count_memset_rows as u32,
                ),
                memcmp: CollectCounter::new(
                    self.skip_memcmp_rows as u32,
                    self.count_memcmp_rows as u32,
                ),
            };
            self.instances
                .last_mut()
                .unwrap()
                .chunks
                .insert(chunk_id, (self.count_inputs as u64, collect_counters));
            self.instances.last_mut().unwrap().last_chunk = Some(chunk_id);
        }
    }
    #[inline(always)]
    pub fn add_memcpy_rows(&mut self, chunk_id: ChunkId, skip: usize, rows: usize, inputs: usize) {
        self.add_op_rows(chunk_id, skip, rows, inputs, DMA_COUNTER_MEMCPY);
    }
    #[inline(always)]
    pub fn add_memset_rows(&mut self, chunk_id: ChunkId, skip: usize, rows: usize, inputs: usize) {
        self.add_op_rows(chunk_id, skip, rows, inputs, DMA_COUNTER_MEMSET);
    }
    #[inline(always)]
    pub fn add_memcmp_rows(&mut self, chunk_id: ChunkId, skip: usize, rows: usize, inputs: usize) {
        self.add_op_rows(chunk_id, skip, rows, inputs, DMA_COUNTER_MEMCMP);
    }
    #[inline(always)]
    pub fn add_inputcpy_rows(
        &mut self,
        chunk_id: ChunkId,
        skip: usize,
        rows: usize,
        inputs: usize,
    ) {
        self.add_op_rows(chunk_id, skip, rows, inputs, DMA_COUNTER_INPUTCPY);
    }

    pub fn add_op_rows(
        &mut self,
        chunk_id: ChunkId,
        skip: usize,
        rows: usize,
        inputs: usize,
        op: usize,
    ) {
        if Some(chunk_id) != self.current_chunk {
            self.flush_current_chunk();
            self.reset_count_and_skip();
            self.current_chunk = Some(chunk_id);
        }
        let mut rows = rows;
        let mut initial_skip = skip;
        while rows > 0 {
            if self.rows_available == 0 {
                self.flush_current_chunk();
                self.count_to_skip();
                self.open_new_instance();
            }
            let rows_applicable = std::cmp::min(self.rows_available, rows);
            let inputs_applicable = std::cmp::min(inputs, rows_applicable);
            let segment_skip = initial_skip;
            initial_skip = 0;
            rows -= rows_applicable;
            self.rows_available -= rows_applicable;
            match op {
                DMA_COUNTER_MEMCPY => {
                    if segment_skip > 0 {
                        assert!(
                            self.count_memcpy_rows == 0,
                            "Cannot have both skip and count for memcpy in the same chunk",
                        );
                        self.skip_memcpy_rows += segment_skip;
                    }
                    self.count_memcpy_rows += rows_applicable;
                }
                DMA_COUNTER_MEMSET => {
                    if segment_skip > 0 {
                        assert!(
                            self.count_memset_rows == 0,
                            "Cannot have both skip and count for memset in the same chunk",
                        );
                        self.skip_memset_rows += segment_skip;
                    }
                    self.count_memset_rows += rows_applicable;
                }
                DMA_COUNTER_MEMCMP => {
                    if segment_skip > 0 {
                        assert!(
                            self.count_memcmp_rows == 0,
                            "Cannot have both skip and count for memcmp in the same chunk",
                        );
                        self.skip_memcmp_rows += segment_skip;
                    }
                    self.count_memcmp_rows += rows_applicable;
                }
                DMA_COUNTER_INPUTCPY => {
                    if segment_skip > 0 {
                        assert!(
                            self.count_inputcpy_rows == 0,
                            "Cannot have both skip and count for inputcpy in the same chunk",
                        );
                        self.skip_inputcpy_rows += segment_skip;
                    }
                    self.count_inputcpy_rows += rows_applicable;
                }
                _ => {
                    panic!("Unsupported operation for DMA instance builder 0x{op:02X}")
                }
            }
            self.count_inputs += inputs_applicable;
        }
    }
    pub fn flush(&mut self) {
        self.flush_current_chunk();
        self.reset_count_and_skip();
        self.current_chunk = None;
    }
    pub fn get_plan(&mut self) -> Vec<(CheckPoint, DmaCheckPoint)> {
        self.flush();
        let mut checkpoints = Vec::new();
        let last_segment_id = self.instances.len().saturating_sub(1);
        for (segment_id, dma_info) in self.instances.iter_mut().enumerate() {
            let keys = dma_info.chunks.keys().cloned().collect::<Vec<_>>();

            checkpoints.push((
                CheckPoint::Multiple(keys),
                DmaCheckPoint {
                    chunks: std::mem::take(&mut dma_info.chunks),
                    last_chunk: dma_info.last_chunk,
                    is_last_segment: segment_id == last_segment_id,
                },
            ));
        }
        checkpoints
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn chunk(id: usize) -> ChunkId {
        ChunkId(id)
    }

    fn only_chunk_inputs(checkpoint: &DmaCheckPoint, chunk_id: ChunkId) -> u64 {
        checkpoint.chunks.get(&chunk_id).unwrap().0
    }

    fn only_chunk_counters(checkpoint: &DmaCheckPoint, chunk_id: ChunkId) -> DmaCollectCounters {
        checkpoint.chunks.get(&chunk_id).unwrap().1
    }

    #[test]
    fn input_reservations_reset_between_chunks() {
        let mut builder = DmaInstancesBuilder::new("test", 1, 8);

        builder.add_op_rows(chunk(1), 0, 2, 2, DMA_COUNTER_MEMCPY);
        builder.add_op_rows(chunk(2), 0, 2, 2, DMA_COUNTER_MEMCPY);

        let plan = builder.get_plan();
        assert_eq!(plan.len(), 1);
        assert_eq!(only_chunk_inputs(&plan[0].1, chunk(1)), 2);
        assert_eq!(only_chunk_inputs(&plan[0].1, chunk(2)), 2);
    }

    #[test]
    fn row_sized_inputs_are_split_per_instance() {
        let mut builder = DmaInstancesBuilder::new("test", 3, 4);

        builder.add_op_rows(chunk(7), 0, 10, 10, DMA_COUNTER_MEMCPY);

        let plan = builder.get_plan();
        assert_eq!(plan.len(), 3);
        assert_eq!(only_chunk_inputs(&plan[0].1, chunk(7)), 4);
        assert_eq!(only_chunk_inputs(&plan[1].1, chunk(7)), 4);
        assert_eq!(only_chunk_inputs(&plan[2].1, chunk(7)), 2);
    }

    #[test]
    fn long_input_split_across_instances_reserves_each_segment() {
        let mut builder = DmaInstancesBuilder::new("test", 3, 4);

        builder.add_op_rows(chunk(7), 0, 10, 1, DMA_COUNTER_MEMCPY);

        let plan = builder.get_plan();
        assert_eq!(plan.len(), 3);
        assert_eq!(only_chunk_inputs(&plan[0].1, chunk(7)), 1);
        assert_eq!(only_chunk_inputs(&plan[1].1, chunk(7)), 1);
        assert_eq!(only_chunk_inputs(&plan[2].1, chunk(7)), 1);
    }

    #[test]
    fn initial_skip_is_applied_once_when_rows_split() {
        let mut builder = DmaInstancesBuilder::new("test", 3, 4);

        builder.add_op_rows(chunk(7), 2, 10, 10, DMA_COUNTER_MEMCPY);

        let plan = builder.get_plan();
        assert_eq!(plan.len(), 3);

        let first = only_chunk_counters(&plan[0].1, chunk(7)).memcpy;
        assert_eq!(first.initial_skip, 2);
        assert_eq!(first.collect_count, 4);
        assert_eq!(only_chunk_inputs(&plan[0].1, chunk(7)), 4);

        let second = only_chunk_counters(&plan[1].1, chunk(7)).memcpy;
        assert_eq!(second.initial_skip, 6);
        assert_eq!(second.collect_count, 4);
        assert_eq!(only_chunk_inputs(&plan[1].1, chunk(7)), 4);

        let third = only_chunk_counters(&plan[2].1, chunk(7)).memcpy;
        assert_eq!(third.initial_skip, 10);
        assert_eq!(third.collect_count, 2);
        assert_eq!(only_chunk_inputs(&plan[2].1, chunk(7)), 2);
    }
}
