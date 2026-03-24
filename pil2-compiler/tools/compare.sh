#!/bin/bash
TMP_DIR=../pil2-compiler/tmp
echo -e "\n\x1B[1;35m########### delete previous temporally files ($TMP_DIR) #########\x1B[0m\n"
for T in legacy current; do
	[ -f $TMP_DIR/$T.pilout ] && rm -f $TMP_DIR/$T.pilout
	[ -f $TMP_DIR/$T.txt ] && rm -f $TMP_DIR/$T.txt
done
echo -e "\n\x1B[1;35m############ compiling legacy pil #############\x1B[0m\n"
(cd ../pil2-compiler.legacy; node src/pil.js $1 -o $TMP_DIR/legacy.pilout)
echo -e "\n\x1B[1;35m########### compiling current pil ############\x1B[0m\n"
(cd ../pil2-compiler; node src/pil.js $1 -o $TMP_DIR/current.pilout)
echo -e "\n\x1B[1;35m########### generating txt files from pilout to compare #########\x1B[0m\n"
for T in legacy current; do
	[ ! -f  $TMP_DIR/$T.pilout ] && echo -e "\x1B[1;31mERROR $TMP_DIR/$T.pilout not found\x1B[0m" && exit 1
done
protoc --decode=pilout.PilOut --proto_path=../pil2-compiler/src pilout.proto < $TMP_DIR/legacy.pilout > $TMP_DIR/legacy.txt
protoc --decode=pilout.PilOut --proto_path=../pil2-compiler/src pilout.proto < $TMP_DIR/current.pilout > $TMP_DIR/current.txt
echo -e "\n\x1B[1;35m########### compare txt files #########\x1B[0m\n"
for T in legacy current; do
	[ ! -f  $TMP_DIR/$T.txt ] && echo -e "\x1B[1;31mERROR $TMP_DIR/$T.txt not found\x1B[0m" && exit 1
done
diff --width=200 --suppress-common-lines --side-by-side $TMP_DIR/legacy.txt $TMP_DIR/current.txt | uniq -c 
