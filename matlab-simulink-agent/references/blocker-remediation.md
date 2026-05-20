# Blocker Remediation

Use this reference when MATLAB/Simulink automation cannot proceed because of an environment, license, permission, product, UI, or hardware restriction.

## Response pattern

When a blocker appears, report:

1. **What is blocked**: the exact command, script, API, model, block, or file operation.
2. **Evidence**: the relevant error text, missing product, failed path, or failed permission check.
3. **Category**: one of the categories below.
4. **User action**: the smallest legitimate step the user can take.
5. **Retry command**: the exact command to rerun after the user fixes it.

Do not suggest bypassing licenses, disabling security broadly, using cracked products, or ignoring safety checks. Prefer narrow, reversible changes.

## Categories and fixes

### MATLAB executable not found

Evidence:

- `MATLAB_FOUND=0`
- `matlab: command not found`
- `/Applications/MATLAB_R*.app/bin/matlab` does not exist

Guide the user:

```bash
export MATLAB_BIN=/Applications/MATLAB_R2025a.app/bin/matlab
./matlab-simulink-agent/scripts/check_matlab_env.sh
```

If MATLAB is not installed, ask the user to install it from MathWorks, then rerun the environment check.

### MATLAB startup or macOS permission failure

Evidence:

- MATLAB hangs during startup
- errors creating files under `~/Library/Application Support/MathWorks`
- macOS denies access to project folders, Desktop, Documents, or external drives

Guide the user:

1. Open macOS **System Settings**.
2. Go to **Privacy & Security**.
3. Open **Full Disk Access**.
4. Enable access for Terminal, MATLAB, and the agent host application.
5. Restart Terminal/MATLAB/Codex.

Then rerun:

```bash
RUN_MATLAB=1 ./matlab-simulink-agent/scripts/check_matlab_env.sh
```

If only one output directory is blocked, prefer moving the project to a writable folder over granting broad access.

### Product or toolbox missing

Evidence:

- `Undefined function`
- `Unable to load system`
- `No system or file called ...`
- `ver` output lacks the needed product
- Simulink library path cannot be loaded

Guide the user:

1. Confirm the needed product from docs and error text.
2. Ask the user to install the product with the MATLAB Add-On Explorer or MathWorks installer.
3. Rerun `matlab_capability_scan`.

Useful command:

```matlab
ver
matlab_capability_scan('matlab-capabilities.json')
```

### License unavailable

Evidence:

- license checkout error
- `license('test', productName)` returns false for a required product
- error mentions license manager, checkout, or entitlement

Guide the user:

1. Open MATLAB normally and sign in to the MathWorks account.
2. Confirm the license includes the required product.
3. If using a network license, confirm VPN/network access to the license server.
4. Ask the user's license administrator to add the product entitlement when needed.

Do not suggest bypassing license checks.

### Simulink block or parameter unknown

Evidence:

- `There is no block named ...`
- `Invalid setting in block diagram`
- `Invalid Simulink object name`
- `The parameter ... does not exist`

Guide the agent first:

```matlab
simulink_inventory('simulink-inventory.json', "simulink", 4)
get_param(blockPath, 'DialogParameters')
get_param(blockPath, 'ObjectParameters')
```

If the block is from a toolbox library, scan that library instead of guessing. If the library is missing, treat it as a product/toolbox blocker.

### UI-only workflow

Evidence:

- docs only describe menu clicks or dialogs
- no stable MATLAB or Simulink API is available
- task requires visual inspection of a model, scope, or mask dialog

Guide the user:

1. Prefer a documented API if one exists.
2. If not, ask permission to use desktop automation.
3. Use Computer Use or MATLAB desktop interaction narrowly for the required dialog.
4. Capture screenshots or notes so the workflow can be converted to script later if possible.

### External hardware or real-time target required

Evidence:

- task requires connected equipment, DAQ, FPGA, Speedgoat, Arduino, instrument control, or real-time target
- error mentions missing device, driver, board support package, or target connection

Guide the user:

1. Confirm hardware is connected and powered.
2. Confirm drivers/support packages are installed.
3. Confirm MATLAB can see the device from a normal desktop session.
4. For safety-critical systems, require user confirmation before running commands that affect hardware.

### Network or download required

Evidence:

- add-on installation needs internet
- examples or support packages need download
- external data or license server is unreachable

Guide the user:

1. Confirm network/VPN/proxy access.
2. Install required add-ons from MATLAB Add-On Explorer.
3. Rerun the script after installation.

Do not ask users to paste secrets or credentials into the chat.

## Final blocker message template

```text
Blocked at: <command or script>
Evidence: <short error excerpt>
Category: <category>
Fix: <concrete user action>
Retry: <exact command>
```
