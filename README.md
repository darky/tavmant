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

* git
* vipsthumbnail (provided by libvips-tools on Ubuntu or libvips on other OS)
* electron 0.36.x
* nodejs 5.x.x and npm 3.x.x

## Installation

1. Clone this repo in *tavmant* folder
2. Also in *tavmant* create folder *tavmant.app* and place here unpacked electron files
3. Run `./tools/link_electron.sh`
