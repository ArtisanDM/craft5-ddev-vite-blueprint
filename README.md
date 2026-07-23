# Craft CMS Dev Environment

Combine the power of Craft CMS and Vite.js with zero configuration setup and incredible fast paced development.

## Quickstart

1. `make install`
2. `make dev`
3. open `https://[project-slug].ddev.site`

## Advanced Setup

### Starting Up a New Project

1. Create new repo from this template.
2. Choose a project slug (must be kebab case) and Site Name. Run `make name SLUG=project-slug LABEL="Site Name"` replacing "project-slug" and "Site Name" with your chosen value to rename the project.
3. `make install`, follow prompts to set up Craft CMS.
    - _No starter DB is needed when starting the project from scratch._
    - _If none exists, a `.env` will be created at this point from the `.env.example`._
4. If the site will be hosted on [Servd](https://servd.host/), you can run `make servd` at this point to add the [Servd Assets and Helpers](https://plugins.craftcms.com/servd-asset-storage) plugin and add the needed empty values to the `.env.example` and `.env` files.
5. `make dev`
6. open `https://craft5-ddev-vite-blueprint.ddev.site`
7. Update `README.md` to remove "Starting Up a New Project Section" and customize any setup details for new project, such as relevant plugin instructions, additional framework details, and a project description.

### Subsequent Use

#### Pulling existing project repo

1. `ddev start`
2. `ddev import-db --src=[file_path]` - import new DB, file path from project root. _(A gitignored `db` folder is included in the repository for storing local db copies)._
3. `make dev`
4. open `https://craft5-ddev-vite-blueprint.ddev.site`

#### Restarting project for local dev

1. `make dev`
2. open `https://craft5-ddev-vite-blueprint.ddev.site`

#### Notes

Notes can be added to the project using a `notes.md` file. This file will be automatically ignored from the repo and is for personal developer use only. Project-critical information should be added to the `README.md`.

## Commands

### Make Commands

## Commands

- **help** — Lists all available make commands. Provides the same information as this list.
- **name** — Replaces default project slug and label with relevant ones. Only run when spinning up a new project from the original scaffold. Will do nothing after the first run.
- **build** — Builds CSS and JS files. Runs `make up` as a preliminary safety.
- **dev** — Launches website in a browser and starts Vite dev server. Runs `make up` as a preliminary safety.
- **fresh** — Stops current DDEV containers, destroys current database along with vendor and `node_modules` folders. Restarts DDEV containers and runs `make up` to prepare project.  
  > **⚠️ Caution:** *Database delete cannot be undone.*
- **install** — Runs Craft CMS Installation.
- **up** — Starts DDEV if it is not already running, runs installation for Composer and Yarn.
- **env** — If no `.env` file exists, creates one from the `.env.example` file.
- **env-check** — Verifies `.env` has all required keys by comparing keys in `.env` with the ones in `.env.example`.
- **env-example** — Updates `.env.example` to add any newly added keys from `.env`.
- **servd** — Adds Servd support to this project.
- **vue** — Adds Vue.js support to this project.  
  > **⚠️ Caution:** *This will overwrite the current `vite.config.js` with the contents of `vite.config.vue.js`. Running this command at any time other than project creation could be destructive to updates made to the Vite config. If updates to `vite.config.js` are present, changes from it should be manually added to `vite.config.vue.js` prior to running this command.*



### DDEV Commands

1. `ddev start` - starts ddev project without vite server
2. `ddev craft` - run Craft CLI commands
3. `ddev import-db --src=[file_path]` - import new DB, file path from project root. _(A gitignored `db` folder is included in the repository for storing local db copies)._
4. `ddev exec npx vite build` - build for production

## Requirements

-   [Docker](https://www.docker.com)
-   [DDEV](https://ddev.com)

## Credits

Repo based on fork of [this Craft/DDEV/Vite blueprint](https://github.com/thomasbendl/craft4-ddev-vite-blueprint).

Updated by [Josh Parylak](https://github.com/joshparylak) - [Artisan Digital Media](https://github.com/ArtisanDM).
