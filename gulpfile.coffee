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
cache = require "gulp-cached"
coffee = require "gulp-coffee"
concat = require "gulp-concat"
del = require "del"
html_build = require "gulp-build"
minify_css = require "gulp-minify-css"
static_server = require "gulp-connect"
# TODO temporary while jx node version < 0.11
regenerator = require "gulp-regenerator"
uglify = require "gulp-uglify"
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

    partials.unshift "tavmant"
    contents.unshift yield thunkify(
        fs.readFile
    )(
        "./tavmant_assets/#{ if process.jxversion then "prod.html" else "dev.html" }"
        encoding : "utf8"
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

gulp.task "copy_tavmant_assets", ["copy_text_assets"], (cb)->
    if_jx_bye()
    async.each ["js", "css"], (folder, next)->
        gulp.src ["./tavmant_assets/#{folder}/**/*"]
        .pipe cache "tavmant_assets"
        .pipe gulp.dest "./@dev/#{folder}/tavmant/"
        .on "finish", next
    ,
        cb

gulp.task "fill_dev_folder", [
    "build_html"
    "copy_assets"
    if process.jxversion
        "copy_text_assets"
    else
        "copy_tavmant_assets"
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
    watch(
        _.compact [
            "layouts/**/*.html"
            unless process.jxversion
                "tavmant_assets/**/*.html"
        ]
        ->
            gulp.start ["build_html"]
            watcher = watch "@dev/**/*.html", (event)->
                gulp.src event.path
                .pipe static_server.reload()
                watcher.close()
    )
    watch ["partials/**/*.html", "pages/**/*.html"], ->
        gulp.start ["build_html"]
    watch ["assets/**/*.js", "./assets/**/*.css"], ->
        gulp.start ["copy_text_assets"]
    watch ["assets/**/*", "!assets/**/*.js", "!assets/**/*.css"], ->
        gulp.start ["copy_assets"]
    unless process.jxversion
        watch ["tavmant_assets/**/*"], ->
            gulp.start ["copy_tavmant_assets"]

    watch ["@dev/css/**/*.css", "@dev/js/**/*.js"], (event)->
        gulp.src event.path
        .pipe static_server.reload()


# ******************
#    MAKE BINARY
# ******************
gulp.task "precompile_coffee", (cb)->
    if_jx_bye()
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


# ******************
#    MAKE TAVMANT
# ******************
gulp.task "make_tavmant", -> co ->
    if_jx_bye()
    html_content = yield thunkify(
        fs.readFile
    )(
        "./tavmant_assets/dev.html"
        encoding : "utf8"
    )

    [js_paths, css_paths] = _.map ["src", "href"], (link_attr)->
        html_content.match ///
            #{link_attr}=
            [/\w\.\-]+
        ///g
        .map (str)->
            str.replace "#{link_attr}=", "tavmant_assets"
            .replace "tavmant/", ""

    coffee_paths = js_paths.filter (path)->
        !!path.match /\.coffee$/

    yield new Promise (resolve)->
        gulp.src coffee_paths
        .pipe coffee()
        .pipe gulp.dest "./tavmant_assets/js"
        .on "finish", resolve

    js_paths = _ js_paths
    .map (path)->
        if path.match /coffee-script\.js$/
            null
        else if path.match /\.coffee$/
            path.replace ".coffee", ".js"
        else
            path
    .compact().value()

    yield new Promise (resolve)->
        try_resolve = _.after 2, resolve

        gulp.src js_paths
        .pipe concat "main.js"
        .pipe uglify()
        .pipe gulp.dest "@tavmant"
        .on "finish", try_resolve

        gulp.src css_paths
        .pipe concat "main.css"
        .pipe minify_css keepSpecialComments : 0
        .pipe gulp.dest "@tavmant"
        .on "finish", try_resolve

    del coffee_paths.map (path)-> path.replace ".coffee", ".js"


# **********************
#    DEFAULT DEV SITE
# **********************
gulp.task "default", ["static_server"]


# ********************
#    CHECK LICENSE
# ********************
if_jx_bye = ->
    if process.jxversion
        console.log "You cannot do it! Bye!"
        process.exit()

runned_gulp_tasks = _ process.argv
.map (cli_arg)->
    if gulp.hasTask cli_arg
        cli_arg
    else
        null
.compact().value()

not_license_require = ["make_binary"]

if (
    runned_gulp_tasks.length is 0  or
    _.difference runned_gulp_tasks, not_license_require
    .length
)
    license_salt = "PR93lFP1R9GiQ79o5849987013T6570n"
    license_salt2 = "iwNA8qaaTVB8pqOJQlqvmbagkOObAiIT"

    license_formula = "
        #{ os.totalmem() }
        #{ os.cpus()[0].model }
        #{license_salt}
        #{ os.type() }
        #{ os.arch() }
        #{license_salt2}
        #{ os.platform() }
        #{ process.env.HOME ? process.env.HOMEPATH }
    "

    calculated_sha = sha1.update license_formula, "utf8"
    .digest "hex"
    must_sha = require "./sha"

    if calculated_sha isnt must_sha
        cipher = require "crypto"
        .createCipher "aes-256-cbc", license_salt2
        
        console.log "LICENSE ERROR! Send information between * to darkvlados@me.com for receiving license"
        console.log """
            **********************************
            #{ cipher.update license_formula, "utf8", "hex" }\
            #{ cipher.final "hex" }
            **********************************
        """
        process.exit()
