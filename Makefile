SHELL := /bin/bash

.PHONY: build dev up install vue
#----------------------------------------
#-- Setup --
#----------------------------------------
name:
	@if [ -z "$(VAL)" ]; then \
		echo "Usage: make name VAL=your-project-slug"; \
		exit 1; \
	fi
	@files=$$(grep -rl 'craft5-ddev-vite-blueprint' \
		--exclude-dir=node_modules \
		--exclude-dir=.git \
		--exclude-dir=vendor \
		--exclude-dir=storage \
		--exclude=Makefile \
		. 2>/dev/null); \
	if [ -z "$$files" ]; then \
		echo "No instances of 'craft5-ddev-vite-blueprint' found — nothing to replace."; \
		echo "This project has already been renamed."; \
	else \
		echo "$$files" | while IFS= read -r f; do \
			sed -i 's/craft5-ddev-vite-blueprint/$(VAL)/g' "$$f"; \
		done; \
		echo "Replaced 'craft5-ddev-vite-blueprint' with '$(VAL)'. Project has been successfully named."; \
	fi

#----------------------------------------
#-- Build commands --
#----------------------------------------
build: up
	ddev exec yarn build
dev: up
	ddev launch
	ddev exec yarn dev
fresh:
	@echo "🔥 Resetting environment..."
	-ddev stop
	-ddev delete -Oy
	rm -rf vendor node_modules vendor/.stamp node_modules/.stamp
	ddev start
	make up
	@echo "✨ Fresh environment ready"
install: up build
	ddev exec php craft setup/app-id $(filter-out $@,$(MAKECMDGOALS))
	ddev exec php craft setup/security-key $(filter-out $@,$(MAKECMDGOALS))
	ddev exec php craft install $(filter-out $@,$(MAKECMDGOALS))
	@echo "ready to take off 🎉🎉🎉"
	@echo "type 'make dev' to run vite development server"
up: env env-check
	@if ! ddev describe >/dev/null 2>&1; then \
		echo "Starting DDEV..."; \
		ddev start; \
	fi
	ddev composer install
	ddev composer post-pull-dev
	ddev exec yarn install
	
#----------------------------------------
#-- Enviornment File Maintenance --
#----------------------------------------
env:
	@if [ ! -f .env ]; then \
		echo "No .env found, creating from .env.example..."; \
		cp .env.example .env; \
	fi
env-check:
	@echo "Comparing environment variables present to .env.example."
	@missing=$$(comm -23 <(grep -oE '^[A-Za-z0-9_]+' .env.example | sort -u) <(grep -oE '^[A-Za-z0-9_]+' .env | sort -u)); \
	if [ -n "$$missing" ]; then \
		echo "The following variables are present in .env.example but missing from .env."; \
		echo "This may cause issues with site functionality."; \
		echo "$$missing" | sed 's/^/  /'; \
	else \
		echo "No missing variables."; \
	fi
env-example:
	@sed -E \
		-e '/^(CRAFT_DB_PASSWORD)=/!s/^([A-Za-z0-9_]*(KEY|SECRET|PASSWORD|TOKEN|PWD)[A-Za-z0-9_]*)=.*/\1=/I' \
		.env > .env.example
		
#----------------------------------------
#-- Project Add-ons --
#----------------------------------------
servd: up
	ddev composer require "servd/craft-asset-storage:^4.2.6" -w
	ddev php craft plugin/install servd-asset-storage || true
	@grep -q '^SERVD_' .env || printf '\n# Servd Config\nSERVD_PROJECT_SLUG=\nSERVD_SECURITY_KEY=\nSERVD_SMTP_PASSWORD=\nSERVD_SMTP_PORT=\nSERVD_SMTP_USERNAME=\n' >> .env
	@grep -q '^SERVD_' .env.example || printf '\n# Servd Config\nSERVD_PROJECT_SLUG=\nSERVD_SECURITY_KEY=\nSERVD_SMTP_PASSWORD=\nSERVD_SMTP_PORT=\nSERVD_SMTP_USERNAME=\n' >> .env.example
vue: 
	ddev exec yarn add vue vue-router vite-svg-loader
	ddev exec yarn add -D @vitejs/plugin-vue @vue/compiler-sfc
	ddev exec mkdir -p src/vue
	cp vite.config.vue.js vite.config.js
%:
	@: