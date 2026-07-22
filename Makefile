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

up: env
	@if ! ddev describe >/dev/null 2>&1; then \
		echo "Starting DDEV..."; \
		ddev start; \
	fi
	ddev composer install
	ddev composer post-pull-dev
	ddev exec yarn install

servd: up
	ddev composer require "servd/craft-asset-storage:^4.2.6" -w && ddev php craft plugin/install servd-asset-storage
	@grep -qxF 'SERVD_' .env || printf '\n# Servd Config\nSERVD_PROJECT_SLUG=\nSERVD_SECURITY_KEY=\nSERVD_SMTP_PASSWORD=\nSERVD_SMTP_PORT=\nSERVD_SMTP_USERNAME=\n' >> .env
fresh:
	@echo "🔥 Resetting environment..."
	-ddev stop
	-ddev delete -Oy
	rm -rf vendor node_modules vendor/.stamp node_modules/.stamp
	ddev start
	make up
	@echo "✨ Fresh environment ready"

%:
	@: