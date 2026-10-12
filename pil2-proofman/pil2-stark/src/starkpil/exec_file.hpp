#ifndef EXEC_FILE
#define EXEC_FILE

#include <iostream>
#include <fstream>
#include <sstream>
#include <iomanip>
#include <stdexcept>
#include <sys/stat.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>
#include "utils.hpp"

void readExecFile(uint64_t *exec_data, std::string execFile, uint64_t nCommitedPols) {
    uint64_t nAdds;
    uint64_t nSMap;

    std::ifstream file(execFile, std::ios::binary);
    if (!file.is_open()) {
        throw std::runtime_error("readExecFile() failed to open " + execFile);
    }
    if (!file.read(reinterpret_cast<char *>(&nAdds), sizeof(uint64_t)) ||
        !file.read(reinterpret_cast<char *>(&nSMap), sizeof(uint64_t))) {
        throw std::runtime_error("readExecFile() truncated header in " + execFile);
    }

    // The header sizes the rest of the file; bound each table before summing so the word count cannot wrap.
    constexpr uint64_t maxExecFileWords = (512ULL << 20) / sizeof(uint64_t);
    if (nAdds > maxExecFileWords / 4 || (nCommitedPols != 0 && nSMap > maxExecFileWords / nCommitedPols)) {
        throw std::runtime_error("readExecFile() file too large in " + execFile);
    }
    uint64_t totalWords = 2 + nAdds * 4 + nSMap * nCommitedPols;
    if (totalWords > maxExecFileWords) {
        throw std::runtime_error("readExecFile() file too large in " + execFile);
    }

    loadFileParallel(exec_data, execFile, totalWords * sizeof(uint64_t));
}

void getCommitedPols(Goldilocks::Element *circomWitness, uint64_t *exec_data, Goldilocks::Element *witness, Goldilocks::Element* publics, uint64_t sizeWitness, uint64_t N, uint64_t nPublics, uint64_t nCommitedPols)  {

    uint64_t nAdds = exec_data[0];
    uint64_t nSMap = exec_data[1];
    uint64_t *p_adds = &exec_data[2];
    uint64_t *p_sMap = &exec_data[2 + nAdds * 4];

    for(uint64_t i = 0; i < nPublics; ++i) {
        publics[i] = circomWitness[1 + i];
    }
        
    for (uint64_t i = 0; i < nAdds; i++) {
        uint64_t idx_1 = p_adds[i * 4];
        uint64_t idx_2 = p_adds[i * 4 + 1];

        Goldilocks::Element c = circomWitness[idx_1] * Goldilocks::fromU64(p_adds[i * 4 + 2]);
        Goldilocks::Element d = circomWitness[idx_2] * Goldilocks::fromU64(p_adds[i * 4 + 3]);
        circomWitness[sizeWitness + i] = c + d;
    }

    for (uint64_t i = 0; i < N; i++) {
        uint64_t rowOffset = nCommitedPols * i;
        for (uint64_t j = 0; j < nCommitedPols; j++) {
            uint64_t signal = i < nSMap ? p_sMap[rowOffset + j] : 0;
            witness[rowOffset + j] = signal != 0 ? circomWitness[signal] : Goldilocks::zero();
        }
    }
}

#endif
