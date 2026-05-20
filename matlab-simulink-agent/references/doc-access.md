# MATLAB Help and Documentation Access

Use this reference when a task requires MATLAB or Simulink API details, block paths, solver options, or toolbox availability.

## First checks

Run these in MATLAB when possible:

```matlab
version
ver
license('test','Simulink')
which sim
which add_block
which set_param
which find_system
```

Use `ver` output to confirm products before using toolbox-specific APIs. For generated models, fail early if a required product is missing.

## Selective help lookup

Prefer small, task-specific lookups:

```matlab
help sim
help add_block
help set_param
help find_system
help Simulink.SimulationInput
lookfor "programmatic model"
doc sim
docsearch "programmatic model editing"
```

`doc` and `docsearch` may open the MATLAB desktop. In headless or sandboxed sessions, use `help` or inspect installed help indexes.

## Installed help indexes

On macOS MATLAB app installs, useful local indexes often exist under paths like:

```text
/Applications/MATLAB_R2025a.app/help/simulink/helpfuncbycat.xml
/Applications/MATLAB_R2025a.app/help/matlab/helpfuncbycat.xml
```

Use shell search for navigation, not bulk copying:

```bash
rg -n "programmatic|add_block|set_param|find_system|sim" /Applications/MATLAB_R2025a.app/help/simulink
```

The installed docs may include search indexes instead of plain HTML pages. If only binary/search-index files are present, use MATLAB `help`, `docsearch`, or official web docs instead.

## Export a small help note

Use `scripts/read_matlab_help.m` from this skill:

```bash
scripts/run_matlab_batch.sh path/to/export_help.m
```

Example `export_help.m`:

```matlab
addpath('path/to/matlab-simulink-agent/scripts')
read_matlab_help('sim', 'sim-help.txt')
read_matlab_help('add_block', 'add-block-help.txt')
```

Keep exported help files task-local. Do not commit large documentation dumps into generated projects or GitHub repositories.

## Documentation policy

- Read only the docs needed for the requested task.
- Cite official MathWorks documentation links when giving user-facing explanations that depend on exact behavior.
- Do not copy complete MathWorks pages, examples, or installed documentation into a skill, repo, report, or answer.
- Treat documentation as versioned by MATLAB release; record the release when behavior may differ.
