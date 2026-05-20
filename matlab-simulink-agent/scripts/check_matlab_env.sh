#!/usr/bin/env bash
set -euo pipefail

find_matlab() {
  if [[ -n "${MATLAB_BIN:-}" && -x "${MATLAB_BIN}" ]]; then
    printf '%s\n' "${MATLAB_BIN}"
    return 0
  fi

  if command -v matlab >/dev/null 2>&1; then
    command -v matlab
    return 0
  fi

  local candidate
  for candidate in /Applications/MATLAB_R*.app/bin/matlab; do
    if [[ -x "${candidate}" ]]; then
      printf '%s\n' "${candidate}"
      return 0
    fi
  done

  return 1
}

matlab_bin="$(find_matlab || true)"

if [[ -z "${matlab_bin}" ]]; then
  printf 'MATLAB_FOUND=0\n'
  printf 'ERROR=MATLAB executable not found. Set MATLAB_BIN=/path/to/matlab.\n'
  exit 1
fi

printf 'MATLAB_FOUND=1\n'
printf 'MATLAB_BIN=%s\n' "${matlab_bin}"

if [[ "${RUN_MATLAB:-0}" != "1" ]]; then
  printf 'MATLAB_QUERY_SKIPPED=1\n'
  printf 'HINT=Set RUN_MATLAB=1 to query version and installed products.\n'
  exit 0
fi

"${matlab_bin}" -batch "try, fprintf('MATLAB_VERSION=%s\n', version); v = ver; for k = 1:numel(v), fprintf('PRODUCT=%s|VERSION=%s\n', v(k).Name, v(k).Version); end; catch ME, disp(getReport(ME,'extended','hyperlinks','off')); exit(1); end; exit(0);"
