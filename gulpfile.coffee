# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
if process.jxversion
    require "es6-promise"
    .polyfill()


# **********************
#    GULP & KO DEFINE
# **********************
gulp = require "gulp"
cache = require "gulp-cached"
del = require "del"
image_min = require "gulp-imagemin"
minify_css = require "gulp-minify-css"
minify_html = require "gulp-htmlmin"
run_sequence = require "run-sequence"
static_server = require "gulp-connect"
uglify = require "gulp-uglify"
useref = require "gulp-useref"


# ****************
#    EVENT-BUS
# ****************
global.radio = require "backbone.radio" .channel "global"


# ***************
#    BUILD DEV
# ***************
gulp.task "clear_dev_prod", (cb)->
    del ["@dev/**/*.*", "@prod/**/*.*"], cb

gulp.task "build_html", ->
    HTML_Build = require "./core/build_html.coffee"
    html_builder = new HTML_Build
    html_builder.start()

gulp.task "build_portfolio", ->
    Portfolio_Build = require "./core/build_portfolio.coffee"
    portfolio_builder = new Portfolio_Build
    portfolio_builder.start()

gulp.task "copy_text_assets", ->
    gulp.src [
        "./assets/**/*.js"
        "./assets/**/*.css"
    ]
    .pipe cache "text_assets"
    .pipe gulp.dest "./@dev/"

gulp.task "copy_assets", ->
    gulp.src ["./assets/**/*", "!./assets/**/*.js", "!./assets/**/*.css", "!./assets/img/projects/**/*.jpg"]
    .pipe gulp.dest "./@dev/"

gulp.task "build_dev", ["clear_dev_prod"], (cb)->
    run_sequence [
        "build_html"
        "build_portfolio"
        "copy_assets"
        "copy_text_assets"
    ], cb


# ************************
#    STANDUP DEV SERVER
# ************************
gulp.task "static_server", ["build_dev"], ->
    static_server.server do
        port : 9000
        root : "./@dev"


    # *****************
    #    LIVERELOAD
    # *****************
    require "./core/livereload.coffee"
    .call null, static_server


# *****************
#    PRODUCTION
# *****************
gulp.task "copy_font", ->
    gulp.src "@dev/font/**/*.*"
    .pipe gulp.dest "@prod/font"

gulp.task "copy_site_root", ->
    gulp.src "./site_root/**/*"
    .pipe gulp.dest "@prod"

gulp.task "minify_image", ->
    gulp.src [
        "@dev/**/*.jpg"
        "@dev/**/*.jpeg"
        "@dev/**/*.png"
        "@dev/**/*.gif"
        "@dev/**/*.svg"
        "!@dev/font/**/*.svg"
    ]
    .pipe image_min()
    .pipe gulp.dest "@prod"

gulp.task "ref_production_css_js", ->
    assets = useref.assets()
    gulp.src "@dev/**/*.html"
    .pipe assets
    .pipe assets.restore()
    .pipe useref()
    .pipe gulp.dest "@prod"

gulp.task "minify_html", ["ref_production_css_js"], ->
    gulp.src "@prod/**/*.html"
    .pipe minify_html do
        collapseWhitespace : true
        removeComments     : true
    .pipe gulp.dest "@prod"

minify_js_css = (type)->
    new Promise (resolve)->
        try_resolve = _.after 2, resolve
        if type is "js"
            minificator = uglify
        else if type is "css"
            minificator = minify_css

        gulp.src "@prod/**/*.#type"
        .pipe minificator()
        .pipe gulp.dest "@prod"
        .on "finish", try_resolve

        gulp.src "@dev/#type/custom/**/*.#type"
        .pipe minificator()
        .pipe gulp.dest "@prod/#type/custom"
        .on "finish", try_resolve

gulp.task "minify_js", ["ref_production_css_js"], ->
    minify_js_css "js"

gulp.task "minify_css", ["ref_production_css_js"], ->
    minify_js_css "css"

gulp.task "production", ["build_dev"], ->
    run_sequence [
        "minify_image"
        "minify_html"
        "minify_css"
        "minify_js"
        "copy_font"
        "copy_site_root"
    ], ->
        static_server.server do
            port : 9000
            root : "./@prod"


# **********************
#    DEFAULT DEV SITE
# **********************
gulp.task "default", ["static_server"]
