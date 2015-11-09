# ***********************
#    NODEJS API DEFINE
# ***********************
fs = require "fs"
path = require "path"


# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"


# **********************
#    GULP & KO DEFINE
# **********************
gulp = require "gulp"
run_sequence = require "run-sequence"
watch = require "gulp-watch"


# ***********************
#    LIVERELOAD DEFINE
# ***********************
module.exports = (static_server)->
    page_reload = ->
        gulp.src "@dev/**/*.html"
        .pipe static_server.reload()

    watch [
        fs.realpath-sync "layouts" .concat "/**/*.html"
        fs.realpath-sync "partials" .concat "/**/*.html"
        fs.realpath-sync "pages" .concat "/**/*.html"
        fs.realpath-sync "templates" .concat "/**/*.html"
    ], (file)->
        run_sequence [
            "build_html"
        ], page_reload

    watch [
        fs.realpath-sync "assets" .concat "/**/*.js"
        fs.realpath-sync "assets" .concat "/**/*.css"
    ], ->
        run_sequence [
            "copy_text_assets"
        ], page_reload

    watch [
        fs.realpath-sync "assets" .concat "/**/*"
        "!" + fs.realpath-sync "assets" .concat "/**/*.js"
        "!" + fs.realpath-sync "assets" .concat "/**/*.css"
        "!" + fs.realpath-sync "assets" .concat "/img/tavmant-portfolio/**/*.jpg"
    ], ->
        run_sequence [
            "copy_assets"
        ], page_reload

    if global["tavmant:modules"].portfolio
        watch [
            fs.realpath-sync "settings" .concat "/portfolio/*.txt"
            fs.realpath-sync "assets" .concat "/img/tavmant-portfolio/**/*.jpg"
        ], (file)->
            switch true
            | !!file.path.match /\.txt$/ =>
                project = path.basename file.path, ".txt"
            | !!file.path.match /\.jpg$/ =>
                project =
                    _ file.path.split path.sep
                    .take-right 2
                    .first!

            global["current:portfolio:project"] = project

            run_sequence [
                "build_portfolio"
            ], page_reload

    if global["tavmant:modules"].category
        watch [
            fs.realpath-sync "categories" .concat "/*.csv"
        ], ->
            run_sequence ["build_categories"], page_reload
