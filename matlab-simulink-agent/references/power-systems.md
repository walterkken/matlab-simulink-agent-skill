# Power-System and Transient-Stability Simulations

Use this reference for Simulink/Simscape Electrical tasks involving power systems, faults, generators, governors, exciters, grid dynamics, or transient stability.

## Choose the modeling family

Ask or infer which family is intended:

- **Simscape Electrical physical network**: component-oriented physical modeling with Simscape solver considerations.
- **Specialized Power Systems**: block-library workflow commonly using `powergui` and phasor/discrete/continuous modes.
- **Custom DAE/state-space model**: MATLAB functions or S-functions when the equations are supplied directly.

Do not mix families casually. If the user only says "power-system transient stability", start by checking whether Simscape Electrical and Specialized Power Systems are available.

## Products to verify

At minimum:

```matlab
ver
license('test','Simulink')
```

Depending on the model:

```matlab
license('test','Simscape')
license('test','Power_System_Blocks')
```

Product and license names can vary by release; confirm with `ver` and official docs before relying on an exact string.

## Model requirements to pin down

Before building a serious transient-stability model, identify:

- network topology and base power/base voltage
- generator model order, inertia `H`, damping `D`, reactances, time constants
- excitation, governor, turbine, and load model assumptions
- fault location, type, insertion time, and clearing time
- outputs: rotor angle, rotor speed, electrical power, mechanical power, bus voltage, frequency
- stability criterion: angle separation, loss of synchronism, voltage recovery, or custom threshold

## Specialized Power Systems notes

If using Specialized Power Systems, include a `powergui` block when required by the selected blocks. Configure simulation mode and sample time deliberately. Common generated-model checks:

```matlab
find_system(model, 'Name', 'powergui')
set_param(model, 'StopTime', '5')
```

If a fault is modeled, export pre-fault, during-fault, and post-fault intervals separately enough to verify clearing behavior.

## Simscape notes

For Simscape networks, ensure solver configuration blocks, reference nodes, and units are valid. Log physical signals through converters or Simscape logging, and document any unit conversions.

## Validation checklist

- Initial operating point is physically plausible.
- Fault timing and breaker clearing match the requested scenario.
- Rotor angle/speed traces show expected qualitative behavior.
- Numerical solver warnings are reviewed, not ignored.
- Claims of "stable" or "unstable" are tied to a stated criterion and exported evidence.
