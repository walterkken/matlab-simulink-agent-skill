# Doc-Driven MATLAB Automation

Use this reference when the user expects automation based on anything MATLAB documents and the local installation can support.

## Principle

Do not hard-code narrow knowledge when MATLAB can provide the answer. Build a retrieval-action loop:

1. Translate the user request into MATLAB products, functions, classes, blocks, examples, and validation criteria.
2. Query the local MATLAB installation for capabilities and docs.
3. Generate the smallest reproducible script that performs the task.
4. Run the script.
5. Use errors, warnings, missing paths, and diagnostics to retrieve more docs/metadata.
6. Patch and rerun until the artifact is produced or a real blocker is proven.

## Information sources

Use these before guessing:

- `ver`, `version`, `matlabroot`, `path`, `license`
- `which`, `help`, `lookfor`, `doc`, `docsearch`
- installed help indexes such as `helpfuncbycat.xml`
- `methods`, `properties`, `meta.class.fromName`
- `exist`, `what`, `dir`, `matlab.codetools.requiredFilesAndProducts`
- Simulink APIs: `load_system`, `find_system`, `get_param`, `set_param`, `Simulink.findBlocks`, `Simulink.findBlocksOfType`
- Simulink block metadata: `DialogParameters`, `ObjectParameters`, `MaskNames`, `MaskValues`, `ReferenceBlock`
- generated examples or copied examples only when the user has access and the license permits using them

## Retrieval order

For a request like "build a Simulink simulation of X":

1. Product scan: identify whether Simulink, Simscape, Signal Processing Toolbox, Control System Toolbox, Simscape Electrical, or other required products are installed.
2. Function/topic docs: run `matlab_doc_lookup` for the key functions/classes/blocks.
3. Library scan: run `simulink_inventory` for candidate libraries before choosing block paths.
4. Parameter scan: create a small MATLAB probe script to call `get_param(blockPath, 'DialogParameters')` or inspect class properties.
5. Generate script: produce a full `.m` automation script, not a manual instruction list.
6. Run and repair: iterate from MATLAB's actual errors.

## Automation target

The preferred final output is a folder containing:

- one main script, for example `build_and_run_model.m`
- generated `.slx` or `.mdl` model files
- exported `.mat` and `.csv` results
- exported plots, screenshots, or reports when useful
- a short validation note with the exact MATLAB release and products used

## Limits to state plainly

Automation may stop when:

- the required product/toolbox is not installed or licensed
- the documented workflow is interactive-only and has no stable API
- the task requires physical hardware, credentials, or external services
- MATLAB startup, license checkout, or add-on installation is blocked
- the user has not provided enough model equations, parameters, topology, or validation criteria

In those cases, report the concrete blocker and the smallest user action needed to continue.
