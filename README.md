# Craft CMS Dev Environment

> :warning: **Not ready for wide deployment. Use Craft 4 Blueprint.**

Combine the power of Craft CMS and Vite.js with zero configuration setup and incredible fast paced development 😎.

## Quickstart

1. `make install`
2. `make dev`
3. open `https://[project-slug].ddev.site`

## Advanced Setup

### Starting Up a New Project

1. Copy `craft5-ddev-vite-blueprint` repo contents into a new project
2. Create `.env` file at project root by copying `.env.example`.
3. Choose a project slug (must be kebab case) and replace `craft5-ddev-vite-blueprint` with new project slug in:
    1. `name` in `ddev > config.yaml`
    2. `PRIMARY_SITE_URL` and `CRAFT_DB_SERVER` in `.env`. **NOTE: Ensure that the `PRIMARY_SITE_URL` value does not have a trailing slash, as this will interfere with the vite server.**
    3. `name` in `package.json`
4. `make install`, follow prompts to set up Craft CMS.
    - _No starter DB is needed when starting the project from scratch._
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

1. `make build` - build project files
2. `make dev` - run vite project server
3. `make install` - run first time setup
4. `ddev start` - starts ddev project without vite server
5. `ddev craft` - run Craft CLI commands
6. `ddev import-db --src=[file_path]` - import new DB, file path from project root. _(A gitignored `db` folder is included in the repository for storing local db copies)._
7. `npx vite build` - build for production

## Requirements

-   [Docker](https://www.docker.com)
-   [DDEV](https://ddev.com)

## Credits

Repo based on fork of [Craft CMS Dev Environment](https://github.com/thomasbendl/craft5-ddev-vite-blueprint)

Updated by [Josh Parylak](https://github.com/joshparylak) - [Artisan Digital Media](https://github.com/ArtisanDM)

### Original Credits

The team behind the magic ✨ 🪄 🦄

-   <https://github.com/thomasbendl>
-   <https://github.com/smonist>
