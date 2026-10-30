.PHONY: preview

# Arguments are passed through to `omp gallery`, e.g. ARGS='--tool edit'.
# CLAY_VARIANT=light previews themes/clay-light.json; the default is dark.
preview:
	bash scripts/preview.sh $(ARGS)
