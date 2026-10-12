#include "expressions_bin.hpp"
#include <set>

namespace {

// Expressions bins are setup files. Their counts size the host and device copies made at load time,
// and the CPU and GPU evaluators index those copies, their temporaries and the trace buffers with the
// spans and arguments of each expression without further checks, so the loaders and
// validateAgainstStarkInfo bound all of them once.
constexpr uint64_t MAX_BIN_ITEMS = 1ULL << 24;
constexpr uint64_t MAX_BIN_ENTRIES = 1ULL << 20;
constexpr uint64_t MAX_BIN_STRING_BYTES = 1ULL << 24;
constexpr uint64_t REGULAR_ARGS_PER_OP = 8;
constexpr uint64_t GLOBAL_ARGS_PER_OP = 6;
constexpr uint8_t MAX_OPCODE = 2;
constexpr uint16_t MAX_ARITH_OP = 3;

[[noreturn]] void failInvalidExpressionBin(const std::string& message) {
    zklog.error("Invalid expressions bin metadata: " + message);
    exitProcess();
    exit(-1);
}

void requireRange(uint64_t offset, uint64_t width, uint64_t total, const std::string& label) {
    if(width > total || offset > total - width) {
        failInvalidExpressionBin(label + " is out of range");
    }
}

void requireCountAtMost(uint64_t count, uint64_t maxCount, const std::string& label) {
    if(count > maxCount) {
        failInvalidExpressionBin(label + " exceeds limit");
    }
}

void addCheckedCount(uint64_t& total, uint64_t count, uint64_t maxCount, const std::string& label) {
    if(count > maxCount || total > maxCount - count) {
        failInvalidExpressionBin(label + " exceeds limit");
    }
    total += count;
}

std::string readLimitedString(BinFileUtils::BinFile *binFile, const std::string& label) {
    std::string value = binFile->readString();
    requireCountAtMost(value.size(), MAX_BIN_STRING_BYTES, label + " string size");
    return value;
}

// The evaluators walk nOps opcodes from opsOffset and argsPerOp args per op from argsOffset, and
// size their temporaries from the maxima the file declares.
void validateParserParamsSpan(
    const ParserParams& parserParams,
    const ParserArgs& parserArgs,
    uint64_t nOpsTotal,
    uint64_t nArgsTotal,
    uint64_t argsPerOp,
    uint64_t maxTmp1,
    uint64_t maxTmp3,
    uint64_t maxArgs,
    uint64_t maxOps,
    const std::string& label
) {
    requireRange(parserParams.opsOffset, parserParams.nOps, nOpsTotal, label + " op span");
    requireRange(parserParams.argsOffset, parserParams.nArgs, nArgsTotal, label + " arg span");
    if(uint64_t(parserParams.nArgs) != uint64_t(parserParams.nOps) * argsPerOp) {
        failInvalidExpressionBin(label + " arg count does not match op count");
    }
    requireCountAtMost(parserParams.nTemp1, maxTmp1, label + " tmp1 count");
    requireCountAtMost(parserParams.nTemp3, maxTmp3, label + " tmp3 count");
    requireCountAtMost(parserParams.nArgs, maxArgs, label + " arg count");
    requireCountAtMost(parserParams.nOps, maxOps, label + " op count");

    for(uint64_t i = 0; i < parserParams.nOps; ++i) {
        if(parserArgs.ops[uint64_t(parserParams.opsOffset) + i] > MAX_OPCODE) {
            failInvalidExpressionBin(label + " contains an invalid opcode");
        }
    }
}

uint64_t requireMapSectionCols(const StarkInfo& starkInfo, const std::string& key, const std::string& label) {
    auto it = starkInfo.mapSectionsN.find(key);
    if(it == starkInfo.mapSectionsN.end()) {
        failInvalidExpressionBin(label + " references missing section " + key);
    }
    return it->second;
}

// Hint values name polynomials, expressions and values by index; StarkInfo already bounds the
// columns each polynomial map entry spans.
void validateRegularHintValue(
    const HintFieldValue& hintFieldVal,
    const StarkInfo& starkInfo,
    const std::map<uint64_t, ParserParams>& expressionsInfo,
    const std::string& label
) {
    if(hintFieldVal.operand == opType::cm) {
        requireRange(hintFieldVal.id, 1, starkInfo.cmPolsMap.size(), label + " committed polynomial");
        requireRange(hintFieldVal.rowOffsetIndex, 1, starkInfo.openingPoints.size(), label + " opening point");
    } else if(hintFieldVal.operand == opType::custom) {
        requireRange(hintFieldVal.commitId, 1, starkInfo.customCommitsMap.size(), label + " custom commit");
        requireRange(hintFieldVal.id, 1, starkInfo.customCommitsMap[hintFieldVal.commitId].size(), label + " custom polynomial");
        requireRange(hintFieldVal.rowOffsetIndex, 1, starkInfo.openingPoints.size(), label + " opening point");
    } else if(hintFieldVal.operand == opType::const_) {
        requireRange(hintFieldVal.id, 1, starkInfo.constPolsMap.size(), label + " fixed polynomial");
        requireRange(hintFieldVal.rowOffsetIndex, 1, starkInfo.openingPoints.size(), label + " opening point");
    } else if(hintFieldVal.operand == opType::tmp) {
        auto it = expressionsInfo.find(hintFieldVal.id);
        if(it == expressionsInfo.end()) {
            failInvalidExpressionBin(label + " references an unknown expression");
        }
        if(hintFieldVal.dim != 0 && hintFieldVal.dim != it->second.destDim) {
            failInvalidExpressionBin(label + " expression dimension does not match metadata");
        }
    } else if(hintFieldVal.operand == opType::public_) {
        requireRange(hintFieldVal.id, 1, starkInfo.nPublics, label + " public input");
        requireRange(hintFieldVal.id, 1, starkInfo.publicsMap.size(), label + " public metadata");
    } else if(hintFieldVal.operand == opType::proofvalue) {
        requireRange(hintFieldVal.id, 1, starkInfo.proofValuesMap.size(), label + " proof value");
    } else if(hintFieldVal.operand == opType::airgroupvalue) {
        requireRange(hintFieldVal.id, 1, starkInfo.airgroupValuesMap.size(), label + " airgroup value");
    } else if(hintFieldVal.operand == opType::airvalue) {
        requireRange(hintFieldVal.id, 1, starkInfo.airValuesMap.size(), label + " air value");
    } else if(hintFieldVal.operand == opType::challenge) {
        requireRange(hintFieldVal.id, 1, starkInfo.challengesMap.size(), label + " challenge");
    } else if(hintFieldVal.operand != opType::number && hintFieldVal.operand != opType::string_) {
        failInvalidExpressionBin(label + " has unsupported regular hint operand");
    }
}

// Hint lookups take the first field with a given name, so names must be unique within a hint.
void validateRegularHints(const std::vector<Hint>& hints, const StarkInfo& starkInfo, const std::map<uint64_t, ParserParams>& expressionsInfo) {
    for(uint64_t h = 0; h < hints.size(); ++h) {
        std::set<std::string> seenFields;
        for(const HintField& hintField : hints[h].fields) {
            if(!seenFields.insert(hintField.name).second) {
                failInvalidExpressionBin("hint " + to_string(h) + " has duplicate field " + hintField.name);
            }
            for(uint64_t v = 0; v < hintField.values.size(); ++v) {
                validateRegularHintValue(
                    hintField.values[v],
                    starkInfo,
                    expressionsInfo,
                    "hint " + to_string(h) + " field " + hintField.name + " value " + to_string(v)
                );
            }
        }
    }
}

// Mirrors the operand decoding of the expression evaluators: fixed columns, committed stages,
// zerofiers, xDivXSubXi, custom commits, then tmp1, tmp3, publics, numbers, air values, proof
// values, airgroup values, challenges and evals after the commit buffers.
void validateRegularSource(
    const ParserParams& parserParams,
    const ParserArgs& parserArgs,
    const StarkInfo& starkInfo,
    uint64_t iArgs,
    uint64_t sourceDim,
    const std::string& label
) {
    const uint16_t* args = parserArgs.args;
    uint64_t type = args[iArgs];
    uint64_t index = args[iArgs + 1];
    uint64_t rowOffsetIndex = args[iArgs + 2];
    uint64_t nStages = starkInfo.nStages;
    uint64_t bufferCommitsSize = 1 + nStages + 3 + starkInfo.customCommits.size();

    if(type == 0) {
        if(sourceDim != 1) {
            failInvalidExpressionBin(label + " loads a fixed polynomial as an extension value");
        }
        uint64_t nConstCols = requireMapSectionCols(starkInfo, "const", label);
        requireRange(index, 1, std::min(starkInfo.nConstants, nConstCols), label + " fixed column");
        requireRange(rowOffsetIndex, 1, starkInfo.openingPoints.size(), label + " opening point");
    } else if(type <= nStages + 1) {
        uint64_t nCols = requireMapSectionCols(starkInfo, "cm" + to_string(type), label);
        requireRange(index, sourceDim, nCols, label + " committed column");
        requireRange(rowOffsetIndex, 1, starkInfo.openingPoints.size(), label + " opening point");
    } else if(type == nStages + 2) {
        if(!starkInfo.verify && sourceDim != 1) {
            failInvalidExpressionBin(label + " loads a zerofier as an extension value outside verifier mode");
        }
        requireRange(index, 1, starkInfo.boundaries.size() + 1, label + " boundary");
    } else if(type == nStages + 3) {
        if(sourceDim != FIELD_EXTENSION) {
            failInvalidExpressionBin(label + " loads xDivXSubXi as a scalar");
        }
        requireRange(index, 1, starkInfo.openingPoints.size(), label + " xDivXSubXi opening point");
    } else if(type < bufferCommitsSize) {
        if(sourceDim != 1) {
            failInvalidExpressionBin(label + " loads a custom fixed column as an extension value");
        }
        const std::string key = starkInfo.customCommits[type - (nStages + 4)].name + "0";
        requireRange(index, 1, requireMapSectionCols(starkInfo, key, label), label + " custom fixed column");
        requireRange(rowOffsetIndex, 1, starkInfo.openingPoints.size(), label + " opening point");
    } else if(type == bufferCommitsSize) {
        if(sourceDim != 1) {
            failInvalidExpressionBin(label + " loads tmp1 as an extension value");
        }
        requireRange(index, 1, parserParams.nTemp1, label + " tmp1 source");
    } else if(type == bufferCommitsSize + 1) {
        requireRange(index, sourceDim, uint64_t(parserParams.nTemp3) * FIELD_EXTENSION, label + " tmp3 source");
    } else if(type == bufferCommitsSize + 2) {
        requireRange(index, sourceDim, starkInfo.nPublics, label + " public input");
    } else if(type == bufferCommitsSize + 3) {
        requireRange(index, sourceDim, parserArgs.nNumbers, label + " number");
    } else if(type == bufferCommitsSize + 4) {
        requireRange(index, sourceDim, starkInfo.airValuesSize, label + " air value");
    } else if(type == bufferCommitsSize + 5) {
        requireRange(index, sourceDim, starkInfo.proofValuesSize, label + " proof value");
    } else if(type == bufferCommitsSize + 6) {
        requireRange(index, sourceDim, starkInfo.airgroupValuesSize, label + " airgroup value");
    } else if(type == bufferCommitsSize + 7) {
        // The verifier appends the FRI folding challenges and the grinding challenge.
        uint64_t nChallenges = starkInfo.challengesMap.size() + (starkInfo.verify ? starkInfo.starkStruct.steps.size() + 1 : 0);
        requireRange(index, sourceDim, nChallenges * FIELD_EXTENSION, label + " challenge");
    } else if(type == bufferCommitsSize + 8) {
        requireRange(index, sourceDim, starkInfo.evMap.size() * FIELD_EXTENSION, label + " eval");
    } else {
        failInvalidExpressionBin(label + " references an unknown source type");
    }
}

// Opcode 0 combines two scalars into tmp1, opcode 1 an extension and a scalar into tmp3 and opcode 2
// two extensions into tmp3; the last op writes the expression result instead of a temporary.
void validateRegularParserParams(
    const ParserParams& parserParams,
    const ParserArgs& parserArgs,
    const StarkInfo& starkInfo,
    const std::string& label
) {
    const uint8_t* ops = parserArgs.ops;
    const uint16_t* args = parserArgs.args;

    for(uint64_t kk = 0; kk < parserParams.nOps; ++kk) {
        uint64_t argOffset = uint64_t(parserParams.argsOffset) + kk * REGULAR_ARGS_PER_OP;
        uint8_t op = ops[uint64_t(parserParams.opsOffset) + kk];
        std::string opLabel = label + " op " + to_string(kk);

        if(args[argOffset] > MAX_ARITH_OP) {
            failInvalidExpressionBin(opLabel + " has an invalid arithmetic operation");
        }

        bool lastOp = kk + 1 == parserParams.nOps;
        if(op == 0) {
            if(!lastOp) requireRange(args[argOffset + 1], 1, parserParams.nTemp1, opLabel + " tmp1 destination");
        } else {
            if(!lastOp) requireRange(args[argOffset + 1], FIELD_EXTENSION, uint64_t(parserParams.nTemp3) * FIELD_EXTENSION, opLabel + " tmp3 destination");
        }
        validateRegularSource(parserParams, parserArgs, starkInfo, argOffset + 2, op == 0 ? 1 : FIELD_EXTENSION, opLabel + " source 0");
        validateRegularSource(parserParams, parserArgs, starkInfo, argOffset + 5, op == 2 ? FIELD_EXTENSION : 1, opLabel + " source 1");
    }
}

}

ExpressionsBin::ExpressionsBin(string file, bool globalBin, bool verifierBin) {
    std::unique_ptr<BinFileUtils::BinFile> binFile = BinFileUtils::openExisting(file, "chps", 1);

    if(globalBin) {
        loadGlobalBin(binFile.get());
    } else if(verifierBin) {
        loadVerifierBin(binFile.get());
    } else {
        loadExpressionsBin(binFile.get());
    }
}

ExpressionsBin::ExpressionsBin(string starkInfoFile, string expressionsInfoFile, string expressionsBinFile, bool globalBin, bool verifierBin) {
    write = true;
    if(globalBin) {
        ExpressionsInfo expsInfo(expressionsInfoFile);
        writeGlobalExpressionsBin(expressionsBinFile, expsInfo);
    } else if(verifierBin) {
        ExpressionsInfo expsInfo(starkInfoFile, expressionsInfoFile, true);
        writeVerifierBin(expressionsBinFile, expsInfo);
    } else {
        ExpressionsInfo expsInfo(starkInfoFile, expressionsInfoFile);
        writeExpressionsBin(expressionsBinFile, expsInfo);
    }
};

void ExpressionsBin::writeGlobalExpressionsBin(string binFile, ExpressionsInfo& expsInfo) {
    BinFileUtils::BinFileWriter fdBinFile(binFile, "chps", 1, N_GLOBAL_SECTIONS);

    // Write ConstraintsSection
    writeGlobalConstraintsSection(fdBinFile, GLOBAL_CONSTRAINTS_SECTION, expsInfo.constraintsInfo, expsInfo.numbersConstraints);

    // Write HintsSection
    writeGlobalHintsSection(fdBinFile, GLOBAL_HINTS_SECTION, expsInfo.hintsInfo);
}


void ExpressionsBin::writeExpressionsBin(string binFile, ExpressionsInfo& expsInfo) {
    BinFileUtils::BinFileWriter fdBinFile(binFile, "chps", 1, N_SECTIONS);

    // Write ExpressionsSection
    writeExpressionsSection(fdBinFile, EXPRESSIONS_SECTION, expsInfo.expressionsInfo, expsInfo.numbersExps, expsInfo.maxTmp1, expsInfo.maxTmp3, expsInfo.maxArgs, expsInfo.maxOps);
    
    // Write ConstraintsSection
    writeConstraintsSection(fdBinFile, CONSTRAINTS_SECTION, expsInfo.constraintsInfo, expsInfo.numbersConstraints);

    // Write HintsSection
    writeHintsSection(fdBinFile, HINTS_SECTION, expsInfo.hintsInfo);
}

void ExpressionsBin::writeVerifierBin(string binFile, ExpressionsInfo& expsInfo) {
    BinFileUtils::BinFileWriter fdBinFile(binFile, "chps", 1, 1);

    // Write ExpressionsSection
    writeExpressionsSection(fdBinFile, EXPRESSIONS_SECTION, expsInfo.expressionsInfo, expsInfo.numbersExps, expsInfo.maxTmp1, expsInfo.maxTmp3, expsInfo.maxArgs, expsInfo.maxOps);
}

void ExpressionsBin::writeExpressionsSection(BinFileUtils::BinFileWriter &binFile, int section, std::vector<ExpInfoBin> expressionsInfo, std::vector<uint64_t> numbersExps, uint64_t maxTmp1, uint64_t maxTmp3, uint64_t maxArgs, uint64_t maxOps) {
    binFile.startWriteSection(section);

    std::vector<uint8_t> opsExpressions;
    std::vector<uint16_t> argsExpressions;

    std::vector<uint32_t> opsExpressionsOffset, argsExpressionsOffset;

    for (uint64_t i = 0; i < expressionsInfo.size(); ++i) {
        if (i == 0) {
            opsExpressionsOffset.push_back(0);
            argsExpressionsOffset.push_back(0);
        } else {
            opsExpressionsOffset.push_back(opsExpressionsOffset[i - 1] + expressionsInfo[i - 1].ops.size());
            argsExpressionsOffset.push_back(argsExpressionsOffset[i - 1] + expressionsInfo[i - 1].args.size());
        }

        opsExpressions.insert(opsExpressions.end(), expressionsInfo[i].ops.begin(), expressionsInfo[i].ops.end());
        argsExpressions.insert(argsExpressions.end(), expressionsInfo[i].args.begin(), expressionsInfo[i].args.end());
    }

    binFile.writeU32LE(maxTmp1);
    binFile.writeU32LE(maxTmp3);
    binFile.writeU32LE(maxArgs);
    binFile.writeU32LE(maxOps);
    binFile.writeU32LE(opsExpressions.size());
    binFile.writeU32LE(argsExpressions.size());
    binFile.writeU32LE(numbersExps.size());

    uint64_t nExpressions = expressionsInfo.size();

    binFile.writeU32LE(nExpressions);

    for (uint64_t i = 0; i < nExpressions; ++i) {
        const ExpInfoBin& expInfo = expressionsInfo[i];
        
        // Write expression metadata
        binFile.writeU32LE(expInfo.expId);
        binFile.writeU32LE(expInfo.destDim);
        binFile.writeU32LE(expInfo.destId);
        binFile.writeU32LE(expInfo.stage);
        binFile.writeU32LE(expInfo.nTemp1);
        binFile.writeU32LE(expInfo.nTemp3);

        // Write ops information
        binFile.writeU32LE(expInfo.ops.size());
        binFile.writeU32LE(opsExpressionsOffset[i]);

        // Write args information
        binFile.writeU32LE(expInfo.args.size());
        binFile.writeU32LE(argsExpressionsOffset[i]);

        // Write the line string
        binFile.writeString(expInfo.line);
    }

    for(uint64_t j = 0; j < opsExpressions.size(); ++j) {
        binFile.writeU8LE(opsExpressions[j]);
    }

    for(uint64_t j = 0; j < argsExpressions.size(); ++j) {
        binFile.writeU16LE(argsExpressions[j]);
    }

    for(uint64_t j = 0; j < numbersExps.size(); ++j) {
        binFile.writeU64LE(numbersExps[j]);
    }

    binFile.endWriteSection();
}

void ExpressionsBin::writeConstraintsSection(BinFileUtils::BinFileWriter &binFile, int section, std::vector<ExpInfoBin> constraintsInfo, std::vector<uint64_t> numbersConstraints) {
    
    binFile.startWriteSection(section);

    std::vector<uint8_t> opsDebug;
    std::vector<uint16_t> argsDebug;
   
    std::vector<uint32_t> opsDebugOffset, argsDebugOffset;
   
    for (uint64_t i = 0; i < constraintsInfo.size(); ++i) {
        if (i == 0) {
            opsDebugOffset.push_back(0);
            argsDebugOffset.push_back(0);
        } else {
            opsDebugOffset.push_back(opsDebugOffset[i - 1] + constraintsInfo[i - 1].ops.size());
            argsDebugOffset.push_back(argsDebugOffset[i - 1] + constraintsInfo[i - 1].args.size());
        }

        opsDebug.insert(opsDebug.end(), constraintsInfo[i].ops.begin(), constraintsInfo[i].ops.end());
        argsDebug.insert(argsDebug.end(), constraintsInfo[i].args.begin(), constraintsInfo[i].args.end());
    }

    binFile.writeU32LE(opsDebug.size());
    binFile.writeU32LE(argsDebug.size());
    binFile.writeU32LE(numbersConstraints.size());

    uint64_t nConstraints = constraintsInfo.size();

    binFile.writeU32LE(nConstraints);

    for (uint64_t i = 0; i < nConstraints; ++i) {
        const ExpInfoBin& constraintInfo = constraintsInfo[i];
        
        // Write expression metadata
        binFile.writeU32LE(constraintInfo.stage);
        binFile.writeU32LE(constraintInfo.destDim);
        binFile.writeU32LE(constraintInfo.destId);
        binFile.writeU32LE(constraintInfo.firstRow);
        binFile.writeU32LE(constraintInfo.lastRow);
        binFile.writeU32LE(constraintInfo.nTemp1);
        binFile.writeU32LE(constraintInfo.nTemp3);

        // Write ops information
        binFile.writeU32LE(constraintInfo.ops.size());
        binFile.writeU32LE(opsDebugOffset[i]);

        // Write args information
        binFile.writeU32LE(constraintInfo.args.size());
        binFile.writeU32LE(argsDebugOffset[i]);

        binFile.writeU32LE(constraintInfo.imPol);

        // Write the line string
        binFile.writeString(constraintInfo.line);
    }

    for(uint64_t j = 0; j < opsDebug.size(); ++j) {
        binFile.writeU8LE(opsDebug[j]);
    }

    for(uint64_t j = 0; j < argsDebug.size(); ++j) {
        binFile.writeU16LE(argsDebug[j]);
    }

    for(uint64_t j = 0; j < numbersConstraints.size(); ++j) {
        binFile.writeU64LE(numbersConstraints[j]);
    }

    binFile.endWriteSection();
}

void ExpressionsBin::writeHintsSection(BinFileUtils::BinFileWriter &binFile, int section, std::vector<HintInfo> hintsInfo) {
    binFile.startWriteSection(section);

    uint64_t nHints = hintsInfo.size();
    binFile.writeU32LE(nHints);
    
    for(uint64_t h = 0; h < nHints; h++) {
        HintInfo hint = hintsInfo[h];
        binFile.writeString(hint.name);

        uint32_t nFields = hint.fields.size();
        binFile.writeU32LE(nFields);
        for(uint64_t f = 0; f < nFields; f++) {
            binFile.writeString(hint.fields[f].name);
            uint64_t nValues = hint.fields[f].values.size();
            binFile.writeU32LE(nValues);
            for(uint64_t v = 0; v < nValues; v++) {
                HintValues value = hint.fields[f].values[v];
                binFile.writeString(opType2string(value.op));
                if(value.op == opType::number) {
                    binFile.writeU64LE(value.value);
                } else if(value.op == opType::string_) {
                    binFile.writeString(value.string_);
                } else {
                    binFile.writeU32LE(value.id);
                }
                
                if(value.op == opType::custom || value.op == opType::const_ || value.op == opType::cm) {
                    binFile.writeU32LE(value.rowOffsetIndex);
                }

                if(value.op == opType::tmp) {
                    binFile.writeU32LE(value.dim);
                }
                if(value.op == opType::custom) {
                    binFile.writeU32LE(value.commitId);
                }

                binFile.writeU32LE(value.pos.size());
                for(uint64_t p = 0; p < value.pos.size(); ++p) {
                    binFile.writeU32LE(value.pos[p]);
                }
                
            }
        }
    }


    binFile.endWriteSection();
}


void ExpressionsBin::writeGlobalConstraintsSection(BinFileUtils::BinFileWriter &binFile, int section, std::vector<ExpInfoBin> constraintsInfo, std::vector<uint64_t> numbersConstraints) {
    
    binFile.startWriteSection(section);

    std::vector<uint8_t> opsDebug;
    std::vector<uint16_t> argsDebug;

    std::vector<uint32_t> opsDebugOffset, argsDebugOffset;

    for (uint64_t i = 0; i < constraintsInfo.size(); ++i) {
        if (i == 0) {
            opsDebugOffset.push_back(0);
            argsDebugOffset.push_back(0);
        } else {
            opsDebugOffset.push_back(opsDebugOffset[i - 1] + constraintsInfo[i - 1].ops.size());
            argsDebugOffset.push_back(argsDebugOffset[i - 1] + constraintsInfo[i - 1].args.size());
        }

        opsDebug.insert(opsDebug.end(), constraintsInfo[i].ops.begin(), constraintsInfo[i].ops.end());
        argsDebug.insert(argsDebug.end(), constraintsInfo[i].args.begin(), constraintsInfo[i].args.end());
    }

    binFile.writeU32LE(opsDebug.size());
    binFile.writeU32LE(argsDebug.size());
    binFile.writeU32LE(numbersConstraints.size());

    uint64_t nConstraints = constraintsInfo.size();

    binFile.writeU32LE(nConstraints);

    for (uint64_t i = 0; i < nConstraints; ++i) {
        const ExpInfoBin& constraintInfo = constraintsInfo[i];
        
        // Write expression metadata
        binFile.writeU32LE(constraintInfo.destDim);
        binFile.writeU32LE(constraintInfo.destId);
        binFile.writeU32LE(constraintInfo.nTemp1);
        binFile.writeU32LE(constraintInfo.nTemp3);

        // Write ops information
        binFile.writeU32LE(constraintInfo.ops.size());
        binFile.writeU32LE(opsDebugOffset[i]);

        // Write args information
        binFile.writeU32LE(constraintInfo.args.size());
        binFile.writeU32LE(argsDebugOffset[i]);

        // Write the line string
        binFile.writeString(constraintInfo.line);
    }

    for(uint64_t j = 0; j < opsDebug.size(); ++j) {
        binFile.writeU8LE(opsDebug[j]);
    }

    for(uint64_t j = 0; j < argsDebug.size(); ++j) {
        binFile.writeU16LE(argsDebug[j]);
    }

    for(uint64_t j = 0; j < numbersConstraints.size(); ++j) {
        binFile.writeU64LE(numbersConstraints[j]);
    }

    binFile.endWriteSection();
}

void ExpressionsBin::writeGlobalHintsSection(BinFileUtils::BinFileWriter &binFile, int section, std::vector<HintInfo> hintsInfo) {
    binFile.startWriteSection(section);

    uint64_t nHints = hintsInfo.size();
    binFile.writeU32LE(nHints);
    
    for(uint64_t h = 0; h < nHints; h++) {
        HintInfo hint = hintsInfo[h];
        binFile.writeString(hint.name);

        uint32_t nFields = hint.fields.size();
        binFile.writeU32LE(nFields);
        for(uint64_t f = 0; f < nFields; f++) {
            binFile.writeString(hint.fields[f].name);
            uint64_t nValues = hint.fields[f].values.size();
            binFile.writeU32LE(nValues);
            for(uint64_t v = 0; v < nValues; v++) {
                HintValues value = hint.fields[f].values[v];
                binFile.writeString(opType2string(value.op));
                if(value.op == opType::number) {
                    binFile.writeU64LE(value.value);
                } else if(value.op == opType::string_) {
                    binFile.writeString(value.string_);
                } else if(value.op == opType::airgroupvalue){ 
                    binFile.writeU32LE(value.airgroupId);
                    binFile.writeU32LE(value.id);
                } else {
                    binFile.writeU32LE(value.id);
                }
                
                binFile.writeU32LE(value.pos.size());
                for(uint64_t p = 0; p < value.pos.size(); ++p) {
                    binFile.writeU32LE(value.pos[p]);
                }
                
            }
        }
    }


    binFile.endWriteSection();
}


void ExpressionsBin::loadExpressionsBin(BinFileUtils::BinFile *expressionsBin) {
    expressionsBin->startReadSection(EXPRESSIONS_SECTION);

    maxTmp1 = expressionsBin->readU32LE();
    maxTmp3 = expressionsBin->readU32LE();
    maxArgs = expressionsBin->readU32LE();
    maxOps = expressionsBin->readU32LE();

    uint32_t nOpsExpressions = expressionsBin->readU32LE();
    nOpsTotal = nOpsExpressions;
    uint32_t nArgsExpressions = expressionsBin->readU32LE();
    nArgsTotal = nArgsExpressions;
    uint32_t nNumbersExpressions = expressionsBin->readU32LE();

    requireCountAtMost(nOpsExpressions, MAX_BIN_ITEMS, "expression op count");
    requireCountAtMost(nArgsExpressions, MAX_BIN_ITEMS, "expression arg count");
    requireCountAtMost(nNumbersExpressions, MAX_BIN_ITEMS, "expression number count");

    expressionsBinArgsExpressions.ops = new uint8_t[nOpsExpressions];
    expressionsBinArgsExpressions.args = new uint16_t[nArgsExpressions];
    expressionsBinArgsExpressions.numbers = new Goldilocks::Element[nNumbersExpressions];
    expressionsBinArgsExpressions.nNumbers = nNumbersExpressions;

    uint64_t nExpressions = expressionsBin->readU32LE();
    requireCountAtMost(nExpressions, MAX_BIN_ENTRIES, "expression count");

    for(uint64_t i = 0; i < nExpressions; ++i) {
        ParserParams parserParamsExpression;

        uint32_t expId = expressionsBin->readU32LE();
        
        parserParamsExpression.expId = expId;
        parserParamsExpression.destDim = expressionsBin->readU32LE();
        parserParamsExpression.destId = expressionsBin->readU32LE();
        parserParamsExpression.stage = expressionsBin->readU32LE();

        parserParamsExpression.nTemp1 = expressionsBin->readU32LE();
        parserParamsExpression.nTemp3 = expressionsBin->readU32LE();

        parserParamsExpression.nOps = expressionsBin->readU32LE();
        parserParamsExpression.opsOffset = expressionsBin->readU32LE();

        parserParamsExpression.nArgs = expressionsBin->readU32LE();
        parserParamsExpression.argsOffset = expressionsBin->readU32LE();

        parserParamsExpression.line = readLimitedString(expressionsBin, "expression " + to_string(i) + " line");

        if(expressionsInfo.find(expId) != expressionsInfo.end()) {
            failInvalidExpressionBin("duplicate expression id " + to_string(expId));
        }
        expressionsInfo[expId] = parserParamsExpression;
    }

    for(uint64_t j = 0; j < nOpsExpressions; ++j) {
        expressionsBinArgsExpressions.ops[j] = expressionsBin->readU8LE();
    }
    for(uint64_t j = 0; j < nArgsExpressions; ++j) {
        expressionsBinArgsExpressions.args[j] = expressionsBin->readU16LE();
    }
    for(uint64_t j = 0; j < nNumbersExpressions; ++j) {
        expressionsBinArgsExpressions.numbers[j] = Goldilocks::fromU64(expressionsBin->readU64LE());
    }
    for(const auto& [expId, parserParams] : expressionsInfo) {
        validateParserParamsSpan(parserParams, expressionsBinArgsExpressions, nOpsExpressions, nArgsExpressions,
                                 REGULAR_ARGS_PER_OP, maxTmp1, maxTmp3, maxArgs, maxOps, "expression " + to_string(expId));
    }

    expressionsBin->endReadSection();
    expressionsBin->startReadSection(CONSTRAINTS_SECTION);

    nOpsDebug = expressionsBin->readU32LE();
    nArgsDebug = expressionsBin->readU32LE();
    uint32_t nNumbersDebug = expressionsBin->readU32LE();

    requireCountAtMost(nOpsDebug, MAX_BIN_ITEMS, "constraint op count");
    requireCountAtMost(nArgsDebug, MAX_BIN_ITEMS, "constraint arg count");
    requireCountAtMost(nNumbersDebug, MAX_BIN_ITEMS, "constraint number count");

    expressionsBinArgsConstraints.ops = new uint8_t[nOpsDebug];
    expressionsBinArgsConstraints.args = new uint16_t[nArgsDebug];
    expressionsBinArgsConstraints.numbers = new Goldilocks::Element[nNumbersDebug];
    expressionsBinArgsConstraints.nNumbers = nNumbersDebug;

    uint32_t nConstraints = expressionsBin->readU32LE();
    requireCountAtMost(nConstraints, MAX_BIN_ENTRIES, "constraint count");

    for(uint64_t i = 0; i < nConstraints; ++i) {
        ParserParams parserParamsConstraint;

        uint32_t stage = expressionsBin->readU32LE();
        parserParamsConstraint.stage = stage;
        parserParamsConstraint.expId = 0;
        
        parserParamsConstraint.destDim = expressionsBin->readU32LE();
        parserParamsConstraint.destId = expressionsBin->readU32LE();

        parserParamsConstraint.firstRow = expressionsBin->readU32LE();
        parserParamsConstraint.lastRow = expressionsBin->readU32LE();

        parserParamsConstraint.nTemp1 = expressionsBin->readU32LE();
        parserParamsConstraint.nTemp3 = expressionsBin->readU32LE();

        parserParamsConstraint.nOps = expressionsBin->readU32LE();
        parserParamsConstraint.opsOffset = expressionsBin->readU32LE();

        parserParamsConstraint.nArgs = expressionsBin->readU32LE();
        parserParamsConstraint.argsOffset = expressionsBin->readU32LE();
        
        parserParamsConstraint.imPol = bool(expressionsBin->readU32LE());
        parserParamsConstraint.line = readLimitedString(expressionsBin, "constraint " + to_string(i) + " line");

        constraintsInfoDebug.push_back(parserParamsConstraint);
    }


    for(uint64_t j = 0; j < nOpsDebug; ++j) {
        expressionsBinArgsConstraints.ops[j] = expressionsBin->readU8LE();
    }
    for(uint64_t j = 0; j < nArgsDebug; ++j) {
        expressionsBinArgsConstraints.args[j] = expressionsBin->readU16LE();
    }
    for(uint64_t j = 0; j < nNumbersDebug; ++j) {
        expressionsBinArgsConstraints.numbers[j] = Goldilocks::fromU64(expressionsBin->readU64LE());
    }
    for(uint64_t i = 0; i < constraintsInfoDebug.size(); ++i) {
        validateParserParamsSpan(constraintsInfoDebug[i], expressionsBinArgsConstraints, nOpsDebug, nArgsDebug,
                                 REGULAR_ARGS_PER_OP, maxTmp1, maxTmp3, maxArgs, maxOps, "constraint " + to_string(i));
    }

    expressionsBin->endReadSection();
    expressionsBin->startReadSection(HINTS_SECTION);

    uint32_t nHints = expressionsBin->readU32LE();
    requireCountAtMost(nHints, MAX_BIN_ENTRIES, "hint count");

    // Hints are parsed into nested vectors; bound their total size across the section.
    uint64_t totalHintFields = 0;
    uint64_t totalHintValues = 0;
    uint64_t totalHintPositions = 0;
    uint64_t totalHintStringBytes = 0;

    for(uint64_t h = 0; h < nHints; h++) {
        Hint hint;
        hint.name = readLimitedString(expressionsBin, "hint " + to_string(h) + " name");
        addCheckedCount(totalHintStringBytes, hint.name.size(), MAX_BIN_STRING_BYTES, "hint string bytes");

        uint32_t nFields = expressionsBin->readU32LE();
        addCheckedCount(totalHintFields, nFields, MAX_BIN_ENTRIES, "hint field count");

        for(uint64_t f = 0; f < nFields; f++) {
            HintField hintField;
            std::string name = readLimitedString(expressionsBin, "hint " + to_string(h) + " field name");
            addCheckedCount(totalHintStringBytes, name.size(), MAX_BIN_STRING_BYTES, "hint string bytes");
            hintField.name = name;

            uint64_t nValues = expressionsBin->readU32LE();
            addCheckedCount(totalHintValues, nValues, MAX_BIN_ENTRIES, "hint field value count");
            for(uint64_t v = 0; v < nValues; v++) {
                HintFieldValue hintFieldValue;
                std::string operand = readLimitedString(expressionsBin, "hint operand");
                addCheckedCount(totalHintStringBytes, operand.size(), MAX_BIN_STRING_BYTES, "hint string bytes");
                hintFieldValue.operand = string2opType(operand);
                if(hintFieldValue.operand == opType::number) {
                    hintFieldValue.value = expressionsBin->readU64LE();
                } else if(hintFieldValue.operand == opType::string_) {
                    hintFieldValue.stringValue = readLimitedString(expressionsBin, "hint string value");
                    addCheckedCount(totalHintStringBytes, hintFieldValue.stringValue.size(), MAX_BIN_STRING_BYTES, "hint string bytes");
                } else {
                    hintFieldValue.id = expressionsBin->readU32LE();
                }
                
                if(hintFieldValue.operand == opType::custom || hintFieldValue.operand == opType::const_ || hintFieldValue.operand == opType::cm) {
                    hintFieldValue.rowOffsetIndex = expressionsBin->readU32LE();
                }

                if(hintFieldValue.operand == opType::tmp) {
                    hintFieldValue.dim = expressionsBin->readU32LE();
                }
                if(hintFieldValue.operand == opType::custom) {
                    hintFieldValue.commitId = expressionsBin->readU32LE();
                }
                uint64_t nPos = expressionsBin->readU32LE();
                addCheckedCount(totalHintPositions, nPos, MAX_BIN_ENTRIES, "hint matrix position count");
                hintFieldValue.pos.reserve(nPos);
                for(uint64_t p = 0; p < nPos; ++p) {
                    uint32_t pos = expressionsBin->readU32LE();
                    hintFieldValue.pos.push_back(pos);
                }
                hintField.values.push_back(hintFieldValue);
            }
            
            hint.fields.push_back(hintField);
        }

        hints.push_back(hint);
    }

    expressionsBin->endReadSection();
}

void ExpressionsBin::loadVerifierBin(BinFileUtils::BinFile *expressionsBin) {
    expressionsBin->startReadSection(EXPRESSIONS_SECTION);
    
    maxTmp1 = expressionsBin->readU32LE();
    maxTmp3 = expressionsBin->readU32LE();
    maxArgs = expressionsBin->readU32LE();
    maxOps = expressionsBin->readU32LE();

    uint32_t nOpsExpressions = expressionsBin->readU32LE();
    nOpsTotal = nOpsExpressions;
    uint32_t nArgsExpressions = expressionsBin->readU32LE();
    nArgsTotal = nArgsExpressions;
    uint32_t nNumbersExpressions = expressionsBin->readU32LE();

    requireCountAtMost(nOpsExpressions, MAX_BIN_ITEMS, "verifier expression op count");
    requireCountAtMost(nArgsExpressions, MAX_BIN_ITEMS, "verifier expression arg count");
    requireCountAtMost(nNumbersExpressions, MAX_BIN_ITEMS, "verifier expression number count");

    expressionsBinArgsExpressions.ops = new uint8_t[nOpsExpressions];
    expressionsBinArgsExpressions.args = new uint16_t[nArgsExpressions];
    expressionsBinArgsExpressions.numbers = new Goldilocks::Element[nNumbersExpressions];
    expressionsBinArgsExpressions.nNumbers = nNumbersExpressions;

    uint64_t nExpressions = expressionsBin->readU32LE();
    requireCountAtMost(nExpressions, MAX_BIN_ENTRIES, "verifier expression count");

    for(uint64_t i = 0; i < nExpressions; ++i) {
        ParserParams parserParamsExpression;

        uint32_t expId = expressionsBin->readU32LE();
        
        parserParamsExpression.expId = expId;
        parserParamsExpression.destDim = expressionsBin->readU32LE();
        parserParamsExpression.destId = expressionsBin->readU32LE();
        parserParamsExpression.stage = expressionsBin->readU32LE();

        parserParamsExpression.nTemp1 = expressionsBin->readU32LE();
        parserParamsExpression.nTemp3 = expressionsBin->readU32LE();

        parserParamsExpression.nOps = expressionsBin->readU32LE();
        parserParamsExpression.opsOffset = expressionsBin->readU32LE();

        parserParamsExpression.nArgs = expressionsBin->readU32LE();
        parserParamsExpression.argsOffset = expressionsBin->readU32LE();

        parserParamsExpression.line = readLimitedString(expressionsBin, "verifier expression " + to_string(i) + " line");

        if(expressionsInfo.find(expId) != expressionsInfo.end()) {
            failInvalidExpressionBin("duplicate verifier expression id " + to_string(expId));
        }
        expressionsInfo[expId] = parserParamsExpression;
    }

    for(uint64_t j = 0; j < nOpsExpressions; ++j) {
        expressionsBinArgsExpressions.ops[j] = expressionsBin->readU8LE();
    }
    for(uint64_t j = 0; j < nArgsExpressions; ++j) {
        expressionsBinArgsExpressions.args[j] = expressionsBin->readU16LE();
    }
    for(uint64_t j = 0; j < nNumbersExpressions; ++j) {
        expressionsBinArgsExpressions.numbers[j] = Goldilocks::fromU64(expressionsBin->readU64LE());
    }
    for(const auto& [expId, parserParams] : expressionsInfo) {
        validateParserParamsSpan(parserParams, expressionsBinArgsExpressions, nOpsExpressions, nArgsExpressions,
                                 REGULAR_ARGS_PER_OP, maxTmp1, maxTmp3, maxArgs, maxOps, "verifier expression " + to_string(expId));
    }

    expressionsBin->endReadSection();
}

void ExpressionsBin::loadGlobalBin(BinFileUtils::BinFile *globalBin) {
    
    globalBin->startReadSection(GLOBAL_CONSTRAINTS_SECTION);

    uint32_t nOpsDebug = globalBin->readU32LE();
    uint32_t nArgsDebug = globalBin->readU32LE();
    uint32_t nNumbersDebug = globalBin->readU32LE();

    requireCountAtMost(nOpsDebug, MAX_BIN_ITEMS, "global constraint op count");
    requireCountAtMost(nArgsDebug, MAX_BIN_ITEMS, "global constraint arg count");
    requireCountAtMost(nNumbersDebug, MAX_BIN_ITEMS, "global constraint number count");

    expressionsBinArgsConstraints.ops = new uint8_t[nOpsDebug];
    expressionsBinArgsConstraints.args = new uint16_t[nArgsDebug];
    expressionsBinArgsConstraints.numbers = new Goldilocks::Element[nNumbersDebug];
    expressionsBinArgsConstraints.nNumbers = nNumbersDebug;

    uint32_t nGlobalConstraints = globalBin->readU32LE();
    requireCountAtMost(nGlobalConstraints, MAX_BIN_ENTRIES, "global constraint count");

    for(uint64_t i = 0; i < nGlobalConstraints; ++i) {
        ParserParams parserParamsConstraint;

        parserParamsConstraint.destDim = globalBin->readU32LE();
        if(parserParamsConstraint.destDim != 1 && parserParamsConstraint.destDim != FIELD_EXTENSION) {
            failInvalidExpressionBin("global constraint " + to_string(i) + " has invalid destination dimension");
        }
        parserParamsConstraint.destId = globalBin->readU32LE();

        parserParamsConstraint.nTemp1 = globalBin->readU32LE();
        parserParamsConstraint.nTemp3 = globalBin->readU32LE();

        parserParamsConstraint.nOps = globalBin->readU32LE();
        parserParamsConstraint.opsOffset = globalBin->readU32LE();

        parserParamsConstraint.nArgs = globalBin->readU32LE();
        parserParamsConstraint.argsOffset = globalBin->readU32LE();


        parserParamsConstraint.line = readLimitedString(globalBin, "global constraint " + to_string(i) + " line");

        constraintsInfoDebug.push_back(parserParamsConstraint);
    }


    for(uint64_t j = 0; j < nOpsDebug; ++j) {
        expressionsBinArgsConstraints.ops[j] = globalBin->readU8LE();
    }
    for(uint64_t j = 0; j < nArgsDebug; ++j) {
        expressionsBinArgsConstraints.args[j] = globalBin->readU16LE();
    }
    for(uint64_t j = 0; j < nNumbersDebug; ++j) {
        expressionsBinArgsConstraints.numbers[j] = Goldilocks::fromU64(globalBin->readU64LE());
    }
    // Global bins declare no temporary or op maxima; their evaluator sizes temporaries per constraint.
    for(uint64_t i = 0; i < constraintsInfoDebug.size(); ++i) {
        validateParserParamsSpan(constraintsInfoDebug[i], expressionsBinArgsConstraints, nOpsDebug, nArgsDebug,
                                 GLOBAL_ARGS_PER_OP, MAX_BIN_ENTRIES, MAX_BIN_ENTRIES, MAX_BIN_ITEMS, MAX_BIN_ITEMS,
                                 "global constraint " + to_string(i));
    }

    globalBin->endReadSection();

    globalBin->startReadSection(GLOBAL_HINTS_SECTION);

    uint32_t nHints = globalBin->readU32LE();
    requireCountAtMost(nHints, MAX_BIN_ENTRIES, "global hint count");

    uint64_t totalHintFields = 0;
    uint64_t totalHintValues = 0;
    uint64_t totalHintPositions = 0;
    uint64_t totalHintStringBytes = 0;

    for(uint64_t h = 0; h < nHints; h++) {
        Hint hint;
        hint.name = readLimitedString(globalBin, "global hint " + to_string(h) + " name");
        addCheckedCount(totalHintStringBytes, hint.name.size(), MAX_BIN_STRING_BYTES, "global hint string bytes");

        uint32_t nFields = globalBin->readU32LE();
        addCheckedCount(totalHintFields, nFields, MAX_BIN_ENTRIES, "global hint field count");

        for(uint64_t f = 0; f < nFields; f++) {
            HintField hintField;
            std::string name = readLimitedString(globalBin, "global hint " + to_string(h) + " field name");
            addCheckedCount(totalHintStringBytes, name.size(), MAX_BIN_STRING_BYTES, "global hint string bytes");
            hintField.name = name;

            uint64_t nValues = globalBin->readU32LE();
            addCheckedCount(totalHintValues, nValues, MAX_BIN_ENTRIES, "global hint field value count");
            for(uint64_t v = 0; v < nValues; v++) {
                HintFieldValue hintFieldValue;
                std::string operand = readLimitedString(globalBin, "global hint operand");
                addCheckedCount(totalHintStringBytes, operand.size(), MAX_BIN_STRING_BYTES, "global hint string bytes");
                hintFieldValue.operand = string2opType(operand);
                if(hintFieldValue.operand == opType::number) {
                    hintFieldValue.value = globalBin->readU64LE();
                } else if(hintFieldValue.operand == opType::string_) {
                    hintFieldValue.stringValue = readLimitedString(globalBin, "global hint string value");
                    addCheckedCount(totalHintStringBytes, hintFieldValue.stringValue.size(), MAX_BIN_STRING_BYTES, "global hint string bytes");
                } else if(hintFieldValue.operand == opType::airgroupvalue || hintFieldValue.operand == opType::airvalue) {
                    hintFieldValue.dim = globalBin->readU32LE();
                    hintFieldValue.id = globalBin->readU32LE();
                } else if(hintFieldValue.operand == opType::tmp || hintFieldValue.operand == opType::public_ || hintFieldValue.operand == opType::proofvalue) {
                    hintFieldValue.id = globalBin->readU32LE();
                } else {
                    throw new std::invalid_argument("Invalid file type");
                }
      
                uint64_t nPos = globalBin->readU32LE();
                addCheckedCount(totalHintPositions, nPos, MAX_BIN_ENTRIES, "global hint matrix position count");
                hintFieldValue.pos.reserve(nPos);
                for(uint64_t p = 0; p < nPos; ++p) {
                    uint32_t pos = globalBin->readU32LE();
                    hintFieldValue.pos.push_back(pos);
                }
                hintField.values.push_back(hintFieldValue);
            }
            
            hint.fields.push_back(hintField);
        }

        hints.push_back(hint);
    }

    globalBin->endReadSection();

}

void ExpressionsBin::getHintIdsByName(uint64_t* hintIds, std::string name) {
    uint64_t c = 0;
    for (uint64_t i = 0; i < hints.size(); ++i) {
        if (hints[i].name == name) {
            hintIds[c++] = i;
        }
    }
}


uint64_t ExpressionsBin::getNumberHintIdsByName(std::string name) {

    uint64_t nHints = 0;
    for (uint64_t i = 0; i < hints.size(); ++i) {
        if (hints[i].name == name) {
            nHints++;
        }
    }

    return nHints;
}

void ExpressionsBin::validateAgainstStarkInfo(const StarkInfo& starkInfo) {
    if(expressionsInfo.size() > 0) {
        auto cExpIt = expressionsInfo.find(starkInfo.cExpId);
        if(cExpIt == expressionsInfo.end()) {
            failInvalidExpressionBin("missing constraint expression id " + to_string(starkInfo.cExpId));
        }
        if(cExpIt->second.destDim != FIELD_EXTENSION) {
            failInvalidExpressionBin("constraint expression dimension does not match qDim");
        }

        auto friExpIt = expressionsInfo.find(starkInfo.friExpId);
        if(friExpIt == expressionsInfo.end()) {
            failInvalidExpressionBin("missing FRI expression id " + to_string(starkInfo.friExpId));
        }
        if(friExpIt->second.destDim != FIELD_EXTENSION) {
            failInvalidExpressionBin("FRI expression dimension does not match field extension width");
        }
    }

    for(const auto& [expId, parserParams] : expressionsInfo) {
        validateRegularParserParams(parserParams, expressionsBinArgsExpressions, starkInfo, "expression " + to_string(expId));
    }

    for(uint64_t i = 0; i < constraintsInfoDebug.size(); ++i) {
        validateRegularParserParams(constraintsInfoDebug[i], expressionsBinArgsConstraints, starkInfo, "constraint " + to_string(i));
    }

    validateRegularHints(hints, starkInfo, expressionsInfo);

    // Verifier bins only carry the quotient and FRI expressions; intermediate polynomials are
    // computed by the prover alone.
    if(starkInfo.verify) return;

    for(uint64_t i = 0; i < starkInfo.cmPolsMap.size(); ++i) {
        const PolMap& polMap = starkInfo.cmPolsMap[i];
        if(!polMap.imPol) continue;

        auto expIt = expressionsInfo.find(polMap.expId);
        if(expIt == expressionsInfo.end()) {
            failInvalidExpressionBin("imPol " + to_string(i) + " references an unknown expression");
        }
        if(expIt->second.destDim != polMap.dim) {
            failInvalidExpressionBin("imPol " + to_string(i) + " expression dimension does not match polynomial dimension");
        }
    }
}
