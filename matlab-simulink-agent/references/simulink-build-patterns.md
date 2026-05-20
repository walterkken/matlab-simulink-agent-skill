# Simulink Build Patterns

Use this reference when creating or modifying `.slx` or `.mdl` models programmatically.

## Minimal model script pattern

```matlab
model = 'my_model';
outdir = fullfile(pwd, 'generated');
if ~exist(outdir, 'dir'); mkdir(outdir); end

if bdIsLoaded(model)
    close_system(model, 0);
end

new_system(model);
load_system('simulink');

add_block('simulink/Sources/Step', [model '/Step']);
add_block('simulink/Math Operations/Gain', [model '/Gain'], 'Gain', '2');
add_block('simulink/Sinks/To Workspace', [model '/To Workspace'], ...
    'VariableName', 'y', 'SaveFormat', 'StructureWithTime');

add_line(model, 'Step/1', 'Gain/1', 'autorouting', 'on');
add_line(model, 'Gain/1', 'To Workspace/1', 'autorouting', 'on');

set_param(model, 'StopTime', '10', 'Solver', 'ode45');
save_system(model, fullfile(outdir, [model '.slx']));
simOut = sim(model, 'ReturnWorkspaceOutputs', 'on');
```

Prefer scripts that can be rerun after deleting generated artifacts.

## Block discovery

When a library path is uncertain, query before use:

```matlab
load_system('simulink')
find_system('simulink', 'SearchDepth', 3, 'Name', 'Gain')
find_system('simulink', 'BlockType', 'Gain')
```

For toolbox libraries, load the expected library first. If `load_system` fails, report the missing toolbox or library instead of guessing.

## Parameter inspection

Use `get_param` to discover legal names and current values:

```matlab
get_param([model '/Gain'], 'DialogParameters')
get_param(model, 'ObjectParameters')
set_param([model '/Gain'], 'Gain', '5')
```

For masked blocks:

```matlab
get_param(blockPath, 'MaskNames')
get_param(blockPath, 'MaskValues')
```

## Solver and simulation configuration

Always set these explicitly for generated models:

```matlab
set_param(model, ...
    'StopTime', '10', ...
    'Solver', 'ode45', ...
    'ReturnWorkspaceOutputs', 'on');
```

For discrete models, set sample times on source/control blocks and choose a discrete solver or fixed-step configuration intentionally. For stiff continuous or Simscape models, use a solver appropriate to the domain and validate with diagnostics.

## Logging and export

Use `To Workspace`, signal logging, or `Simulink.SimulationData.Dataset` depending on model complexity. Export validation data in a format the user can inspect:

```matlab
simOut = sim(model, 'ReturnWorkspaceOutputs', 'on');
y = simOut.get('y');
T = table(y.time, y.signals.values, 'VariableNames', {'time','value'});
writetable(T, fullfile(outdir, 'output.csv'));
```

For plots:

```matlab
fig = figure('Visible', 'off');
plot(T.time, T.value);
grid on;
saveas(fig, fullfile(outdir, 'output.png'));
close(fig);
```

## Validation checklist

- Model opens or loads without missing-library errors.
- Required products are present.
- Solver, stop time, and sample time are explicit.
- Signal dimensions and units are plausible.
- Logged variables exist and have expected length and numeric ranges.
- Model is saved and can be rebuilt from source script.
- User-facing summary names the exact files produced.
