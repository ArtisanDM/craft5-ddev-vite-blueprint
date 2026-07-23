# Craft CMS Dev Environment

Combine the power of Craft CMS and Vite.js with zero configuration setup and incredible fast paced development 😎.

## Quickstart

1. `make install`
2. `make dev`
3. open `https://[project-slug].ddev.site`

## Advanced Setup

### Starting Up a New Project

1. Copy `craft5-ddev-vite-blueprint` repo contents into a new project
2. Choose a project slug (must be kebab case) and replace `craft5-ddev-vite-blueprint` with new project slug in:
    1. `name` in `ddev > config.yaml`
    2. `PRIMARY_SITE_URL` and `CRAFT_DB_SERVER` in `.env.example`. **NOTE: Ensure that the `PRIMARY_SITE_URL` value does not have a trailing slash, as this will interfere with the vite server.**
    3. `name` in `package.json`
3. `make install`, follow prompts to set up Craft CMS.
    - _No starter DB is needed when starting the project from scratch._
    - _If none exists, a `.env` will be created at this point from the `.env.example`, so it's important to have updated that file before running this step._
4. If the site will be hosted on [Servd](https://servd.host/), you can run `make servd` at this point to add the [Servd Assets and Helpers](https://plugins.craftcms.com/servd-asset-storage) plugin and add the needed empty values to the `.env.example` and `.env` files.
5. `make dev`
6. open `https://[project-slug].ddev.site`
7. Update `README.md` to remove blueprint instructions and customize any setup details for new project.

### Subsequent Use

#### Pulling existing project repo

1. `ddev start`
2. `ddev import-db --src=[file_path]` - import new DB, file path from project root. _(A gitignored `db` folder is included in the repository for storing local db copies)._
3. `make dev`
4. open `https://[project-slug].ddev.site`

#### Restarting project for local dev

1. `make dev`
2. open `https://[project-slug].ddev.site`

#### Notes

Notes can be added to the project using a `notes.md` file. This file will be automatically ignored from the repo and is for personal developer use only. Project-critical information should be added to the `README.md`.

## Commands

### Make Commands

1. `make build` - build project files
2. `make dev` - run vite project server
3. `make install` - run first time setup
4. `make env` - creates an env from env.example. Auto-runs during setup.
5. `make env-check` - checks existing env file against env.example file to check for missing values that may have been added to the default example. This will run any time `make dev` is run to alert the user of missing values, but it can also be run independently.
6. `make env-example` - If new values have been added to the local env, running this will copy them to the example for documentation, stripping sensitive keys and passwords.
7. `make servd` - adds Servd elements to project.
8. `make vue` - adds basic Vue elements to project. _Caution: This will overwrite the current vite.config.js with the contents of vite.config.vue.js. As such, running this command at any time other than project creation could be destructive to updates made to the Vite config. If updates to vite.config.js are present, changes from it should be manually added to vite.config.vue.js prior to running this command._
9. `make fresh` - _Danger Zone:_ This command will wipe `vendor` and `node_modules`, delete the currently loaded database, and restart the ddev project from scratch. No code changes will be made, but the existing db will be lost _permanently_. A backup should be taken before running.

### DDEV Commands

1. `ddev start` - starts ddev project without vite server
2. `ddev craft` - run Craft CLI commands
3. `ddev import-db --src=[file_path]` - import new DB, file path from project root. _(A gitignored `db` folder is included in the repository for storing local db copies)._
4. `ddev exec npx vite build` - build for production

## Requirements

-   [Docker](https://www.docker.com)
-   [DDEV](https://ddev.com)

## Credits

Repo based on fork of [Craft CMS Dev Environment](https://github.com/thomasbendl/craft4-ddev-vite-blueprint)

Updated by [Josh Parylak](https://github.com/joshparylak) - [Artisan Digital Media](https://github.com/ArtisanDM)

### Original Credits

The team behind the magic ✨ 🪄 🦄

-   <https://github.com/thomasbendl>
-   <https://github.com/smonist>
