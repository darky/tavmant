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
* electron 1.7.x [download](https://github.com/electron/electron/releases/tag/v1.7.1)
* nodejs 7.x.x and npm 4.x.x [download](https://nodejs.org/en/download/)

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
5. Then in "Console" tab inject this code https://gist.github.com/darky/2c0bab88daad6b940776eb4be928da68
6. Again to devtools, plug "Persistence 2.0" in Settings -> Experiments
7. Reopen devtools
8. Go to Sources tab -> Filesystem -> Add folder to workspace -> add tavmant folder
9. Refresh devtools, now you can edit and debug **tavmant** sources
