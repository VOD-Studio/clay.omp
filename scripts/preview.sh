#!/usr/bin/env bash
set -euo pipefail

# Use the installed renderer without changing the user's themes or settings.
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
agent_dir=$(mktemp -d "${TMPDIR:-/tmp}/clay-omp-preview.XXXXXXXX")
trap 'rm -rf -- "$agent_dir"' EXIT
mkdir -p -- "$agent_dir/themes"
ln -s -- "$root/themes/clay.json" "$agent_dir/themes/clay.json"
printf 'theme:\n  dark: clay\n  light: clay\n' > "$agent_dir/config.yml"

# A named profile otherwise redirects theme discovery to its own agent dir.
env -u OMP_PROFILE PI_CODING_AGENT_DIR="$agent_dir" "${OMP:-omp}" gallery "$@"
