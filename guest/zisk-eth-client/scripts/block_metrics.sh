#!/bin/bash

WS_URL="ws://localhost:8546"
RPC_URL="http://localhost:8545"
INPUT_GEN_BIN_PATH="../target/release/input-gen"
INPUTS_PATH="$HOME/block_metrics/inputs"
ZIC_ELF_FILE="../../zisk-testvectors/eth-client/v0.9.0/elf/zisk-eth-client-bn254.elf"
OUTPUT_FOLDER="$HOME/block_metrics"
OUTPUT_CSV="$OUTPUT_FOLDER/block_metrics_bn254.csv"
OUTPUT_ERR_FOLDER="$OUTPUT_FOLDER/errors"
TMP_LINE="tmp.csv"
RECONNECT_DELAY=3

# Create necessary directories
mkdir -p "$OUTPUT_FOLDER" "$OUTPUT_ERR_FOLDER"

# Check required tools
for cmd in websocat jq awk; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: $cmd is not installed."
        exit 1
    fi
done

# Create output CSV with header if it doesn't exist
if [[ ! -f $OUTPUT_CSV ]]; then
    echo "date,block,txs,mgas,version,main_count,main_area,rom_count,rom_area,mem_count,mem_area,romdata_count,romdata_area,inputdata_count,inputdata_area,memalign_count,memalign_area,memalignrom_count,memalignrom_area,arith_count,arith_area,arithtable_count,arithtable_area,arithrangetable_count,arithrangetable_area,aritheq_count,aritheq_area,aritheqlttable_count,aritheqlttable_area,binary_count,binary_area,binaryadd_count,binaryadd_area,binarytable_count,binarytable_area,binaryextension_count,binaryextension_area,binaryextensiontable_count,binaryextensiontable_area,keccakf_count,keccakf_area,keccakftable_count,keccakftable_area,sha256f_count,sha256f_area,sha256ftable_count,sha256ftable_area,specifiedranges_count,specifiedranges_area,total_count,total_area" >> "$OUTPUT_CSV"
fi

# Main node WebSocket listener loop
while true; do
    echo "Connecting to node WebSocket at $WS_URL..."

    PIPE=$(mktemp -u)
    mkfifo "$PIPE"

    {
        echo '{"jsonrpc":"2.0","id":1,"method":"eth_subscribe","params":["newHeads"]}'
        tail -f /dev/null > "$PIPE"
    } > "$PIPE" &

    websocat -E "$WS_URL" < "$PIPE" | while read -r line; do
        block_hex=$(echo "$line" | jq -r '.params.result.number // empty')
        timestamp_hex=$(echo "$line" | jq -r '.params.result.timestamp // empty')

        if [[ -n "$block_hex" ]]; then
            block_num=$((16#${block_hex#0x}))

            if [[ -n "$timestamp_hex" ]]; then
                timestamp_unix=$((16#${timestamp_hex#0x}))
                timestamp_fmt=$(date -u -d @"$timestamp_unix" +"%d/%m/%Y %H:%M:%S")
            else
                timestamp_fmt=""
            fi

            echo "New block $block_num detected, generating input file..."
            start_time=$(date +%s)
            if ! $INPUT_GEN_BIN_PATH -b "$block_num" -r "$RPC_URL" -i "$INPUTS_PATH" > /dev/null 2> "${OUTPUT_ERR_FOLDER}/${block_num}.err"; then
                echo "Error running input-gen for block $block_num" >> "${OUTPUT_ERR_FOLDER}/${block_num}.err"
                continue
            else
                rm -f "${OUTPUT_ERR_FOLDER}/${block_num}.err"
            fi
            end_time=$(date +%s)
            elapsed=$((end_time - start_time))
            echo "Input file for block $block_num generated in $elapsed seconds"

            input_file=$(find "$INPUTS_PATH" -maxdepth 1 -type f -name "${block_num}_*.bin" | head -n 1)
            if [[ -f "$input_file" ]]; then
                filename=$(basename "$input_file")
                if [[ $filename =~ ${block_num}_([0-9]+)_([0-9]+)\.bin ]]; then
                    txs="${BASH_REMATCH[1]}"
                    mgas="${BASH_REMATCH[2]}"
                else
                    txs=""
                    mgas=""
                fi
            else
                echo "No input file found for block $block_num"
                continue
            fi

            echo "Executing block $block_num..."
            if ! cargo-zisk execute -e "$ZIC_ELF_FILE" -i "$input_file" -o "${block_num}.csv" > /dev/null 2>> "${OUTPUT_ERR_FOLDER}/${block_num}.err"; then
                echo "Error running cargo-zisk for block $block_num" >> "${OUTPUT_ERR_FOLDER}/${block_num}.err"
                continue
            else
                rm -f "${OUTPUT_ERR_FOLDER}/${block_num}.err"
            fi

            file=$(find . -maxdepth 1 -type f -name "${block_num}.csv" | head -n 1)
            if [[ -f "$file" ]]; then
                awk -F, -v ts="$timestamp_fmt" -v blk="$block_num" -v txs="$txs" -v mgas="$mgas" '
                BEGIN {
                    OFS = ",";
                    sections["main"] = "main";
                    sections["rom"] = "rom";
                    sections["mem"] = "mem";
                    sections["romdata"] = "romdata";
                    sections["inputdata"] = "inputdata";
                    sections["memalign"] = "memalign";
                    sections["memalignrom"] = "memalignrom";
                    sections["arith"] = "arith";
                    sections["arithtable"] = "arithtable";
                    sections["arithrangetable"] = "arithrangetable";
                    sections["aritheq"] = "aritheq";
                    sections["aritheqlttable"] = "aritheqlttable";
                    sections["binary"] = "binary";
                    sections["binaryadd"] = "binaryadd";
                    sections["binarytable"] = "binarytable";
                }
                NR == 2 { version = $1 }
                {
                    section = tolower($4);
                    if (section in sections) {
                        count_var = sections[section] "_count";
                        area_var = sections[section] "_area";
                        eval(count_var " = $5");
                        eval(area_var " = $6");
                    }
                }
                tolower($4)=="binaryextension" { binaryextension_count=$5; binaryextension_area=$6 }
                tolower($4)=="binaryextensiontable" { binaryextensiontable_count=$5; binaryextensiontable_area=$6 }
                tolower($4)=="keccakf" { keccakf_count=$5; keccakf_area=$6 }
                tolower($4)=="keccakftable" { keccakftable_count=$5; keccakftable_area=$6 }
                tolower($4)=="sha256f" { sha256f_count=$5; sha256f_area=$6 }
                tolower($4)=="sha256ftable" { sha256ftable_count=$5; sha256ftable_area=$6 }
                tolower($4)=="specifiedranges" { specifiedranges_count=$5; specifiedranges_area=$6 }
                tolower($0) ~ /,total,/ { total_count=$5; total_area=$6 + 0 }
                END {
                    printf "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n",
                        ts, blk, txs, mgas, version,
                        main_count, main_area, rom_count, rom_area, mem_count, mem_area,
                        romdata_count, romdata_area, inputdata_count, inputdata_area,
                        memalign_count, memalign_area, memalignrom_count, memalignrom_area,
                        arith_count, arith_area, arithtable_count, arithtable_area,
                        arithrangetable_count, arithrangetable_area, aritheq_count, aritheq_area,
                        aritheqlttable_count, aritheqlttable_area, binary_count, binary_area,
                        binaryadd_count, binaryadd_area, binarytable_count, binarytable_area,
                        binaryextension_count, binaryextension_area,
                        binaryextensiontable_count, binaryextensiontable_area,
                        keccakf_count, keccakf_area, keccakftable_count, keccakftable_area,
                        sha256f_count, sha256f_area, sha256ftable_count, sha256ftable_area,
                        specifiedranges_count, specifiedranges_area,
                        total_count, total_area
                }
                ' "$file" > "$TMP_LINE"

                cat "$TMP_LINE" >> "$OUTPUT_CSV"
                rm -f "$TMP_LINE"
                rm -f "$file"

                echo "Metrics for block $block_num stored"
            else
                echo "No CSV file found for block $block_num"
            fi
        fi
    done

    echo "Disconnected from node WebSocket. Reconnecting in $RECONNECT_DELAY seconds..."
    rm -f "$PIPE"
    sleep "$RECONNECT_DELAY"
done
