---
name: matlab-simulink-agent
description: Build, inspect, run, and debug MATLAB Simulink simulations with programmatic model generation, local MATLAB help/doc lookup, toolbox checks, solver configuration, simulation execution, result export, and optional desktop workflows. Use when Codex is asked to operate MATLAB or Simulink, create or modify `.slx`/`.mdl` models, write `.m` scripts for Simulink automation, run `sim`, inspect blocks/parameters/logs, or perform control, signal, Simscape, or power-system simulation tasks.
---

# MATLAB Simulink Agent

## Overview

Use this skill to turn a simulation request into reproducible MATLAB/Simulink artifacts: scripts, models, run logs, exported data, and a short validation report. Prefer MATLAB and Simulink programmatic APIs over manual clicking; use desktop automation only when a task truly requires the UI.

Do not ingest, copy, or redistribute entire MathWorks documentation sets. Read local `help`, `doc`, installed help indexes, and official online documentation selectively for the task at hand, and quote only small excerpts when necessary.

## Workflow

1. **Frame the simulation**: identify the physical/control problem, required inputs, outputs, model fidelity, stop time, solver, sample time, units, and pass/fail criteria. Ask only for missing facts that block a correct model.
2. **Check the MATLAB environment**: run `scripts/check_matlab_env.sh` or an equivalent command to locate MATLAB and confirm required products. If the sandbox cannot launch MATLAB, give the user the exact terminal command.
3. **Read docs selectively**: use `references/doc-access.md` for local help/doc lookup. Start with `help`, `which`, `ver`, `license`, `find_system`, and installed help indexes before relying on memory.
4. **Build or modify the model reproducibly**: create `.m` scripts that call Simulink APIs such as `new_system`, `load_system`, `add_block`, `set_param`, `add_line`, `find_system`, `save_system`, and `sim`. Put generated models and outputs under an explicit project folder.
5. **Run and validate**: execute the script with `scripts/run_matlab_batch.sh`, inspect diagnostics, export plots/data, and verify that solver settings, dimensions, units, initial conditions, and logged outputs match the stated task.
6. **Report concrete artifacts**: list generated `.m`, `.slx`, `.mat`, `.csv`, image, and log files. Include residual assumptions and anything that still needs manual MATLAB verification.

## Resources

- `references/doc-access.md`: how to find and read MATLAB/Simulink help without copying full docs.
- `references/simulink-build-patterns.md`: repeatable patterns for creating, inspecting, simulating, and exporting Simulink models.
- `references/power-systems.md`: Simulink/Simscape Electrical guidance for power-system and transient-stability simulations.
- `scripts/check_matlab_env.sh`: locate MATLAB and optionally list installed products.
- `scripts/run_matlab_batch.sh`: run a MATLAB `.m` script in batch mode with consistent error handling.
- `scripts/read_matlab_help.m`: export selected `help` text for a MATLAB topic into a local file.
- `assets/examples/create_minimal_simulink_model.m`: minimal generated model example to copy and adapt.

## MATLAB/Simulink Rules

- Prefer scripts that rebuild the model from scratch. Do not depend on hidden manual UI state.
- Save generated models with deterministic names and close them with `close_system(model, 0)` or `close_system(model, 1)` as appropriate.
- Use explicit block paths and parameters. Verify uncertain block library paths with `load_system` and `find_system` before committing a script.
- Configure solver and stop time explicitly with `set_param(model, ...)`.
- Log only the signals needed for validation and export machine-readable results (`.mat` or `.csv`) when possible.
- Treat Simscape and power-system models as unit-sensitive. Document base values, sample times, solver choices, and assumptions.
- Never present a generated simulation as engineering truth without a successful run and sanity checks against expected behavior.

## Desktop Operation

Use MATLAB desktop/UI automation only when programmatic APIs are insufficient, such as inspecting a masked subsystem dialog, opening a scope layout, or interacting with an add-on manager. Before UI work, check whether a MATLAB MCP server or local MATLAB batch command is available; otherwise use the Computer Use skill for macOS UI actions.

For MATLAB installation, add-ons, and MCP setup, prefer official MathWorks tools and the repository-specific instructions already present in the user's environment. Do not change MATLAB preferences, install add-ons, or modify global Codex config unless the user explicitly asks.
