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
server = null
module.exports = (done)->
    <- (next)-> server?config.server.close next or next!
    server := livereload.create-server!

    reload = ->
        server.refresh ""

    watch do
        [
            fs.realpath-sync "#{tavmant.path}/layouts" .concat "/**/*.html"
            fs.realpath-sync "#{tavmant.path}/partials" .concat "/**/*.html"
            fs.realpath-sync "#{tavmant.path}/pages" .concat "/**/*.html"
        ].concat if tavmant.modules.category or tavmant.modules.gallery
            fs.realpath-sync "#{tavmant.path}/templates" .concat "/**/*.html"
        else
            []
        .concat if tavmant.modules.yakubovich
            fs.realpath-sync "#{tavmant.path}/api" .concat "/**/*.js"
        else
            []
        (file)->
            run_sequence [
                "построение HTML"
            ], reload

    watch [
        fs.realpath-sync "#{tavmant.path}/assets" .concat "/**/*.js"
        fs.realpath-sync "#{tavmant.path}/assets" .concat "/**/*.css"
    ], ->
        run_sequence [
            "копирование CSS JS"
        ], reload

    watch do
        [
            fs.realpath-sync "#{tavmant.path}/assets" .concat "/**/*"
            "!" + fs.realpath-sync "#{tavmant.path}/assets" .concat "/**/*.js"
            "!" + fs.realpath-sync "#{tavmant.path}/assets" .concat "/**/*.css"
            "!" + fs.realpath-sync "#{tavmant.path}/assets" .concat "/**/.DS_Store"
            "!" + fs.realpath-sync "#{tavmant.path}/assets" .concat "/**/Thumbs.db"
        ].concat if tavmant.modules.resize_images
            _.map tavmant.modules.resize_images.paths, (pth)->
                "!" + fs.realpath-sync "#{tavmant.path}/" + pth.split("/").0
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
            fs.realpath-sync "#{tavmant.path}/categories" .concat "/*.csv"
        ], ->
            run_sequence ["построение категорий"], reload

    if tavmant.modules.resize_images
        watch do
            _.map tavmant.modules.resize_images.paths, (pth)->
                fs.realpath-sync "#{tavmant.path}/" + pth.split("/").0
                .concat "/"
                .concat _.rest(pth.split("/")).join("/").concat "/**/*.jpg"
            (file)->
                global.tavmant.radio.reply "gulp:current:resize:image", file.path
                run_sequence [
                    "резка изображений"
                ], reload

    done!
