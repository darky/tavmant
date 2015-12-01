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
livereload = require "livereload"
run_sequence = require "run-sequence"
watch = require "gulp-watch"


# ***********************
#    LIVERELOAD DEFINE
# ***********************
module.exports = ->
    server = livereload.create-server!

    reload = ->
        server.refresh ""

    watch [
        fs.realpath-sync "layouts" .concat "/**/*.html"
        fs.realpath-sync "partials" .concat "/**/*.html"
        fs.realpath-sync "pages" .concat "/**/*.html"
        fs.realpath-sync "templates" .concat "/**/*.html"
    ], (file)->
        run_sequence [
            "построение HTML"
        ], reload

    watch [
        fs.realpath-sync "assets" .concat "/**/*.js"
        fs.realpath-sync "assets" .concat "/**/*.css"
    ], ->
        run_sequence [
            "копирование CSS JS"
        ], reload

    watch do
        [
            fs.realpath-sync "assets" .concat "/**/*"
            "!" + fs.realpath-sync "assets" .concat "/**/*.js"
            "!" + fs.realpath-sync "assets" .concat "/**/*.css"
            "!" + fs.realpath-sync "assets" .concat "/**/.DS_Store"
            "!" + fs.realpath-sync "assets" .concat "/**/Thumbs.db"
        ].concat if tavmant.modules.resize_images
            _.map tavmant.modules.resize_images.paths, (pth)->
                "!" + fs.realpath-sync pth.split("/").0
                .concat "/"
                .concat _.rest(pth.split("/")).join("/").concat "/**/*.jpg"
        else
            []
        ->
            run_sequence [
                "копирование изображений и других бинарных файлов"
            ], reload

    if tavmant.modules.category
        watch [
            fs.realpath-sync "categories" .concat "/*.csv"
        ], ->
            run_sequence ["построение категорий"], reload

    if tavmant.modules.resize_images
        watch do
            _.map tavmant.modules.resize_images.paths, (pth)->
                fs.realpath-sync pth.split("/").0
                .concat "/"
                .concat _.rest(pth.split("/")).join("/").concat "/**/*.jpg"
            (file)->
                global.tavmant.radio["current:resize:image"] = file.path
                run_sequence [
                    "резка изображений"
                ], reload
