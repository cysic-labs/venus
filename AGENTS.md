# Venus zkVM Project

This is a End-to-End zkVM, designed to provide real-time proof generation.

# Commands
- Try `module load intel/compiler cuda openmpi` to load compilation environments.
- `make setup` to compile everything needed to prove. 
- `make prove` and `make verify` will run an end-to-end proof generation and verification on a small ETH block
- `make clean` can clean most of compiled artifacts. `make purge` will further delete provingKey

# Rules
- Ideal file size is less then 1300 lines, if a file is more than 1800 lines, please split it into multiple modular and functional-equivalent files.
- Files in this project should contain English-only char, NO CJK and NO Emoji.
- Chat response to user should be in the same language as user's

# ExecPlans
When writing complex features or significant refactors, use an ExecPlan (as described in .agent/PLANS.md) from design to implementation.
The ExecPlan can be stored in `temp` folder as a living execution plan, the filename should be timestamp-ed like `ExecPlan-<YYYYMMDD-hhmmss>.md`, timestamp should use `date +"%Y%m%d-%H%M%S"`.
