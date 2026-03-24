const fs = require('fs');
const protobuf = require('protobufjs');
const log = require("../logger.js");

const AGGREGATION_TYPES = {
    SUM: 0,
    PROD: 1,
};

const SYMBOL_TYPES = {
    IM_COL: 0,
    FIXED_COL: 1,
    PERIODIC_COL: 2,
    WITNESS_COL: 3,
    PROOF_VALUE: 4,
    AIRGROUP_VALUE: 5,
    PUBLIC_VALUE: 6,
    PUBLIC_TABLE: 7,
    CHALLENGE: 8,
};

const HINT_FIELD_TYPES = {
    STRING: 0,
    OPERAND: 1,
    ARRAY: 2,
};

const airoutProto = require.resolve('./pilout.proto');

class AirOut {
    constructor(airout) {
        log.info("[AirOut    ]", "··· Loading airout...");

        const airoutEncoded = fs.readFileSync(airout);
        const AirOut = protobuf.loadSync(airoutProto).lookupType("PilOut");

        Object.assign(this, AirOut.toObject(AirOut.decode(airoutEncoded)));
        
        this.preprocessAirout();

        this.printInfo();
    }

    preprocessAirout() {
        for(let i=0; i<this.airGroups.length; i++) {
            const airgroup = this.airGroups[i];
            airgroup.airgroupId = i;

            const airgroupvalues = this.getAirgroupValuesByAirgroupId(i);

            for(let j=0; j<airgroup.airs.length; j++) {
                const air = airgroup.airs[j];
                air.airgroupId = i;
                air.airId = j;

                air.symbols = this.getSymbolsByAirgroupIdAirId(airgroup.airgroupId, air.airId);

                for(const airgroupValue of airgroupvalues) {
                    air.symbols.push( { ...airgroupValue, airId: j });
                }
                air.hints = this.getHintsByAirgroupIdAirId(airgroup.airgroupId, air.airId);
                air.numChallenges = this.numChallenges;
                air.airGroupValues = airgroup.airGroupValues;
                
                if(!air.constraints) {
                    log.error(`[Airout    ]`, `Air ${air.airId} of airgroup ${air.airgroupId} does not have any constraint!`);
                    throw new Error(`Air ${air.airId} of airgroup ${air.airgroupId} does not have any constraint!`);
                }
            }
        }
    }

    printInfo() {
        log.info("[AirOut    ]", `··· AirOut Info`);
        log.info("[AirOut    ]", `    Name: ${this.name}`);
        log.info("[AirOut    ]", `    #Airgroups: ${this.airGroups.length}`);

        log.info("[AirOut    ]", `    #ProofValues: ${this.numProofValues}`);
        log.info("[AirOut    ]", `    #PublicValues: ${this.numPublicValues}`);

        if(this.publicTables) log.info("[AirOut    ]", `    #PublicTables: ${this.publicTables.length}`);
        if(this.expressions) log.info("[AirOut    ]", `    #Expressions: ${this.expressions.length}`);
        if(this.constraints) log.info("[AirOut    ]", `    #Constraints: ${this.constraints.length}`);
        if(this.hints) log.info("[AirOut    ]", `    #Hints: ${this.hints.length}`);
        if(this.symbols) log.info("[AirOut    ]", `    #Symbols: ${this.symbols.length}`);

        for(const airgroup of this.airGroups) this.printAirgroupInfo(airgroup);
    }

    printAirgroupInfo(airgroup) {
        log.info("[AirOut    ]", `    > Airgroup '${airgroup.name}':`);

        for(const air of airgroup.airs) this.printAirInfo(air);
    }

    printAirInfo(air) {
        log.info("[AirOut    ]", `       + Air '${air.name}'`);
        log.info("[AirOut    ]", `         NumRows:     ${air.numRows}`);
        log.info("[AirOut    ]", `         Stages:      ${air.stageWidths.length}`);
        log.info("[AirOut    ]", `         Expressions: ${air.expressions.length}`);
        log.info("[AirOut    ]", `         Constraints: ${air.constraints.length}`);
    }

    get numAirgroups() {
        return this.airGroups === undefined ? 0 : this.airGroups.length;
    }

    get numStages() {
        return this.numChallenges?.length ?? 1;
    }

    getAirByAirgroupIdAirId(airgroupId, airId) {
        if(this.airGroups === undefined) return undefined;
        if(this.airGroups[airgroupId].airs === undefined) return undefined;

        const air = this.airGroups[airgroupId].airs[airId];
        air.airgroupId = airgroupId;
        air.airId = airId;
        return air;
    }

    getNumChallenges(stageId) {
        if(this.numChallenges === undefined) return 0;

        return this.numChallenges[stageId - 1];
    }

    //TODO access to AirOut numPublicValues ?

    //TODO access to AirOut AirOutPublicTables ?

    getExpressionById(expressionId) {
        if(this.expressions === undefined) return undefined;

        return this.expressions[expressionId];
    }

    getSymbolById(symbolId) {
        if(this.symbols === undefined) return undefined;

        return this.symbols.find(symbol => symbol.id === symbolId);
    }

    getSymbolByName(name) {
        if(this.symbols === undefined) return undefined;

        return this.symbols.find(symbol => symbol.name === name);
    }

    getSymbolsByAirgroupId(airgroupId) {
        if(this.symbols === undefined) return [];

        return this.symbols.filter(symbol => symbol.airGroupId === airgroupId);
    }

    getAirgroupValuesByAirgroupId(airgroupId) {
        if(this.symbols === undefined) return [];

        return this.symbols.filter(symbol => symbol.airGroupId === airgroupId && symbol.type === SYMBOL_TYPES.AIRGROUP_VALUE && symbol.airId === undefined);
    }

    getSymbolsByAirId(airId) {
        if(this.symbols === undefined) return [];

        return this.symbols.filter(symbol => symbol.airId === airId);
    }

    getSymbolsByAirgroupIdAirId(airgroupId, airId) {
        if(this.symbols === undefined) return [];

        return this.symbols.filter(
            (symbol) => (symbol.airGroupId === undefined) || (symbol.airGroupId === airgroupId && symbol.airId === airId));
    }

    getSymbolsByStage(airgroupId, airId, stageId, symbolType) {
        if (this.symbols === undefined) return [];
    
        const symbols = this.symbols.filter(symbol =>
            symbol.airGroupId === airgroupId &&
            symbol.airId === airId &&
            symbol.stage === stageId &&
            (symbolType === undefined || symbol.type === symbolType)
        );
    
        return symbols.sort((a, b) => a.id - b.id);
    }

    getColsByAirgroupIdAirId(airgroupId, airId) {
        if (this.symbols === undefined) return [];
    
        const symbols = this.symbols.filter(symbol =>
            symbol.airGroupId === airgroupId &&
            symbol.airId === airId &&
            ([1, 2, 3].includes(symbol.type))
        );
    
        return symbols.sort((a, b) => a.id - b.id);
    }

    getWitnessSymbolsByStage(airgroupId, airId, stageId) {
        return this.getSymbolsByStage(airgroupId, airId, stageId, SYMBOL_TYPES.WITNESS_COL);
    }

    getSymbolByName(name) {
        if(this.symbols === undefined) return undefined;

        return this.symbols.find(symbol => symbol.name === name);
    }

    getHintById(hintId) {
        if(this.hints === undefined) return undefined;

        return this.hints[hintId];
    }

    getHintsByAirgroupId(airgroupId) {
        if(this.hints === undefined) return [];

        return this.hints.filter(hint => hint.airGroupId === airgroupId);
    }

    getHintsByAirId(airId) {
        if(this.hints === undefined) return [];

        return this.hints.filter(hint => hint.airId === airId);
    }

    getHintsByAirgroupIdAirId(airgroupId, airId) {
        if(this.hints === undefined) return [];

        return this.hints.filter(
            (hint) => (hint.airGroupId === undefined) || ( hint.airGroupId === airgroupId && hint.airId === airId));
    }
}

module.exports = {
    AirOut,
    AGGREGATION_TYPES,
    SYMBOL_TYPES,
    HINT_FIELD_TYPES,
};
