fs = require "fs"
gulp = require "gulp"
html_build = require "gulp-build"
static_server = require "gulp-connect"


gulp.task "build_html", ->
    fs.readFile "./layouts/main.html", encoding : "utf8", (err, html_layout)->
        gulp.src "./pages/*.html"
        .pipe html_build {},
            layout : html_layout
        .pipe gulp.dest "./@dev/"

gulp.task "copy_assets", ->
    gulp.src "./assets/**"
    .pipe gulp.dest "./@dev/"


gulp.task "fill_dev_folder", [
    "build_html"
    "copy_assets"
]


gulp.task "static_server", ["fill_dev_folder"], ->
    static_server.server
        port : 9000
        root : "./@dev"


gulp.task "default", ["static_server"]