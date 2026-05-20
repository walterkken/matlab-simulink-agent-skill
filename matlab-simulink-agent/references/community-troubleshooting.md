# Community Troubleshooting

Use this reference when local MATLAB docs, installed metadata, and official documentation do not resolve an automation error.

## Search order

1. MathWorks documentation and examples.
2. MathWorks Answers and MATLAB Central discussions.
3. MathWorks release notes or known issue pages.
4. Stack Overflow questions tagged for MATLAB, Simulink, Simscape, or the relevant toolbox.
5. GitHub Issues for the exact package or API wrapper involved.

## Search query pattern

Build searches from facts, not guesses:

```text
"<exact error excerpt>" MATLAB R2025a Simulink <function-or-block>
"<exact error excerpt>" site:mathworks.com/matlabcentral/answers
"<function-or-block>" "DialogParameters" Simulink
"<toolbox name>" "<error id>" MATLAB
```

Include:

- MATLAB release, for example `R2025a`
- product/toolbox name
- exact error identifier or message
- function, class, block path, or model component
- operating system when relevant

## Trust filter

Prefer answers that:

- are from MathWorks staff, product maintainers, or highly reproducible accepted answers
- match the user's MATLAB release or API generation
- include a minimal reproducible example
- explain the root cause, not only a workaround
- avoid license bypasses, cracked products, unsafe downloads, or broad security disablement

Reject or quarantine answers that:

- require copying unknown binaries or scripts without source review
- advise bypassing licensing, signatures, sandboxing, or safety checks
- conflict with official documentation for the installed release
- are for a different product family, solver, or block library

## Reporting community findings

When using a forum result, report:

```text
Source: <link>
Matched evidence: <error/version/API detail>
Proposed fix: <specific change>
Confidence: high/medium/low
Why safe: <short reason>
```

Always test the fix in MATLAB when possible before presenting it as resolved.
