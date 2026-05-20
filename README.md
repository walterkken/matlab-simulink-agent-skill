# MATLAB Simulink Agent Skill

This repository contains a Codex skill for MATLAB/Simulink simulation work.

The skill focuses on:

- reading MATLAB/Simulink help selectively for the current task
- checking local MATLAB products and licenses
- generating Simulink models with MATLAB scripts
- running simulations in batch mode
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

## Example

In MATLAB:

```matlab
addpath('matlab-simulink-agent/assets/examples')
create_minimal_simulink_model('generated-minimal-model')
```

Or from batch mode, create a small wrapper `.m` file that calls `create_minimal_simulink_model`.
