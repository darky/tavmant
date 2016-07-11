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
* electron 1.2.x [download](https://github.com/electron/electron/releases/tag/v1.2.6)
* nodejs 6.x.x and npm 3.x.x [download](https://nodejs.org/en/download/)

## Installation

1. Extract electron archive in any place
2. Create there empty folder *resources/app*
3. Clone in *resources/app* tavmant repo
4. Run `npm install` in *resources/app* folder

## Contribute

1. Run electron with `--remote-debugging-port=9222` flag
2. Open devtools (Ctrl + Shift + I)
3. Open in browser *localhost:9222*
4. From this tab go to link
5. Then in "Console" tab inject this code https://gist.github.com/darrrk/73feb95a991419b56c17dba795b26e1c
6. Refresh devtools
6. In devtools add or readd to "Workspace" root tavmant folder, then add mapping to remote ".ls" files
7. Refresh devtools, now you can from devtools edit and debug **tavmant** sources
