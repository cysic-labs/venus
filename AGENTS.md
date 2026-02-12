# zkVM Project

This is a End-to-End zkVM, designed to provide real-time proof generation.

# Commands
- Try `module load intel/compiler cuda openmpi` to load compilation environments.
- `make setup` to compile everything needed to prove. 
- `make prove` and `make verify` will run an end-to-end proof generation and verification on a small ETH block
- `make clean && rm -rf ~/.zisk && make all` is "ultra-clean" re-build.

# Notice
- If `provingKey` folder is not found, check `/mnt/nas1/artifacts/pk.tgz` and if it exists, run `tar -xzf /mnt/nas1/artifacts/pk.tgz`, then you should find `provingKey`
- For ETH RPC URL, use `https://eth-mainnet.g.alchemy.com/v2/1eS7d8n49jM3v5RKb9Rkl`

# Rules
- Ideal file size is less then 1300 lines, if a file is more than 1800 lines, please split it into multiple modular and functional-equivalent files.
- Files in this project should contain English-only char, NO CJK and NO Emoji.
- Chat response to user should be in the same language as user's

# ExecPlans
When writing complex features or significant refactors, use an ExecPlan (as described in .agent/PLANS.md) from design to implementation.
The ExecPlan can be stored in `temp` folder as a living execution plan, the filename should be timestamp-ed like `ExecPlan-<YYYYMMDD-hhmmss>.md`, timestamp should use `date +"%Y%m%d-%H%M%S"`.
