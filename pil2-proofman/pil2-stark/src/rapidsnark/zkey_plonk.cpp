#include <stdexcept>
#include <memory.h>
#include <new>
#include <vector>

#include "zkey.hpp"
#include "zkey_plonk.hpp"

namespace Zkey {
    PlonkZkeyHeader::PlonkZkeyHeader() {
        this->protocolId = Zkey::PLONK_PROTOCOL_ID;
    }

    PlonkZkeyHeader::~PlonkZkeyHeader() {
        mpz_clear(qPrime);
        mpz_clear(rPrime);
    }

    PlonkZkeyHeader* PlonkZkeyHeader::loadPlonkZkeyHeader(BinFileUtils::BinFile *f) {
        auto plonkZkeyHeader = new PlonkZkeyHeader();

        f->startReadSection(Zkey::ZKEY_PL_HEADER_SECTION);

        plonkZkeyHeader->n8q = f->readU32LE();
        mpz_init(plonkZkeyHeader->qPrime);
        mpz_import(plonkZkeyHeader->qPrime, plonkZkeyHeader->n8q, -1, 1, -1, 0, f->read(plonkZkeyHeader->n8q));

        plonkZkeyHeader->n8r = f->readU32LE();
        mpz_init(plonkZkeyHeader->rPrime);
        mpz_import(plonkZkeyHeader->rPrime, plonkZkeyHeader->n8r, -1, 1, -1, 0, f->read(plonkZkeyHeader->n8r));

        plonkZkeyHeader->nVars = f->readU32LE();
        plonkZkeyHeader->nPublic = f->readU32LE();
        plonkZkeyHeader->domainSize = f->readU32LE();
        plonkZkeyHeader->nAdditions = f->readU32LE();
        plonkZkeyHeader->nConstraints = f->readU32LE();

        plonkZkeyHeader->k1 = f->read(plonkZkeyHeader->n8r);
        plonkZkeyHeader->k2 = f->read(plonkZkeyHeader->n8r);

        plonkZkeyHeader->QM = f->read(plonkZkeyHeader->n8q * 2);
        plonkZkeyHeader->QL = f->read(plonkZkeyHeader->n8q * 2);
        plonkZkeyHeader->QR = f->read(plonkZkeyHeader->n8q * 2);
        plonkZkeyHeader->QO = f->read(plonkZkeyHeader->n8q * 2);
        plonkZkeyHeader->QC = f->read(plonkZkeyHeader->n8q * 2);

        plonkZkeyHeader->S1 = f->read(plonkZkeyHeader->n8q * 2);
        plonkZkeyHeader->S2 = f->read(plonkZkeyHeader->n8q * 2);
        plonkZkeyHeader->S3 = f->read(plonkZkeyHeader->n8q * 2);

        plonkZkeyHeader->X2 = f->read(plonkZkeyHeader->n8q * 4);

        f->endReadSection();

        return plonkZkeyHeader;
    }

    PlonkZkeyHeader* PlonkZkeyHeader::loadPlonkZkeyHeaderDirect(BinFileUtils::BinFile *f) {
        auto plonkZkeyHeader = new PlonkZkeyHeader();

        // Read entire header section into a local buffer; every field below must lie inside it.
        u_int64_t sectionSize = f->getSectionSize(Zkey::ZKEY_PL_HEADER_SECTION);
        std::vector<uint8_t> buf(sectionSize);
        if (sectionSize > 0) {
            f->readSectionTo(buf.data(), Zkey::ZKEY_PL_HEADER_SECTION, 0, sectionSize);
        }

        u_int64_t off = 0;

        auto readBytes = [&](u_int64_t len) -> const uint8_t* {
            if (len > sectionSize - off) {
                throw std::runtime_error("truncated plonk zkey header");
            }
            const uint8_t *ptr = buf.data() + off;
            off += len;
            return ptr;
        };

        auto readUint32 = [&](u_int32_t &out) {
            memcpy(&out, readBytes(sizeof(u_int32_t)), sizeof(u_int32_t));
        };

        // Deep-copy small pointer fields; they own their memory.
        auto copyField = [&](u_int64_t len) -> void* {
            const uint8_t *src = readBytes(len);
            if (len == 0) {
                return nullptr;
            }
            void *copy = malloc(len);
            if (copy == nullptr) {
                throw std::bad_alloc();
            }
            memcpy(copy, src, len);
            return copy;
        };

        // Read fields in the same order as loadPlonkZkeyHeader.
        readUint32(plonkZkeyHeader->n8q);
        mpz_init(plonkZkeyHeader->qPrime);
        mpz_import(plonkZkeyHeader->qPrime, plonkZkeyHeader->n8q, -1, 1, -1, 0, readBytes(plonkZkeyHeader->n8q));

        readUint32(plonkZkeyHeader->n8r);
        mpz_init(plonkZkeyHeader->rPrime);
        mpz_import(plonkZkeyHeader->rPrime, plonkZkeyHeader->n8r, -1, 1, -1, 0, readBytes(plonkZkeyHeader->n8r));

        readUint32(plonkZkeyHeader->nVars);
        readUint32(plonkZkeyHeader->nPublic);
        readUint32(plonkZkeyHeader->domainSize);
        readUint32(plonkZkeyHeader->nAdditions);
        readUint32(plonkZkeyHeader->nConstraints);

        const u_int64_t n8q = plonkZkeyHeader->n8q;
        plonkZkeyHeader->k1 = copyField(plonkZkeyHeader->n8r);
        plonkZkeyHeader->k2 = copyField(plonkZkeyHeader->n8r);

        plonkZkeyHeader->QM = copyField(n8q * 2);
        plonkZkeyHeader->QL = copyField(n8q * 2);
        plonkZkeyHeader->QR = copyField(n8q * 2);
        plonkZkeyHeader->QO = copyField(n8q * 2);
        plonkZkeyHeader->QC = copyField(n8q * 2);

        plonkZkeyHeader->S1 = copyField(n8q * 2);
        plonkZkeyHeader->S2 = copyField(n8q * 2);
        plonkZkeyHeader->S3 = copyField(n8q * 2);

        plonkZkeyHeader->X2 = copyField(n8q * 4);

        return plonkZkeyHeader;
    }
}
