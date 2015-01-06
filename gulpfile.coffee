_ = require "lodash"
async = require "async"
co = require "co"
dir_helper = require "node-dir"
fs = require "fs"
gulp = require "gulp"
html_build = require "gulp-build"
static_server = require "gulp-connect"
thunkify = require "thunkify"


gulp.task "build_html", -> co ->
    partials_paths = yield thunkify(
        dir_helper.paths
    )(
        "./partials"
        true
    )

    contents = yield thunkify(
        async.map
    )(
        partials_paths.concat "./layouts/main.html"
        (path, next)-> fs.readFile(
            path
            encoding : "utf8"
            next
        )
    )

    gulp.src "./pages/*.html"
    .pipe html_build {},
        layout   : _.last contents
        partials : _.map partials_paths, (path, i)->
            name : path.match(
                ///
                    / (\w+) \.html$
                ///
            )[1]
            tpl  : contents[i]
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