.PHONY: preview

# Arguments are passed through to `omp gallery`, e.g. ARGS='--tool edit'.
preview:
	bash scripts/preview.sh $(ARGS)
