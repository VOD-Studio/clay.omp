# Repository Guidelines

## Project Overview

clay.omp is a theme for the Oh My Pi (omp) coding agent, ported from clay.nvim: grayscale base plus a single clay accent `#d97757`, and deliberately grayscale diffs (added=`bright`, removed=`muted`, context=`comment`; semantic disambiguation comes from `+`/`-` glyphs, not red/green). Ships two JSON themes — dark `clay` and light `clay-light` — plus a bash preview harness. Verified against omp 18.14.0 only. There is no source code to compile; the theme JSONs are the entire product.

## Architecture & Data Flow

Data, not code:

1. `themes/clay.json` / `themes/clay-light.json` are the single source of truth. Each has exactly four top-level keys: `name`, `vars`, `colors`, `export`.
   - `vars` — 23 hex palette entries (e.g. `"clay": "#d97757"`). The only place raw colors exist.
   - `colors` — 68 omp UI slots; every value is a `vars` key name that omp resolves at load time. 66 required + 2 optional (`assistantMessageText`, `thinkingMax`).
   - `export` — 3 HTML-export slots (`pageBg`, `cardBg`, `infoBg`), also var refs.
2. Preview flow: `make preview` → `scripts/preview.sh` builds an ephemeral agent dir (`mktemp -d`, symlink the chosen theme in, generate `config.yml` setting both `theme.dark` and `theme.light` to it) → `env -u OMP_PROFILE PI_CODING_AGENT_DIR=<tmp> "${OMP:-omp}" gallery "$@"`. Nothing global is touched, no model calls.
3. Theme discovery paths: `~/.omp/agent/themes/`, `~/.omp/profiles/<name>/agent/themes/`, or `$PI_CODING_AGENT_DIR/themes/` (the hook `preview.sh` uses). Built-in themes win name conflicts; interactive omp hot-reloads watched custom theme files after the first manual selection in `/settings`.
4. Runtime never reads the upstream Neovim repo; the JSON mapping is maintained by hand from clay.nvim's design docs and `lua/clay/palette.lua`.

## Key Directories

| Path | Purpose |
|---|---|
| `themes/` | The two theme JSONs — the whole deliverable |
| `scripts/` | `preview.sh`, the only script |
| `assets/` | README screenshots (currently stale, pre-palette-resync) |

## Development Commands

```bash
make preview                                          # dark, full gallery
CLAY_VARIANT=light make preview                       # light variant
make preview ARGS='--tool edit --width 100'           # single tool render
make preview ARGS='--surface composer'                # single UI section
OMP=/path/to/installed/omp make preview               # bypass a self-updating omp wrapper
python -m json.tool themes/clay.json >/dev/null       # ad-hoc JSON sanity (not scripted, not enforced)
```

`CLAY_VARIANT` accepts only `dark|light` (anything else exits 2). There is no `check`/`test`/`lint`/`install` target.

## Code Conventions & Common Patterns

- **Variant invariant**: `colors` and `export` must stay byte-identical across `clay.json` and `clay-light.json`; only `name` and `vars` values differ. Never fork the slot mapping per variant.
- **Full-field themes only**: ship all 66 required color fields; never trim to an override-only fragment — omp silently falls back to its built-in palette and still exits 0 on missing fields.
- **Indirection**: UI and export slots reference `vars` names, never raw hex. Change a color by editing `vars` in both variants.
- **Upstream parity**: 6 unreferenced `vars` (`sidebar`, `search`, `reference`, `diff_add`, `diff_change`, `shadow`) are kept key-by-key for diffing against clay.nvim's `lua/clay/palette.lua`. Do not delete them.
- **omp semantics to respect**: `text` alone does not color assistant prose — `assistantMessageText` is also required; only singular `syntaxFunction` exists (no plural/variant keys); `statusLine.transparent` is an omp setting, not a theme field; the `terminal` block is deliberately unset (user-owned).
- **Docs are zh-CN** (README, CHANGELOG), keep-a-changelog style, with a per-release `Verified` subsection recording the exact omp version exercised.
- **Commits**: Conventional Commits `type(scope): summary` — observed types `feat`/`docs`, scopes `theme`/`preview`/`readme`.

## Important Files

| File | Role |
|---|---|
| `themes/clay.json` | Dark theme, source of truth |
| `themes/clay-light.json` | Light theme — mirror with different `vars` |
| `scripts/preview.sh` | ~26-line bash wrapper: variant select → temp agent dir → isolated `omp gallery` exec |
| `Makefile` | 6 lines; single `preview` target, `ARGS` passthrough |
| `README.md` | Design spec, palette tables, omp quirks — consult before touching `vars` |
| `CHANGELOG.md` | Release history + per-release verification records |

## Runtime/Tooling Preferences

- omp is the only runtime; the harness needs Bash + Make + an installed omp on a truecolor terminal. **No Node, Bun, Python, or package manifests** — do not introduce tooling dependencies for simple checks.
- Requires omp with custom JSON-theme support (tested on 18.14.0).
- User install: symlink/copy `themes/*.json` into `~/.omp/agent/themes/`, then `omp config set theme.dark clay` and `omp config set theme.light clay-light`; omp picks the slot by terminal background lightness.

## Testing & QA

No tests, CI, lint, or schema validation exist (no `.github/`, no `tests/`). QA is visual, by design:

1. Edit `themes/clay.json` and mirror `vars` values into `clay-light.json`; keep `colors`/`export` identical.
2. Parse-check both JSONs.
3. Run `make preview` for both variants with `ARGS` targeting the touched surface.
4. **Judge success by the rendered ANSI, never the exit code**: confirm the `#d97757` accent and grayscale diffs appear. omp exits 0 even when falling back to built-in colors — a clean exit proves nothing.
5. Record what was verified (and the omp version) in the CHANGELOG `Verified` section.

`omp gallery` does not paint the main canvas, so light previews need a light terminal background.

Known open items (docs debt, not code): no LICENSE (upstream clay.nvim has none either), README restore-theme wording still uses placeholder names (`titanium`/`light`), screenshots not yet recaptured after the palette resync.
