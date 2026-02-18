.PHONY: build dev up install fresh

# -------------------------------------------------------------------
# Stamp-based dependency caching
# -------------------------------------------------------------------

vendor/.stamp: composer.json composer.lock
	ddev composer install
	touch vendor/.stamp

node_modules/.stamp: package.json yarn.lock
	ddev exec yarn install
	touch node_modules/.stamp

# -------------------------------------------------------------------
# Main targets
# -------------------------------------------------------------------

build: up
	ddev exec yarn build

dev: up
	ddev exec yarn dev

install: up build
	ddev exec php craft setup/app-id $(filter-out $@,$(MAKECMDGOALS))
	ddev exec php craft setup/security-key $(filter-out $@,$(MAKECMDGOALS))
	ddev exec php craft install $(filter-out $@,$(MAKECMDGOALS))
	@echo "ready to take off 🎉🎉🎉"
	@echo "type 'make dev' to run vite development server"

# -------------------------------------------------------------------
# Environment bootstrap
# -------------------------------------------------------------------

up: vendor/.stamp node_modules/.stamp
	@if ! ddev describe >/dev/null 2>&1; then \
		echo "Starting DDEV..."; \
		ddev start; \
		ddev launch; \
	fi
	ddev composer post-pull-dev

# -------------------------------------------------------------------
# Full reset
# -------------------------------------------------------------------

fresh:
	@echo "🔥 Resetting environment..."
	-ddev stop
	-ddev delete -Oy
	rm -rf vendor node_modules vendor/.stamp node_modules/.stamp
	ddev start
	make up
	@echo "✨ Fresh environment ready"

# -------------------------------------------------------------------
# Pass-through for Craft arguments
# -------------------------------------------------------------------

%:
	@:
