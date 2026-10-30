#!/usr/bin/env bash
set -euo pipefail

# Use the installed renderer without changing the user's themes or settings.
# CLAY_VARIANT selects the theme file: dark (default) or light.
case "${CLAY_VARIANT:-dark}" in
  dark) theme=clay ;;
  light) theme=clay-light ;;
  *)
    printf 'CLAY_VARIANT must be dark or light, got: %s\n' "$CLAY_VARIANT" >&2
    exit 2
    ;;
esac

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
agent_dir=$(mktemp -d "${TMPDIR:-/tmp}/clay-omp-preview.XXXXXXXX")
trap 'rm -rf -- "$agent_dir"' EXIT
mkdir -p -- "$agent_dir/themes"
ln -s -- "$root/themes/$theme.json" "$agent_dir/themes/$theme.json"
printf 'theme:\n  dark: %s\n  light: %s\n' "$theme" "$theme" > "$agent_dir/config.yml"

# A named profile otherwise redirects theme discovery to its own agent dir.
env -u OMP_PROFILE PI_CODING_AGENT_DIR="$agent_dir" "${OMP:-omp}" gallery "$@"
