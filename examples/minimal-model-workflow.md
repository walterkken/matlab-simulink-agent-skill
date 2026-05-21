# Example: Minimal Simulink Model Workflow

## User Request

```text
Create a minimal Simulink model with a Step source, Gain block, and exported output.
```

## Agent Steps

1. Run `check_matlab_env.sh`.
2. Use `matlab_capability_scan.m` if MATLAB starts.
3. Use `simulink_inventory.m` to verify block paths.
4. Generate a MATLAB script using `new_system`, `add_block`, `set_param`, `add_line`, and `sim`.
5. Export `.slx`, `.csv`, `.png`, and `.mat`.
6. Report solver settings and generated files.

## Expected Artifacts

- `minimal_gain_model.slx`
- `minimal_gain_model_output.csv`
- `minimal_gain_model_output.png`
- `minimal_gain_model_simout.mat`
