# ***********************
#    NODEJS API DEFINE
# ***********************
exec =
    require "child_process"
    .exec
fs = require "fs"
os = require "os"
sha1 =
    require "crypto"
    .createHash "sha1"


# ********************
#    CHECK LICENSE
# ********************
calculated_sha = sha1.update(
    "
        #{ os.totalmem() }
        #{ os.cpus()[0].model }
        Y62mZQ18Oi^9F&bnxoeknr6ZoA>~vI
        #{ os.type() }
        #{ os.arch() }
        18i4LW56cO6r3^5#7:-h(j:>(5|p!+
        #{ os.platform() }
        #{ process.env.HOME ? process.env.HOMEPATH }
    "
    "utf8"
)
.digest "hex"
must_sha = require "./sha"

if calculated_sha isnt must_sha
    throw new Error "license error!"


# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
async = require "async"
co = require "co"
dir_helper = require "node-dir"
thunkify = require "thunkify"
# TODO temporary while jx node version < 0.11
if process.version.match /^v0\.10/
    require "es6-shim"


# *******************************
#    CONNECT MIDDLEWARE DEFINE
# *******************************
body_parser = require "body-parser"
mercury_save = require "./connect_middleware/mercury_save"


# **********************
#    GULP & KO DEFINE
# **********************
gulp = require "gulp"
del = require "del"
html_build = require "gulp-build"
cache = require "gulp-cached"
coffee = require "gulp-coffee"
static_server = require "gulp-connect"
# TODO temporary while jx node version < 0.11
regenerator = require "gulp-regenerator"
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
        watcher = watch "@dev/**/*.html", (event)->
            gulp.src event.path
            .pipe static_server.reload()
            watcher.close()
    watch ["partials/**/*.html", "pages/**/*.html"], ->
        gulp.start ["build_html"]
    watch ["assets/**/*.js", "./assets/**/*.css"], ->
        gulp.start ["copy_text_assets"]
    watch ["assets/**/*", "!assets/**/*.js", "!assets/**/*.css"], ->
        gulp.start ["copy_assets"]

    watch ["@dev/css/**/*.css", "@dev/js/**/*.js"], (event)->
        gulp.src event.path
        .pipe static_server.reload()


# ******************
#    MAKE BINARY
# ******************
gulp.task "precompile_coffee", (cb)->
    async.each [
        ["*.coffee", "."]
        ["connect_middleware/**/*.coffee", "connect_middleware/"]
    ], ([glob, dest], next)->
        gulp.src glob
        .pipe coffee bare : true
        .pipe gulp.dest dest
        .on "finish", next
    ,
        cb

# TODO temporary while jx node version < 0.11
gulp.task "regenerator", ["precompile_coffee"], (cb)->
    async.each [
        ["gulpfile.js", "."]
        ["connect_middleware/**/*.js", "connect_middleware/"]
    ], ([glob, dest], next)->
        gulp.src glob
        .pipe regenerator includeRuntime : true
        .pipe gulp.dest dest
        .on "finish", next
    ,
        cb

gulp.task "make_binary", ["regenerator"], -> co ->
    yield thunkify(
        exec
    )(
        "jx package gulpfile.js server.jx -slim @dev,assets,layouts,pages,partials,source_site"
        maxBuffer : 1024 * 1000
    )

    yield thunkify(
        del
    )(
        ["*.js", "*.jxp", "connect_middleware/**/*.js"]
    )


# **********************
#    DEFAULT DEV SITE
# **********************
gulp.task "default", ["static_server"]