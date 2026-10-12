#ifndef PACKED_LAYOUT_HPP
#define PACKED_LAYOUT_HPP

#include <cstdint>
#include <stdexcept>
#include <string>

static constexpr uint64_t MAX_PACKED_COLUMNS = 1ULL << 20;

// Checks that a bit-packed row layout is well formed before any row is unpacked with it: every
// column is 1..64 bits wide and wordsPerRow is exactly the number of 64-bit words those widths
// need. The unpack kernels rely on this to stay inside each packed row.
inline void validatePackedLayout(
    const char *context,
    uint64_t nCols,
    uint64_t wordsPerRow,
    const uint64_t *unpackInfo)
{
    if (nCols == 0) {
        if (wordsPerRow != 0) {
            throw std::runtime_error(std::string(context) + ": packed layout has words for zero columns");
        }
        return;
    }
    if (nCols > MAX_PACKED_COLUMNS) {
        throw std::runtime_error(std::string(context) + ": packed column count exceeds safety limit");
    }
    if (unpackInfo == nullptr) {
        throw std::runtime_error(std::string(context) + ": missing packed layout metadata");
    }

    uint64_t totalBits = 0;
    for (uint64_t i = 0; i < nCols; ++i) {
        uint64_t nbits = unpackInfo[i];
        if (nbits == 0 || nbits > 64) {
            throw std::runtime_error(std::string(context) + ": packed column width outside 1..64 bits");
        }
        totalBits += nbits;
    }

    if (wordsPerRow != (totalBits + 63) / 64) {
        throw std::runtime_error(std::string(context) + ": packed words per row does not match column widths");
    }
}

#endif
