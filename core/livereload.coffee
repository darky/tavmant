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

    watch do
        [
            fs.realpath-sync "assets" .concat "/**/*"
            "!" + fs.realpath-sync "assets" .concat "/**/*.js"
            "!" + fs.realpath-sync "assets" .concat "/**/*.css"
            "!" + fs.realpath-sync "assets" .concat "/**/.DS_Store"
            "!" + fs.realpath-sync "assets" .concat "/**/Thumbs.db"
            "!" + fs.realpath-sync "assets" .concat "/img/tavmant-portfolio/**/*.jpg"
        ].concat if tavmant.modules.resize_images
            _.map tavmant.modules.resize_images.paths, (pth)->
                "!" + fs.realpath-sync pth.split("/").0
                .concat "/"
                .concat _.rest(pth.split("/")).join("/").concat "/**/*.jpg"
        else
            []
        ->
            run_sequence [
                "copy_assets"
            ], page_reload

    if tavmant.modules.category
        watch [
            fs.realpath-sync "categories" .concat "/*.csv"
        ], ->
            run_sequence ["build_categories"], page_reload

    if tavmant.modules.resize_images
        watch do
            _.map tavmant.modules.resize_images.paths, (pth)->
                fs.realpath-sync pth.split("/").0
                .concat "/"
                .concat _.rest(pth.split("/")).join("/").concat "/**/*.jpg"
            (file)->
                global.tavmant.radio["current:resize:image"] = file.path
                run_sequence [
                    "resize_images"
                ], page_reload
