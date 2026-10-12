#ifndef GLOBAL_CONSTRAINTS_HPP
#define GLOBAL_CONSTRAINTS_HPP
#include "goldilocks_base_field.hpp"
#include <nlohmann/json.hpp>
#include <array>
#include <vector>

using json = nlohmann::json;

namespace {

const Hint& requireGlobalConstraintHint(ExpressionsBin &globalConstraintsBin, uint64_t hintId) {
    if(hintId >= globalConstraintsBin.hints.size()) {
        zklog.error("Hint id " + to_string(hintId) + " out of range.");
        exitProcess();
        exit(-1);
    }
    return globalConstraintsBin.hints[hintId];
}

const HintField& requireGlobalConstraintHintField(const Hint& hint, const std::string& hintFieldName) {
    const HintField* match = nullptr;
    for(const HintField& hintField : hint.fields) {
        if(hintField.name != hintFieldName) continue;
        if(match != nullptr) {
            zklog.error("Hint field " + hintFieldName + " appears multiple times in hint " + hint.name + ".");
            exitProcess();
            exit(-1);
        }
        match = &hintField;
    }

    if(match == nullptr) {
        zklog.error("Hint field " + hintFieldName + " not found in hint " + hint.name + ".");
        exitProcess();
        exit(-1);
    }

    return *match;
}

const HintFieldValue& requireSingleGlobalConstraintHintFieldValue(const Hint& hint, const std::string& hintFieldName) {
    const HintField& hintField = requireGlobalConstraintHintField(hint, hintFieldName);
    if(hintField.values.size() != 1) {
        zklog.error("Hint field " + hintFieldName + " in " + hint.name + " must contain exactly one value.");
        exitProcess();
        exit(-1);
    }
    return hintField.values[0];
}

[[noreturn]] void failInvalidGlobalConstraintsBin(const std::string& message) {
    zklog.error("Invalid global constraints bin metadata: " + message);
    exitProcess();
    exit(-1);
}

void requireGlobalRange(uint64_t offset, uint64_t width, uint64_t total, const std::string& label) {
    if(width > total || offset > total - width) {
        failInvalidGlobalConstraintsBin(label + " is out of range");
    }
}

uint64_t globalPublicWords(json& globalInfo) {
    if(!globalInfo.contains("nPublics")) {
        failInvalidGlobalConstraintsBin("globalInfo nPublics is missing");
    }
    return uint64_t(globalInfo["nPublics"]);
}

uint64_t globalProofValuesSize(json& globalInfo) {
    if(!globalInfo.contains("proofValuesMap") || !globalInfo["proofValuesMap"].is_array()) {
        failInvalidGlobalConstraintsBin("globalInfo proofValuesMap is missing");
    }

    uint64_t size = 0;
    for(uint64_t i = 0; i < globalInfo["proofValuesMap"].size(); ++i) {
        uint64_t stage = globalInfo["proofValuesMap"][i]["stage"];
        size += stage == 1 ? 1 : FIELD_EXTENSION;
    }
    return size;
}

uint64_t globalChallengeWords(json& globalInfo) {
    if(!globalInfo.contains("numChallenges") || !globalInfo["numChallenges"].is_array()) {
        failInvalidGlobalConstraintsBin("globalInfo numChallenges is missing");
    }

    uint64_t count = 0;
    for(uint64_t i = 0; i < globalInfo["numChallenges"].size(); ++i) {
        count += uint64_t(globalInfo["numChallenges"][i]);
    }
    return count * FIELD_EXTENSION;
}

uint64_t globalAirgroupValuesWords(json& globalInfo) {
    if(!globalInfo.contains("aggTypes") || !globalInfo["aggTypes"].is_array()) {
        failInvalidGlobalConstraintsBin("globalInfo aggTypes is missing");
    }

    uint64_t size = 0;
    for(uint64_t i = 0; i < globalInfo["aggTypes"].size(); ++i) {
        size += uint64_t(globalInfo["aggTypes"][i].size()) * FIELD_EXTENSION;
    }
    return size;
}

void validateGlobalSource(
    json& globalInfo,
    ParserArgs& parserArgs,
    ParserParams& parserParams,
    uint64_t sourceType,
    uint64_t sourceOffset,
    uint64_t sourceDim,
    const std::string& label
) {
    if(sourceType == 0) {
        if(sourceDim != 1) {
            failInvalidGlobalConstraintsBin(label + " loads tmp1 as an extension value");
        }
        requireGlobalRange(sourceOffset, 1, parserParams.nTemp1, label + " tmp1 source");
    } else if(sourceType == 1) {
        requireGlobalRange(sourceOffset, sourceDim, globalPublicWords(globalInfo), label + " public input");
    } else if(sourceType == 2) {
        requireGlobalRange(sourceOffset, sourceDim, parserArgs.nNumbers, label + " number");
    } else if(sourceType == 3) {
        requireGlobalRange(sourceOffset, sourceDim, globalProofValuesSize(globalInfo), label + " proof value");
    } else if(sourceType == 4) {
        requireGlobalRange(sourceOffset, sourceDim, parserParams.nTemp3 * uint64_t(FIELD_EXTENSION), label + " tmp3 source");
    } else if(sourceType == 5) {
        requireGlobalRange(sourceOffset, sourceDim, globalAirgroupValuesWords(globalInfo), label + " airgroup value");
    } else if(sourceType == 6) {
        requireGlobalRange(sourceOffset, sourceDim, globalChallengeWords(globalInfo), label + " challenge");
    } else {
        failInvalidGlobalConstraintsBin(label + " references an unknown source type");
    }
}

// The loader already bounds the op and arg spans, the opcodes and the temporaries of every global
// constraint; the operands index buffers whose sizes only globalInfo knows.
void validateGlobalParserParams(json& globalInfo, ParserArgs& parserArgs, ParserParams& parserParams) {
    for(uint64_t kk = 0; kk < parserParams.nOps; ++kk) {
        uint64_t opOffset = uint64_t(parserParams.opsOffset) + kk;
        uint64_t argOffset = uint64_t(parserParams.argsOffset) + kk * 6;
        uint8_t op = parserArgs.ops[opOffset];
        uint16_t* args = parserArgs.args;
        std::string label = "global op " + to_string(kk);

        if(args[argOffset] > 3) {
            failInvalidGlobalConstraintsBin(label + " has an invalid arithmetic operation");
        }

        if(op == 0) {
            requireGlobalRange(args[argOffset + 1], 1, parserParams.nTemp1, label + " tmp1 destination");
            validateGlobalSource(globalInfo, parserArgs, parserParams, args[argOffset + 2], args[argOffset + 3], 1, label + " source 0");
            validateGlobalSource(globalInfo, parserArgs, parserParams, args[argOffset + 4], args[argOffset + 5], 1, label + " source 1");
        } else if(op == 1) {
            requireGlobalRange(args[argOffset + 1], FIELD_EXTENSION, parserParams.nTemp3 * uint64_t(FIELD_EXTENSION), label + " tmp3 destination");
            validateGlobalSource(globalInfo, parserArgs, parserParams, args[argOffset + 2], args[argOffset + 3], FIELD_EXTENSION, label + " source 0");
            validateGlobalSource(globalInfo, parserArgs, parserParams, args[argOffset + 4], args[argOffset + 5], 1, label + " source 1");
        } else {
            requireGlobalRange(args[argOffset + 1], FIELD_EXTENSION, parserParams.nTemp3 * uint64_t(FIELD_EXTENSION), label + " tmp3 destination");
            validateGlobalSource(globalInfo, parserArgs, parserParams, args[argOffset + 2], args[argOffset + 3], FIELD_EXTENSION, label + " source 0");
            validateGlobalSource(globalInfo, parserArgs, parserParams, args[argOffset + 4], args[argOffset + 5], FIELD_EXTENSION, label + " source 1");
        }
    }

    if(parserParams.destDim == 1) {
        requireGlobalRange(parserParams.destId, 1, parserParams.nTemp1, "global expression destination tmp1");
    } else if(parserParams.destDim == FIELD_EXTENSION) {
        requireGlobalRange(parserParams.destId * uint64_t(FIELD_EXTENSION), FIELD_EXTENSION, parserParams.nTemp3 * uint64_t(FIELD_EXTENSION), "global expression destination tmp3");
    } else {
        failInvalidGlobalConstraintsBin("global expression has invalid destination dimension");
    }
}

void validateGlobalHintValue(json& globalInfo, ExpressionsBin& globalConstraintsBin, const HintFieldValue& hintFieldVal, const std::string& label) {
    if(hintFieldVal.operand == opType::tmp) {
        if(globalConstraintsBin.expressionsInfo.find(hintFieldVal.id) == globalConstraintsBin.expressionsInfo.end()) {
            failInvalidGlobalConstraintsBin(label + " references an unknown expression");
        }
    } else if(hintFieldVal.operand == opType::public_) {
        requireGlobalRange(hintFieldVal.id, 1, globalPublicWords(globalInfo), label + " public input");
    } else if(hintFieldVal.operand == opType::number || hintFieldVal.operand == opType::string_) {
        return;
    } else if(hintFieldVal.operand == opType::airgroupvalue) {
        if(!globalInfo.contains("aggTypes") || !globalInfo["aggTypes"].is_array()) {
            failInvalidGlobalConstraintsBin("globalInfo aggTypes is missing");
        }
        requireGlobalRange(hintFieldVal.dim, 1, globalInfo["aggTypes"].size(), label + " airgroup id");
        requireGlobalRange(hintFieldVal.id, 1, globalInfo["aggTypes"][hintFieldVal.dim].size(), label + " airgroup value");
    } else if(hintFieldVal.operand == opType::proofvalue) {
        if(!globalInfo.contains("proofValuesMap") || !globalInfo["proofValuesMap"].is_array()) {
            failInvalidGlobalConstraintsBin("globalInfo proofValuesMap is missing");
        }
        requireGlobalRange(hintFieldVal.id, 1, globalInfo["proofValuesMap"].size(), label + " proof value");
    } else {
        failInvalidGlobalConstraintsBin(label + " has unknown hint field type");
    }
}

}

struct GlobalConstraintInfo {
    uint64_t id;
    uint64_t dim;
    bool valid;
    bool skip;
    uint64_t value[3];
};

void calculateGlobalExpression(json& globalInfo, Goldilocks::Element* dest, Goldilocks::Element* publics, Goldilocks::Element* challenges, Goldilocks::Element* proofValues, Goldilocks::Element** airgroupValues, ParserArgs &parserArgs, ParserParams &parserParams) {

    validateGlobalParserParams(globalInfo, parserArgs, parserParams);

    uint8_t* ops = &parserArgs.ops[parserParams.opsOffset];
    uint16_t* args = &parserArgs.args[parserParams.argsOffset];

    uint64_t i_args = 0;

    std::vector<Goldilocks::Element> tmp1(parserParams.nTemp1);
    std::vector<Goldilocks::Element> tmp3(uint64_t(parserParams.nTemp3) * FIELD_EXTENSION);

    uint64_t nAirgroupValues = 0;
    for(uint64_t i = 0; i < globalInfo["aggTypes"].size(); ++i) {
        nAirgroupValues += globalInfo["aggTypes"][i].size() * FIELD_EXTENSION;
    }

    std::vector<Goldilocks::Element> airgroupvalues(nAirgroupValues);
    uint64_t c = 0;
    for(uint64_t i = 0; i < globalInfo["aggTypes"].size(); ++i) {
        uint64_t words = globalInfo["aggTypes"][i].size() * FIELD_EXTENSION;
        if(words > 0) {
            memcpy(airgroupvalues.data() + c, airgroupValues[i], words * sizeof(Goldilocks::Element));
        }
        c += words;
    }

    Goldilocks::Element* expressions_params[7];
    expressions_params[0] = tmp1.data();
    expressions_params[1] = publics;
    expressions_params[2] = parserArgs.numbers;
    expressions_params[3] = proofValues;
    expressions_params[4] = tmp3.data();
    expressions_params[5] = airgroupvalues.data();
    expressions_params[6] = challenges;

    for (uint64_t kk = 0; kk < parserParams.nOps; ++kk) {
        switch (ops[kk]) {
            case 0: {
                // OPERATION WITH DEST: dim1 - SRC0: dim1 - SRC1: dim1
                Goldilocks::op_pack(1, args[i_args], &expressions_params[0][args[i_args + 1]], &expressions_params[args[i_args + 2]][args[i_args + 3]], &expressions_params[args[i_args + 4]][args[i_args + 5]]);
                i_args += 6;
                break;
            }
            case 1: {
                // OPERATION WITH DEST: dim3 - SRC0: dim3 - SRC1: dim1
                Goldilocks3::op_31_pack(1, args[i_args], &expressions_params[4][args[i_args + 1]], &expressions_params[args[i_args + 2]][args[i_args + 3]], &expressions_params[args[i_args + 4]][args[i_args + 5]]);
                i_args += 6;
                break;
            }
            case 2: {
                // OPERATION WITH DEST: dim3 - SRC0: dim3 - SRC1: dim3
                Goldilocks3::op_pack(1, args[i_args], &expressions_params[4][args[i_args + 1]], &expressions_params[args[i_args + 2]][args[i_args + 3]], &expressions_params[args[i_args + 4]][args[i_args + 5]]);
                i_args += 6;
                break;
            }
        }
    }

    if (i_args != parserParams.nArgs) std::cout << " " << i_args << " - " << parserParams.nArgs << std::endl;
    assert(i_args == parserParams.nArgs);

    if(parserParams.destDim == 1) {
        std::memcpy(dest, &tmp1[parserParams.destId], sizeof(Goldilocks::Element));
    } else if(parserParams.destDim == 3) {
        std::memcpy(dest, &tmp3[parserParams.destId * FIELD_EXTENSION], parserParams.destDim * sizeof(Goldilocks::Element));
    }
}


void verifyGlobalConstraint(json& globalInfo, uint64_t constraintId, Goldilocks::Element* publics, Goldilocks::Element* challenges, Goldilocks::Element* proofValues, Goldilocks::Element** airgroupValues, ParserArgs &parserArgs, ParserParams &parserParams, GlobalConstraintInfo& globalConstraintInfo) {

    globalConstraintInfo.id = constraintId;
    globalConstraintInfo.valid = true;

    std::array<Goldilocks::Element, FIELD_EXTENSION> dest{};

    calculateGlobalExpression(globalInfo, dest.data(), publics, challenges, proofValues, airgroupValues, parserArgs, parserParams);

    if(parserParams.destDim == 1) {
        globalConstraintInfo.dim = parserParams.destDim;
        globalConstraintInfo.value[0] = Goldilocks::toU64(dest[0]);
        globalConstraintInfo.value[1] = 0;
        globalConstraintInfo.value[2] = 0;
        if(globalConstraintInfo.value[0] != 0) globalConstraintInfo.valid = false;
    } else {
        globalConstraintInfo.dim = parserParams.destDim;
        globalConstraintInfo.value[0] = Goldilocks::toU64(dest[0]);
        globalConstraintInfo.value[1] = Goldilocks::toU64(dest[1]);
        globalConstraintInfo.value[2] = Goldilocks::toU64(dest[2]);
        if(globalConstraintInfo.value[0] != 0 || globalConstraintInfo.value[1] != 0 || globalConstraintInfo.value[2] != 0) globalConstraintInfo.valid = false;
    }
}

uint64_t getNumberGlobalConstraints(ExpressionsBin &globalConstraintsBin) {
    std::vector<ParserParams> globalConstraints = globalConstraintsBin.constraintsInfoDebug;
    return globalConstraints.size();
}

void getGlobalConstraintsLinesSizes(ExpressionsBin &globalConstraintsBin, uint64_t* constraintsLinesSizes) {
    std::vector<ParserParams> globalConstraints = globalConstraintsBin.constraintsInfoDebug;
    for(uint64_t i = 0; i <globalConstraints.size(); ++i) {
        constraintsLinesSizes[i] = globalConstraintsBin.constraintsInfoDebug[i].line.size();
    }
}

void getGlobalConstraintsLines(ExpressionsBin &globalConstraintsBin, uint8_t** constraintsLines) {
    std::vector<ParserParams> globalConstraints = globalConstraintsBin.constraintsInfoDebug;
     for(uint64_t i = 0; i < globalConstraintsBin.constraintsInfoDebug.size(); ++i) {
        std::memcpy(constraintsLines[i], globalConstraints[i].line.data(), globalConstraints[i].line.size());
    }
}
   

void verifyGlobalConstraints(json& globalInfo, ExpressionsBin &globalConstraintsBin, Goldilocks::Element* publicInputs, Goldilocks::Element* challenges, Goldilocks::Element* proofValues, Goldilocks::Element** airgroupValues, GlobalConstraintInfo *globalConstraintsInfo)
{
    std::vector<ParserParams> globalConstraints = globalConstraintsBin.constraintsInfoDebug;

    for(uint64_t i = 0; i < globalConstraints.size(); ++i) {
        if(!globalConstraintsInfo[i].skip) {
            verifyGlobalConstraint(globalInfo, i, publicInputs, challenges, proofValues, airgroupValues, globalConstraintsBin.expressionsBinArgsConstraints, globalConstraints[i], globalConstraintsInfo[i]);
        }
    }
}

std::string getExpressionDebug(json& globalInfo, ExpressionsBin &globalConstraintsBin, uint64_t hintId, std::string hintFieldName, HintFieldValue hintFieldVal) {
    validateGlobalHintValue(globalInfo, globalConstraintsBin, hintFieldVal, "hint " + to_string(hintId) + " field " + hintFieldName);
    std::string debug = "Hint name " + hintFieldName + " for hint id " + to_string(hintId) + " is ";
    if (hintFieldVal.operand == opType::tmp) {
        if(globalConstraintsBin.expressionsInfo[hintFieldVal.id].line != "") {
            debug += "the expression with id: " + to_string(hintFieldVal.id) + " " + globalConstraintsBin.expressionsInfo[hintFieldVal.id].line;
        }
    } else if (hintFieldVal.operand == opType::public_) {
        debug += "public input " + to_string(globalInfo["publicsMap"][hintFieldVal.id]["name"]);
    } else if (hintFieldVal.operand == opType::number) {
        debug += "number " + to_string(hintFieldVal.value);
    } else if (hintFieldVal.operand == opType::airgroupvalue) {
       debug += "airgroupvalue ";
    } else if (hintFieldVal.operand == opType::proofvalue) {
       debug += "proof value  " + to_string(globalInfo["proofValuesMap"][hintFieldVal.id]["name"]);
    } else if (hintFieldVal.operand == opType::string_) {
       debug += "string " + hintFieldVal.stringValue;
    } else {
        zklog.error("Unknown HintFieldType");
        exitProcess();
        exit(-1);
    }

    return debug;
}

uint64_t getHintFieldGlobalConstraintValues(ExpressionsBin &globalConstraintsBin, uint64_t hintId, std::string hintFieldName) {
    const Hint& hint = requireGlobalConstraintHint(globalConstraintsBin, hintId);
    const HintField& hintField = requireGlobalConstraintHintField(hint, hintFieldName);
    return hintField.values.size();
}

void getHintFieldGlobalConstraintSizes(json& globalInfo, ExpressionsBin &globalConstraintsBin,  HintFieldInfo *hintFieldValues,  uint64_t hintId, std::string hintFieldName, bool print_expression) {
    const Hint& hint = requireGlobalConstraintHint(globalConstraintsBin, hintId);
    const HintField& hintField = requireGlobalConstraintHintField(hint, hintFieldName);

    for(uint64_t i = 0; i < hintField.values.size(); ++i) {
        HintFieldValue hintFieldVal = hintField.values[i];
        validateGlobalHintValue(globalInfo, globalConstraintsBin, hintFieldVal, "hint " + to_string(hintId) + " field " + hintFieldName);

        if(print_expression) {
            std::string expression_line = getExpressionDebug(globalInfo, globalConstraintsBin, hintId, hintFieldName, hintFieldVal);
            hintFieldValues[i].expression_line_size = expression_line.size();
        }

        if (hintFieldVal.operand == opType::tmp) {
            uint64_t dim = globalConstraintsBin.expressionsInfo[hintFieldVal.id].destDim;
            hintFieldValues[i].fieldType = dim == 1 ? HintFieldType::Column : HintFieldType::ColumnExtended;
            hintFieldValues[i].offset = dim;
            hintFieldValues[i].size = dim;
        } else if (hintFieldVal.operand == opType::public_) {
            hintFieldValues[i].size = 1;
            hintFieldValues[i].fieldType = HintFieldType::Field;
            hintFieldValues[i].offset = 1;
        } else if (hintFieldVal.operand == opType::number) {
            hintFieldValues[i].size = 1;
            hintFieldValues[i].fieldType = HintFieldType::Field;
            hintFieldValues[i].offset = 1;
        } else if (hintFieldVal.operand == opType::airgroupvalue) {
            hintFieldValues[i].size = FIELD_EXTENSION;
            hintFieldValues[i].fieldType = HintFieldType::FieldExtended;
            hintFieldValues[i].offset = FIELD_EXTENSION;
        } else if (hintFieldVal.operand == opType::proofvalue) {
            uint64_t dim = globalInfo["proofValuesMap"][hintFieldVal.id]["stage"] == 1 ? 1 : FIELD_EXTENSION;
            hintFieldValues[i].size = dim;
            hintFieldValues[i].fieldType = dim == 1 ? HintFieldType::Field : HintFieldType::FieldExtended;
            hintFieldValues[i].offset = FIELD_EXTENSION;
        } else if (hintFieldVal.operand == opType::string_) {
            hintFieldValues[i].string_size = hintFieldVal.stringValue.size();
            hintFieldValues[i].fieldType = HintFieldType::String;
            hintFieldValues[i].offset = 0;
        } else {
            zklog.error("Unknown HintFieldType");
            exitProcess();
            exit(-1);
        }

        hintFieldValues[i].matrix_size = hintFieldVal.pos.size();
    }
    
    return;
}

void getHintFieldGlobalConstraint(json& globalInfo, ExpressionsBin &globalConstraintsBin, HintFieldInfo *hintFieldValues, Goldilocks::Element* publicInputs, Goldilocks::Element* challenges, Goldilocks::Element* proofValues, Goldilocks::Element** airgroupValues, uint64_t hintId, std::string hintFieldName, bool print_expression) {
   

    const Hint& hint = requireGlobalConstraintHint(globalConstraintsBin, hintId);
    const HintField& hintField = requireGlobalConstraintHintField(hint, hintFieldName);

    for(uint64_t i = 0; i < hintField.values.size(); ++i) {
        HintFieldValue hintFieldVal = hintField.values[i];
        validateGlobalHintValue(globalInfo, globalConstraintsBin, hintFieldVal, "hint " + to_string(hintId) + " field " + hintFieldName);
       
        HintFieldInfo hintFieldInfo = hintFieldValues[i];

        if(print_expression) {
            std::string expression_line = getExpressionDebug(globalInfo, globalConstraintsBin, hintId, hintFieldName, hintFieldVal);
            hintFieldValues[i].expression_line_size = expression_line.size();
        }

        if (hintFieldVal.operand == opType::tmp) {
            calculateGlobalExpression(globalInfo, hintFieldInfo.values, publicInputs, challenges, proofValues, airgroupValues, globalConstraintsBin.expressionsBinArgsExpressions, globalConstraintsBin.expressionsInfo[hintFieldVal.id]);
        } else if (hintFieldVal.operand == opType::public_) {
            hintFieldInfo.values[0] = publicInputs[hintFieldVal.id];
        } else if (hintFieldVal.operand == opType::number) {
            hintFieldInfo.values[0] = Goldilocks::fromU64(hintFieldVal.value);
        } else if (hintFieldVal.operand == opType::airgroupvalue) {
            std::memcpy(hintFieldInfo.values, &airgroupValues[hintFieldVal.dim][FIELD_EXTENSION*hintFieldVal.id], FIELD_EXTENSION * sizeof(Goldilocks::Element));
        } else if (hintFieldVal.operand == opType::proofvalue) {
            uint64_t pos = 0;
            for(uint64_t i = 0; i < hintFieldVal.id; ++i) {
                pos += globalInfo["proofValuesMap"][i]["stage"] == 1 ? 1 : FIELD_EXTENSION;
            }
            std::memcpy(hintFieldInfo.values, &proofValues[pos], hintFieldInfo.size * sizeof(Goldilocks::Element));
        } else if (hintFieldVal.operand == opType::string_) {
            std::memcpy(hintFieldInfo.stringValue, hintFieldVal.stringValue.data(), hintFieldVal.stringValue.size());
        } else {
            zklog.error("Unknown HintFieldType");
            exitProcess();
            exit(-1);
        }

        for(uint64_t i = 0; i < hintFieldInfo.matrix_size; ++i) {
            hintFieldInfo.pos[i] =  hintFieldVal.pos[i];
        }
    }
    
    return;
}


uint64_t setHintFieldGlobalConstraint(json& globalInfo, ExpressionsBin &globalConstraintsBin, Goldilocks::Element* proofValues, Goldilocks::Element* values, uint64_t hintId, std::string hintFieldName) {
    const Hint& hint = requireGlobalConstraintHint(globalConstraintsBin, hintId);
    const HintFieldValue& hintFieldVal = requireSingleGlobalConstraintHintFieldValue(hint, hintFieldName);
    validateGlobalHintValue(globalInfo, globalConstraintsBin, hintFieldVal, "hint " + to_string(hintId) + " field " + hintFieldName);

    if(hintFieldVal.operand == opType::proofvalue) {
        uint64_t pos = 0;
        for(uint64_t i = 0; i < hintFieldVal.id; ++i) {
            pos += globalInfo["proofValuesMap"][i]["stage"] == 1 ? 1 : FIELD_EXTENSION;
        }
        uint64_t dim = globalInfo["proofValuesMap"][hintFieldVal.id]["stage"] == 1 ? 1 : FIELD_EXTENSION;
        std::memcpy(&proofValues[pos], values, dim * sizeof(Goldilocks::Element));
    } else {
        zklog.error("Only committed pols and airgroupvalues can be set");
        exitProcess();
        exit(-1);  
    }

    return hintFieldVal.id;
}

#endif
