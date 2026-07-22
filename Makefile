SHELL := /bin/bash

.PHONY: build dev up install

build: up
	ddev exec yarn build

dev: up
	ddev launch
	ddev exec yarn dev

install: up build
	ddev exec php craft setup/app-id $(filter-out $@,$(MAKECMDGOALS))
	ddev exec php craft setup/security-key $(filter-out $@,$(MAKECMDGOALS))
	ddev exec php craft install $(filter-out $@,$(MAKECMDGOALS))
	@echo "ready to take off 🎉🎉🎉"
	@echo "type 'make dev' to run vite development server"

env:
	@if [ ! -f .env ]; then \
		echo "No .env found, creating from .env.example..."; \
		cp .env.example .env; \
	fi
env-example:
	@sed -E \
		-e '/^(CRAFT_DB_PASSWORD)=/!s/^([A-Za-z0-9_]*(KEY|SECRET|PASSWORD|TOKEN|PWD)[A-Za-z0-9_]*)=.*/\1=/I' \
		.env > .env.example
env-check:
	@missing=$$(comm -23 <(grep -oE '^[A-Za-z0-9_]+' .env.example | sort -u) <(grep -oE '^[A-Za-z0-9_]+' .env | sort -u)); \
	if [ -n "$$missing" ]; then \
		echo "Missing from .env:"; \
		echo "$$missing" | sed 's/^/  /'; \
	else \
		echo ".env has all keys from .env.example"; \
	fi
up: env env-check
	@if ! ddev describe >/dev/null 2>&1; then \
		echo "Starting DDEV..."; \
		ddev start; \
	fi
	ddev composer install
	ddev composer post-pull-dev
	ddev exec yarn install

servd: up
	ddev composer require "servd/craft-asset-storage:^4.2.6" -w
	ddev php craft plugin/install servd-asset-storage || true
	@grep -q '^SERVD_' .env || printf '\n# Servd Config\nSERVD_PROJECT_SLUG=\nSERVD_SECURITY_KEY=\nSERVD_SMTP_PASSWORD=\nSERVD_SMTP_PORT=\nSERVD_SMTP_USERNAME=\n' >> .env
	@grep -q '^SERVD_' .env.example || printf '\n# Servd Config\nSERVD_PROJECT_SLUG=\nSERVD_SECURITY_KEY=\nSERVD_SMTP_PASSWORD=\nSERVD_SMTP_PORT=\nSERVD_SMTP_USERNAME=\n' >> .env.example
fresh:
	@echo "🔥 Resetting environment..."
	-ddev stop
	-ddev delete -Oy
	rm -rf vendor node_modules vendor/.stamp node_modules/.stamp
	ddev start
	make up
	@echo "✨ Fresh environment ready"
vue: 
	ddev exec yarn add vite-svg-loader
	ddev exec yarn add vue
	ddev exec yarn add vue-loader
	ddev exec yarn add vue-router
	ddev exec mkdir -p src/vue
	cp vite.config.vue.js vite.config.js
%:
	@: