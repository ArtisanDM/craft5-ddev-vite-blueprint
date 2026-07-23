SHELL := /bin/bash

.PHONY: build dev up install vue

#----------------------------------------
#-- Setup --
#----------------------------------------
name:
	@if [ -z "$(SLUG)" ]; then \
        echo "Usage: make name SLUG=your-project-slug LABEL=\"Your Label\""; \
        exit 1; \
    fi

	@echo "Updating Project Slug…"; \
    files=$$(grep -rl 'craft5-ddev-vite-blueprint' \
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
        echo "$$files" | xargs -r sed -i 's/craft5-ddev-vite-blueprint/$(SLUG)/g'; \
        echo "Replaced 'craft5-ddev-vite-blueprint' with '$(SLUG)'."; \
    fi

	@if [ -n "$(LABEL)" ]; then \
        echo "Updating Project Name"; \
        label_files=$$(grep -rl 'Craft CMS Dev Environment' \
            --exclude-dir=node_modules \
            --exclude-dir=.git \
            --exclude-dir=vendor \
            --exclude-dir=storage \
            --exclude=Makefile \
            . 2>/dev/null); \
        if [ -z "$$label_files" ]; then \
            echo "No instances of 'Craft CMS Dev Environment' found — nothing to replace."; \
        else \
            echo "$$label_files" | xargs -r sed -i "s/Craft CMS Dev Environment/$(LABEL)/g"; \
            echo "Replaced 'Craft CMS Dev Environment' with '$(LABEL)'."; \
        fi; \
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

#----------------------------------------
#-- Support --
#----------------------------------------
help:
	@printf "\n \n"
	@printf "\033[1m\033[4mAll Available Make Commands:\033[0m"
	@printf "\n \n"
	
	@./scripts/help.sh "name" \
	"Replaces default project slug and label with relevant ones. Only run when spinning up a new project from the original scaffold. Will do nothing after the first run."

	@./scripts/help.sh "build" \
	"Builds CSS and JS files. Runs make up as a preliminary safety."

	@./scripts/help.sh "dev" \
	"Launches website in a browser and starts Vite dev server. Runs make up as a preliminary safety."

	@./scripts/help.sh "fresh" \
	"Stops current DDEV containers, destroys current database along with vendor and node_modules folders. Restarts DDEV containers and runs make up to prepare project." \
	"Database delete cannot be undone."

	@./scripts/help.sh "install" \
	"Runs Craft CMS Installation."

	@./scripts/help.sh "up" \
	"Starts DDEV if it is not already running, runs installation for Composer and Yarn."

	@./scripts/help.sh "env" \
	"If no .env file exists, creates one from the .env.example file."

	@./scripts/help.sh "env-check" \
	"Verifies .env has all required keys by comparing keys in .env with the ones in .env.example."

	@./scripts/help.sh "env-example" \
	"Updates .env.example to add any newly added keys from the .env."

	@./scripts/help.sh "servd" \
	"Adds Servd support to this project."

	@./scripts/help.sh "vue" \
	"Adds Vue.js support to this project." \
	"This will overwrite vite.config.js with vite.config.vue.js. Running this command at any time other than project creation could be destructive to updates made to the Vite config. If updates to vite.config.js are present, changes from it should be manually added to vite.config.vue.js prior to running this command."

	@printf "\n \n"
%:
	@: