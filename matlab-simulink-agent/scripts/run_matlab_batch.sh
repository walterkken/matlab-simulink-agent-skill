#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  printf 'Usage: %s path/to/script.m [working-directory]\n' "$0" >&2
  exit 2
fi

script_path="$1"
workdir="${2:-${MATLAB_WORKDIR:-$(pwd)}}"

if [[ ! -f "${script_path}" ]]; then
  printf 'ERROR: MATLAB script not found: %s\n' "${script_path}" >&2
  exit 1
fi

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

escape_matlab_string() {
  printf '%s' "$1" | sed "s/'/''/g"
}

matlab_bin="$(find_matlab || true)"

if [[ -z "${matlab_bin}" ]]; then
  printf 'ERROR: MATLAB executable not found. Set MATLAB_BIN=/path/to/matlab.\n' >&2
  exit 1
fi

abs_script="$(cd "$(dirname "${script_path}")" && pwd)/$(basename "${script_path}")"
abs_workdir="$(cd "${workdir}" && pwd)"
matlab_script="$(escape_matlab_string "${abs_script}")"
matlab_workdir="$(escape_matlab_string "${abs_workdir}")"

"${matlab_bin}" -batch "try, cd('${matlab_workdir}'); run('${matlab_script}'); catch ME, disp(getReport(ME,'extended','hyperlinks','off')); exit(1); end; exit(0);"
