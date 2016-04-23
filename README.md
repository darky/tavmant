# Tavmant

Powerfull static site generator application.

## Features

* Admin panel
* Livereload of browser tab
* Custom DSL for content managers, based on async handlebars helpers
* Simple built-in git ide for content managers
* Development and production mode for your site
* Content arhitecture - Layouts, pages, partials
* FS json-based DB - Categories, subcategories, subcategory elements
* Portfolio
* Image resizer for RWD
* Images viewer with ability copy link to clipboard
* Simple CSS/JS editor

## Dependencies

* git [download](https://git-scm.com/)
* vipsthumbnail (contained in libvips) [download](http://www.vips.ecs.soton.ac.uk/index.php?title=Stable#Installing)
* electron 0.36.x [download](https://github.com/electron/electron/releases/tag/v0.36.12)
* nodejs 5.x.x and npm 3.x.x [download](https://nodejs.org/en/download/)

## Installation

1. Extract electron archive in any place
2. In electron folder remove content of *resources/default_app*
3. Clone in *default_app* tavmant repo
4. Remove in *.gitignore* content between `### ***`
