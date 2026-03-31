# Soundness Review

## All 35 AIRs

| AIR | nConst | nConstr | nStages | qDeg | nBits | nBitsExt | nQueries | powBits | arity | ops | cm | vk | .bin | .vbin |
|-----|--------|---------|---------|------|-------|---------|---------|---------|-------|-----|----|----|------|------|
| Add256 | OK | 36->245 | OK | 2->1 | OK | OK | OK | OK | OK | 3->2 | 66->65 | OK,nz=Y | 82870->168008 | 15202->33724 |
| Arith | OK | 65->271 | OK | OK | OK | OK | OK | OK | OK | 3->2 | OK | OK,nz=Y | 69708->161970 | 17226->38646 |
| ArithEq | OK | 103->311 | OK | OK | OK | OK | 231->230 | OK | OK | 36->16 | 59->58 | OK,nz=Y | 1078127->417460 | 494027->150716 |
| ArithEq384 | OK | 76->284 | OK | OK | OK | OK | 232->230 | OK | OK | 54->24 | 49->48 | D,nz=Y | 1227823->596359 | 566402->236529 |
| Binary | OK | 14->220 | OK | 2->1 | OK | OK | OK | OK | OK | 3->2 | 46->45 | OK,nz=Y | 41882->162961 | 7985->24969 |
| BinaryAdd | OK | 9->216 | OK | 2->1 | OK | OK | OK | OK | OK | 3->2 | 15->14 | OK,nz=Y | 13377->99927 | 2769->20050 |
| BinaryExtension | OK | 8->217 | OK | 2->1 | OK | OK | OK | OK | OK | 3->2 | OK | OK,nz=Y | 36118->150886 | 6913->23684 |
| Blake2br | OK | 189->377 | OK | 2->1 | OK | OK | 230->229 | OK | OK | 29->9 | 177->170 | D,nz=Y | 418685->174683 | 130921->44477 |
| Dma | OK | OK | OK | 2->1 | OK | OK | OK | OK | OK | 3->2 | 43->39 | OK,nz=Y | 58032->28923 | 10995->7864 |
| Dma64Aligned | OK | 88->72 | OK | 2->1 | OK | OK | 230->229 | OK | OK | 3->2 | OK | OK,nz=Y | 96025->41083 | 18164->10732 |
| Dma64AlignedInputCpy | OK | 52->41 | OK | 2->1 | OK | OK | OK | OK | OK | 3->2 | 36->37 | OK,nz=Y | 61819->29623 | 11197->7596 |
| Dma64AlignedMem | OK | 81->69 | OK | OK | OK | OK | 229->228 | OK | OK | 3->2 | 34->33 | OK,nz=Y | 68851->31567 | 14094->8710 |
| Dma64AlignedMemCpy | OK | 69->64 | OK | 2->1 | OK | OK | OK | OK | OK | 3->2 | OK | OK,nz=Y | 85015->41204 | 16074->10775 |
| Dma64AlignedMemSet | OK | 62->52 | OK | 2->1 | OK | OK | 229->228 | OK | OK | 3->2 | 21->22 | OK,nz=Y | 65098->25552 | 11161->7265 |
| DmaInputCpy | OK | 20->19 | OK | 2->1 | OK | OK | OK | OK | OK | 3->2 | 24->22 | OK,nz=Y | 31949->21136 | 5875->5918 |
| DmaMemCpy | OK | 22->21 | OK | 2->1 | OK | OK | OK | OK | OK | 3->2 | 30->27 | OK,nz=Y | 38036->22548 | 6979->6122 |
| DmaPrePost | OK | 69->86 | OK | OK | OK | OK | 230->229 | OK | OK | 3->2 | 80->74 | OK,nz=Y | 101470->52503 | 22054->13272 |
| DmaPrePostInputCpy | OK | 20->62 | OK | 2->1 | OK | OK | OK | OK | OK | 3->2 | 41->38 | OK,nz=Y | 33299->41835 | 7440->10739 |
| DmaPrePostMemCpy | OK | 38->69 | OK | 2->1 | OK | OK | 230->229 | OK | OK | 3->2 | 67->57 | OK,nz=Y | 78599->48316 | 17560->10411 |
| DmaUnaligned | OK | 75->69 | OK | OK | OK | OK | OK | OK | OK | 3->2 | OK | OK,nz=Y | 73073->45677 | 15335->14163 |
| InputData | OK | 30->217 | OK | 2->1 | OK | OK | 229->228 | OK | OK | 3->2 | 17->12 | OK,nz=Y | 28579->95360 | 5793->20091 |
| Keccakf | OK | 2432->1840 | OK | OK | OK | OK | 217->216 | OK | OK | 26->5 | 2432->2165 | D,nz=Y | 5475189->524110 | 1433260->221372 |
| Main | OK | 144->227 | OK | OK | OK | OK | OK | OK | OK | 3->2 | 48->53 | OK,nz=Y | 267042->234645 | 37947->54086 |
| Mem | OK | 34->206 | OK | 2->1 | OK | OK | 230->229 | OK | OK | 3->2 | 18->16 | OK,nz=Y | 28767->94161 | 6404->19793 |
| MemAlign | OK | 40->239 | OK | 2->1 | OK | OK | 230->229 | OK | OK | 3->2 | 37->36 | OK,nz=Y | 37097->109268 | 10567->23405 |
| MemAlignByte | OK | 16->215 | OK | OK | OK | OK | OK | OK | OK | 3->2 | OK | OK,nz=Y | 23161->108883 | 5019->22138 |
| MemAlignReadByte | OK | 10->211 | OK | OK | OK | OK | OK | OK | OK | 3->2 | OK | OK,nz=Y | 16061->98436 | 3651->20736 |
| MemAlignWriteByte | OK | 15->218 | OK | OK | OK | OK | OK | OK | OK | 3->2 | OK | OK,nz=Y | 23794->111698 | 4934->22529 |
| Poseidon2 | OK | 85->219 | OK | 3->2 | OK | OK | OK | OK | OK | 17->12 | 59->42 | D,nz=Y | 672382->153581 | 52854->34688 |
| Rom | OK | 3->176 | OK | OK | OK | OK | 221->219 | OK | OK | 3->2 | 4->2 | OK,nz=Y | 4570->69674 | 1701->15615 |
| RomData | OK | 23->205 | OK | 2->1 | OK | OK | 229->228 | OK | OK | 3->2 | 11->10 | OK,nz=Y | 17987->84713 | 4103->18842 |
| Sha256f | OK | 115->321 | OK | 2->1 | OK | OK | 231->229 | OK | OK | 87->66 | 111->107 | D,nz=Y | 520555->171824 | 172940->36802 |
| SpecifiedRanges | 59->67 | 16->259 | OK | 2->1 | OK | OK | OK | OK | OK | 3->2 | OK | D,nz=Y | 58206->134309 | 9887->30261 |
| VirtualTable0 | OK | 6->248 | OK | 2->1 | OK | OK | OK | OK | OK | 3->2 | 15->14 | D,nz=Y | 23837->133160 | 6096->25909 |
| VirtualTable1 | OK | 6->248 | OK | 2->1 | OK | OK | OK | OK | OK | 3->2 | 15->14 | D,nz=Y | 30151->151384 | 7881->27694 |

## Step 7: 10-AIR Targeted

### ArithEq
- nConstants: MATCH
- nConstraints: DIFFER (103->311)
- nStages: MATCH
- qDeg: MATCH
- qDim: MATCH
- nBits: MATCH
- nBitsExt: MATCH
- nQueries: DIFFER (231->230)
- powBits: MATCH
- merkleTreeArity: MATCH
- openingPoints: DIFFER (36->16)
- cmPolsMap: DIFFER (59->58)
- .bin: DIFFER (1078127->417460)
- .verifier.bin: DIFFER (494027->150716)

### ArithEq384
- nConstants: MATCH
- nConstraints: DIFFER (76->284)
- nStages: MATCH
- qDeg: MATCH
- qDim: MATCH
- nBits: MATCH
- nBitsExt: MATCH
- nQueries: DIFFER (232->230)
- powBits: MATCH
- merkleTreeArity: MATCH
- openingPoints: DIFFER (54->24)
- cmPolsMap: DIFFER (49->48)
- .bin: DIFFER (1227823->596359)
- .verifier.bin: DIFFER (566402->236529)

### Blake2br
- nConstants: MATCH
- nConstraints: DIFFER (189->377)
- nStages: MATCH
- qDeg: DIFFER (2->1)
- qDim: MATCH
- nBits: MATCH
- nBitsExt: MATCH
- nQueries: DIFFER (230->229)
- powBits: MATCH
- merkleTreeArity: MATCH
- openingPoints: DIFFER (29->9)
- cmPolsMap: DIFFER (177->170)
- .bin: DIFFER (418685->174683)
- .verifier.bin: DIFFER (130921->44477)

### Keccakf
- nConstants: MATCH
- nConstraints: DIFFER (2432->1840)
- nStages: MATCH
- qDeg: MATCH
- qDim: MATCH
- nBits: MATCH
- nBitsExt: MATCH
- nQueries: DIFFER (217->216)
- powBits: MATCH
- merkleTreeArity: MATCH
- openingPoints: DIFFER (26->5)
- cmPolsMap: DIFFER (2432->2165)
- .bin: DIFFER (5475189->524110)
- .verifier.bin: DIFFER (1433260->221372)

### Poseidon2
- nConstants: MATCH
- nConstraints: DIFFER (85->219)
- nStages: MATCH
- qDeg: DIFFER (3->2)
- qDim: MATCH
- nBits: MATCH
- nBitsExt: MATCH
- nQueries: MATCH
- powBits: MATCH
- merkleTreeArity: MATCH
- openingPoints: DIFFER (17->12)
- cmPolsMap: DIFFER (59->42)
- .bin: DIFFER (672382->153581)
- .verifier.bin: DIFFER (52854->34688)

### Rom
- nConstants: MATCH
- nConstraints: DIFFER (3->176)
- nStages: MATCH
- qDeg: MATCH
- qDim: MATCH
- nBits: MATCH
- nBitsExt: MATCH
- nQueries: DIFFER (221->219)
- powBits: MATCH
- merkleTreeArity: MATCH
- openingPoints: DIFFER (3->2)
- cmPolsMap: DIFFER (4->2)
- .bin: DIFFER (4570->69674)
- .verifier.bin: DIFFER (1701->15615)

### Sha256f
- nConstants: MATCH
- nConstraints: DIFFER (115->321)
- nStages: MATCH
- qDeg: DIFFER (2->1)
- qDim: MATCH
- nBits: MATCH
- nBitsExt: MATCH
- nQueries: DIFFER (231->229)
- powBits: MATCH
- merkleTreeArity: MATCH
- openingPoints: DIFFER (87->66)
- cmPolsMap: DIFFER (111->107)
- .bin: DIFFER (520555->171824)
- .verifier.bin: DIFFER (172940->36802)

### SpecifiedRanges
- nConstants: DIFFER (59->67)
- nConstraints: DIFFER (16->259)
- nStages: MATCH
- qDeg: DIFFER (2->1)
- qDim: MATCH
- nBits: MATCH
- nBitsExt: MATCH
- nQueries: MATCH
- powBits: MATCH
- merkleTreeArity: MATCH
- openingPoints: DIFFER (3->2)
- cmPolsMap: MATCH
- .bin: DIFFER (58206->134309)
- .verifier.bin: DIFFER (9887->30261)

### VirtualTable0
- nConstants: MATCH
- nConstraints: DIFFER (6->248)
- nStages: MATCH
- qDeg: DIFFER (2->1)
- qDim: MATCH
- nBits: MATCH
- nBitsExt: MATCH
- nQueries: MATCH
- powBits: MATCH
- merkleTreeArity: MATCH
- openingPoints: DIFFER (3->2)
- cmPolsMap: DIFFER (15->14)
- .bin: DIFFER (23837->133160)
- .verifier.bin: DIFFER (6096->25909)

### VirtualTable1
- nConstants: MATCH
- nConstraints: DIFFER (6->248)
- nStages: MATCH
- qDeg: DIFFER (2->1)
- qDim: MATCH
- nBits: MATCH
- nBitsExt: MATCH
- nQueries: MATCH
- powBits: MATCH
- merkleTreeArity: MATCH
- openingPoints: DIFFER (3->2)
- cmPolsMap: DIFFER (15->14)
- .bin: DIFFER (30151->151384)
- .verifier.bin: DIFFER (7881->27694)

## Missing Fields
- blowUpFactor: derived from nBitsExt-nBits (both match)
- proximityGap: not in schema

## Conclusion
nBits/nBitsExt/powBits/arity: MATCH all 35. nConstraints/openingPoints/qDeg: differ (compiler). All verkeys non-zero. Prove/verify needed for final confirmation (blocked by prover regression).
