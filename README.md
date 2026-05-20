# MATLAB Simulink Agent Skill

This repository contains a Codex skill for doc-driven MATLAB/Simulink automation.

The skill focuses on:

- reading MATLAB/Simulink help selectively for the current task
- scanning the installed MATLAB release, products, help indexes, and Simulink availability
- inventorying Simulink libraries and block parameters before generating models
- checking local MATLAB products and licenses
- generating Simulink models with MATLAB scripts
- running simulations in batch mode
- repairing generated scripts from MATLAB diagnostics
- guiding users through legitimate fixes for permissions, licenses, missing toolboxes, startup failures, UI-only workflows, and hardware constraints
- exporting logs, plots, and validation data
- supporting power-system and transient-stability workflows

## Install locally

From this repository:

```bash
mkdir -p ~/.codex/skills
ln -s "$PWD/matlab-simulink-agent" ~/.codex/skills/matlab-simulink-agent
```

Restart Codex after installation.

## Optional MATLAB command path

If `matlab` is not on `PATH`, set:

```bash
export MATLAB_BIN=/Applications/MATLAB_R2025a.app/bin/matlab
```

Check the environment:

```bash
./matlab-simulink-agent/scripts/check_matlab_env.sh
RUN_MATLAB=1 ./matlab-simulink-agent/scripts/check_matlab_env.sh
```

If Codex is running in a restricted sandbox and MATLAB cannot create files under
`~/Library/Application Support/MathWorks`, run the same command from a normal
macOS Terminal session.

Run a MATLAB script:

```bash
./matlab-simulink-agent/scripts/run_matlab_batch.sh path/to/script.m
```

Create a capability report:

```matlab
addpath('matlab-simulink-agent/scripts')
matlab_capability_scan('matlab-capabilities.json')
matlab_doc_lookup('programmatic model editing', 'doc-programmatic-model-editing.txt')
simulink_inventory('simulink-inventory.json', "simulink", 4)
```

## Example

In MATLAB:

```matlab
addpath('matlab-simulink-agent/assets/examples')
create_minimal_simulink_model('generated-minimal-model')
```

Or from batch mode, create a small wrapper `.m` file that calls `create_minimal_simulink_model`.
