# ***********************
#    NODEJS API DEFINE
# ***********************
fs = require "fs"


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
    ], (file)->
        require "./html_lint.coffee"
        .call null, file

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
        "!" + fs.realpath-sync "assets" .concat "/img/projects/**/*.jpg"
    ], ->
        run_sequence [
            "copy_assets"
        ], page_reload

    watch [
        fs.realpath-sync "settings" .concat "/**/*.txt"
        fs.realpath-sync "assets" .concat "/img/projects/**/*.jpg"
    ], (file)->
        switch true
        | !!file.path.match /\.txt$/ =>
            project = file.path.match //
                /
                ([\w-]+)
                .txt$
             // .1 
        | !!file.path.match /\.jpg$/ =>
            project = file.path.match //
                /
                ([\w-]+)
                /
                \d+\.jpg$
            // .1 

        global.radio.reply "current:portfolio:project", -> project

        run_sequence [
            "build_portfolio"
        ], page_reload
