---
name: matlab-simulink-agent
description: "Build, inspect, run, and debug MATLAB Simulink simulations through doc-driven automation: local MATLAB help/doc lookup, installed-product capability scans, Simulink library/block inventory, toolbox checks, solver configuration, generated `.m` scripts, simulation execution, error-driven repair, result export, and optional desktop workflows. Use when Codex is asked to operate MATLAB or Simulink, create or modify `.slx`/`.mdl` models, automate tasks described in MATLAB documentation, run `sim`, inspect blocks/parameters/logs, or perform control, signal, Simscape, or power-system simulation tasks."
---

# MATLAB Simulink Agent

## Overview

Use this skill to turn a MATLAB/Simulink request into reproducible artifacts by retrieving the relevant installed MATLAB knowledge first, then generating code, running it, and repairing it from diagnostics. Prefer MATLAB and Simulink programmatic APIs over manual clicking; use desktop automation only when a task truly requires the UI.

The operating goal is: if the installed MATLAB release, installed products, licenses, and documentation expose a supported API or workflow, automate it as far as possible. Do not promise success for missing toolboxes, expired licenses, UI-only operations, external hardware, or tasks that require engineering judgment beyond the user's stated model.

Do not ingest, copy, or redistribute entire MathWorks documentation sets. Read local `help`, installed help indexes, examples, object metadata, Simulink block parameters, and official online documentation selectively for the task at hand, and quote only small excerpts when necessary.

## Workflow

1. **Frame the task**: identify objective, products/toolboxes, inputs, outputs, model fidelity, solver, stop time, units, and pass/fail criteria. Ask only for missing facts that block a correct automation plan.
2. **Scan capabilities**: run `scripts/check_matlab_env.sh` and, when MATLAB can start, `scripts/matlab_capability_scan.m` to capture release, products, help indexes, path roots, and Simulink availability.
3. **Retrieve task knowledge**: use `references/doc-driven-automation.md` and `references/doc-access.md`. Pull only relevant `help`, `which`, `lookfor`, installed help-index matches, object metadata, examples, and block parameters.
4. **Inventory Simulink when needed**: run `scripts/simulink_inventory.m` on the required libraries before choosing block paths or parameters.
5. **Generate reproducible automation**: create `.m` scripts that call documented APIs such as `new_system`, `load_system`, `add_block`, `set_param`, `add_line`, `find_system`, `save_system`, and `sim`. Put generated models and outputs under an explicit project folder.
6. **Run, inspect, repair**: execute with `scripts/run_matlab_batch.sh`, read diagnostics, retrieve missing docs/metadata, patch the script, and rerun until success or a real blocker is identified.
7. **Validate and report**: export plots/data/logs, verify solver settings, dimensions, units, initial conditions, logged outputs, and pass/fail criteria. List concrete artifacts and residual assumptions.

## Resources

- `references/doc-access.md`: how to find and read MATLAB/Simulink help without copying full docs.
- `references/doc-driven-automation.md`: retrieval-action loop for automating anything documented and available in the installed MATLAB environment.
- `references/simulink-build-patterns.md`: repeatable patterns for creating, inspecting, simulating, and exporting Simulink models.
- `references/power-systems.md`: Simulink/Simscape Electrical guidance for power-system and transient-stability simulations.
- `scripts/check_matlab_env.sh`: locate MATLAB and optionally list installed products.
- `scripts/run_matlab_batch.sh`: run a MATLAB `.m` script in batch mode with consistent error handling.
- `scripts/read_matlab_help.m`: export selected `help` text for a MATLAB topic into a local file.
- `scripts/matlab_doc_lookup.m`: collect topic-specific help, `which`, `lookfor`, and installed help-index matches into a task-local report.
- `scripts/matlab_capability_scan.m`: write a JSON capability report for MATLAB release, installed products, paths, and Simulink status.
- `scripts/simulink_inventory.m`: inventory libraries, block paths, block types, mask types, and dialog parameter names for reliable `add_block`/`set_param` generation.
- `assets/examples/create_minimal_simulink_model.m`: minimal generated model example to copy and adapt.

## MATLAB/Simulink Rules

- Prefer scripts that rebuild the model from scratch. Do not depend on hidden manual UI state.
- Save generated models with deterministic names and close them with `close_system(model, 0)` or `close_system(model, 1)` as appropriate.
- Use explicit block paths and parameters. Verify uncertain block library paths with `load_system` and `find_system` before committing a script.
- For unfamiliar functions, classes, blocks, or parameters, retrieve documentation/metadata first. Do not guess when MATLAB can answer with `help`, `which`, `methods`, `properties`, `get_param`, `find_system`, or a help index.
- Configure solver and stop time explicitly with `set_param(model, ...)`.
- Log only the signals needed for validation and export machine-readable results (`.mat` or `.csv`) when possible.
- Treat Simscape and power-system models as unit-sensitive. Document base values, sample times, solver choices, and assumptions.
- Never present a generated simulation as engineering truth without a successful run and sanity checks against expected behavior.

## Desktop Operation

Use MATLAB desktop/UI automation only when programmatic APIs are insufficient, such as inspecting a masked subsystem dialog, opening a scope layout, or interacting with an add-on manager. Before UI work, check whether a MATLAB MCP server or local MATLAB batch command is available; otherwise use the Computer Use skill for macOS UI actions.

For MATLAB installation, add-ons, and MCP setup, prefer official MathWorks tools and the repository-specific instructions already present in the user's environment. Do not change MATLAB preferences, install add-ons, or modify global Codex config unless the user explicitly asks.
