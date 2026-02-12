const {
    readBinFile,
    startReadUniqueSection,
    endReadSection,
    createBinFile,
    endWriteSection,
    startWriteSection
} = require("@iden3/binfileutils");
const { writeStringToFile } = require("../chelpers/binFile");

const FIXED_POLS_SECTION = 1;

function fromRprLE(buff, o) {
    if (o & 7 == 0) {
        const v = new BigUint64Array(buff.buffer, o || 0, 1);
        return v[0];
    } else if ((o & 3)==0) {
        const v = new Uint32Array(buff.buffer, o || 0, 2);
        return BigInt(v[0]) |  (BigInt(v[1]) << 32n);
    } else if ((o & 1)==0) {
        const v = new Uint16Array(buff.buffer, o || 0, 8);
        return   BigInt(v[0])         |
                (BigInt(v[1]) << 16n) |
                (BigInt(v[2]) << 32n) |
                (BigInt(v[3]) << 48n);
    } else {
        const v = new Uint8Array(buff.buffer, o || 0, 8);
        return   BigInt(v[0])         |
                (BigInt(v[1]) <<  8n) |
                (BigInt(v[2]) << 16n) |
                (BigInt(v[3]) << 24n) |
                (BigInt(v[4]) << 32n) |
                (BigInt(v[5]) << 40n) |
                (BigInt(v[6]) << 48n) |
                (BigInt(v[7]) << 56n);
    }
}

module.exports.readFixedPolsBin = async function readFixedPolsBin(fixedInfo, binFileName) {
    const { fd: fdBin, sections } = await readBinFile(binFileName, "cnst", 1, 1 << 25, 1 << 23);

    await startReadUniqueSection(fdBin, sections, FIXED_POLS_SECTION);
    const airgroupName = await fdBin.readString();
    const airName = await fdBin.readString();
    const N = await fdBin.readULE64();
    const nFixedPols = await fdBin.readULE32();
    const fixedPolsInfo = {};
    for(let i = 0; i < nFixedPols; ++i) {
        const name = await fdBin.readString();
        const n_lengths = await fdBin.readULE32();
        const lengths = [];
        for(let j = 0; j < n_lengths; ++j) {
            lengths.push(await fdBin.readULE32());
        }
        const buff = await fdBin.read(N * 8);
        const values = [];
        for (let l=0; l<N; l++) {
            values[l] = fromRprLE(buff, l*8);
        }
        if(!fixedPolsInfo[name]) {
            fixedPolsInfo[name] = [];
        }
        fixedPolsInfo[name].push({ lengths, values });
    }
    
    
    await endReadSection(fdBin);

    await fdBin.close();

    fixedInfo[`${airgroupName}_${airName}`] = fixedPolsInfo;
}

module.exports.writeFixedPolsBin = async function writeFixedPolsBin(binFileName, airgroupName, airName, N, fixedInfo) {
    const fdBin = await createBinFile(binFileName, "cnst", 1, 1, 1 << 23, 1 << 25);
    
    await startWriteSection(fdBin, 1);

    writeStringToFile(fdBin, airgroupName);
    writeStringToFile(fdBin, airName);
    await fdBin.writeULE64(N);
    await fdBin.writeULE32(fixedInfo.length);
    for(let i = 0; i < fixedInfo.length; ++i) {
        writeStringToFile(fdBin, fixedInfo[i].name);
        await fdBin.writeULE32(fixedInfo[i].lengths.length);
        for(let j = 0; j < fixedInfo[i].lengths.length; ++j) {
            await fdBin.writeULE32(fixedInfo[i].lengths[j]);
        }
        const buff = new Uint8Array(fixedInfo[i].values.length * 8);
        const view = new DataView(buff.buffer);
        for(let j = 0; j < fixedInfo[i].values.length; ++j) {
            view.setBigUint64(j * 8, fixedInfo[i].values[j], true);
        }
        await fdBin.write(buff);
    }
    await endWriteSection(fdBin);

    await fdBin.close();
}