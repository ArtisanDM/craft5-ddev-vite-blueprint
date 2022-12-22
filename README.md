# Craft CMS Dev Environment

Combine the power of Craft CMS and Vite.js with zero configuration setup and incredible fast paced development 😎.

## Quickstart

1.  ``make install``
2.  ``make dev``
3.  open https://craft4-ddev-vite-blueprint.ddev.site


## Advanced Setup
### First Time Setup
1. Copy `craft4-ddev-vite-blueprint` repo contents into a new project
2. Choose a project slug (must be kebab case) and replace `craft4-ddev-vite-blueprint` with new project slug in:
    1. `name` in `ddev > config.yaml`
    2. `PRIMARY_SITE_URL` and `CRAFT_DB_SERVER` in `.env`
    3. `name` in `package.json`
3. ``make install``, follow prompts to set up Craft CMS.
4. ``make dev``
5. open `https://[project-slug].ddev.site`

### Subsequent Use
1. `make dev`
2. open `https://[project-slug].ddev.site`

## Commands
1. `make build` - build project files
2. `make dev` - run vite project server
3. `make install` - run first time setup
4. `ddev start` - starts ddev project without vite server
5. `ddev craft` - run Craft CLI commands

## Requirements

-   Docker, https://www.docker.com
-   DDEV, https://ddev.com


## Credits
Repo based on fork of [Craft CMS Dev Environment](https://github.com/thomasbendl/craft4-ddev-vite-blueprint)

Updated by [Josh Parylak](https://github.com/joshparylak) - [Artisan Digital Media](https://github.com/ArtisanDM)

### Original Credits
The team behind the magic ✨ 🪄 🦄

-  https://github.com/thomasbendl
-  https://github.com/smonist