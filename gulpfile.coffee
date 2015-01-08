# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
async = require "async"
co = require "co"
dir_helper = require "node-dir"
fs = require "fs"
thunkify = require "thunkify"


# *******************************
#    CONNECT MIDDLEWARE DEFINE
# *******************************
body_parser = require "body-parser"
mercury_save = require "./connect_middleware/mercury_save"


# **********************
#    GULP & KO DEFINE
# **********************
gulp = require "gulp"
html_build = require "gulp-build"
cache = require "gulp-cached"
static_server = require "gulp-connect"
watch = require "gulp-watch"


# *********************
#    PARTIALS DEFINE
# *********************
partials = null
partials_paths = null
gulp.task "predefine_partials", -> co ->
    partials_paths = yield thunkify(
        dir_helper.paths
    )(
        "./partials"
        true
    )

    partials = _.map partials_paths, (path)->
        path.match(
            ///
                / (\w+) \.html$
            ///
        )[1]


# **********************
#    FILL @DEV FOLDER
# **********************
gulp.task "build_html", ["predefine_partials"], -> co ->
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
        partials : _.map partials, (partial, i)->
            name : partial
            tpl  : contents[i]
    .pipe gulp.dest "./@dev/"

gulp.task "copy_text_assets", ->
    gulp.src ["./assets/**/*.js", "./assets/**/*.css"]
    .pipe cache "text_assets"
    .pipe gulp.dest "./@dev/"

gulp.task "copy_assets", ->
    gulp.src ["./assets/**", "!./assets/**/*.js", "!./assets/**/*.css"]
    .pipe gulp.dest "./@dev/"

gulp.task "fill_dev_folder", [
    "build_html"
    "copy_assets"
    "copy_text_assets"
]


# ************************
#    STANDUP DEV SERVER
# ************************
gulp.task "static_server", ["fill_dev_folder"], ->
    static_server.server
        livereload : true
        middleware : ->
            [
                body_parser.json()
                mercury_save
                    partials : partials
            ] 
        port       : 9000
        root       : "./@dev"


    # *****************
    #    LIVERELOAD
    # *****************
    watch "layouts/**/*.html", ->
        gulp.start ["build_html"]
    watch ["assets/**/*.js", "./assets/**/*.css"], ->
        gulp.start ["copy_text_assets"]
    watch ["assets/**/*", "!assets/**/*.js", "!assets/**/*.css"], ->
        gulp.start ["copy_assets"]

    watch "@dev/**/*.html", (event)->
        gulp.src event.path
        .pipe static_server.reload()
    watch ["@dev/css/**/*.css", "@dev/js/**/*.js"], (event)->
        gulp.src event.path
        .pipe static_server.reload()


# **********************
#    DEFAULT DEV SITE
# **********************
gulp.task "default", ["static_server"]