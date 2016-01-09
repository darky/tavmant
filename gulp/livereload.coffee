# ***********************
#    NODEJS API DEFINE
# ***********************
fs = require "fs"
path = require "path"


# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
tavmant = require "../common.coffee" .call!


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
        ].concat if tavmant.stores.settings_store.attributes.gallery
            fs.realpath-sync "#{tavmant.path}/templates" .concat "/**/*.html"
        else
            []
        .concat if tavmant.stores.settings_store.attributes.yakubovich
            fs.realpath-sync "#{tavmant.path}/api" .concat "/**/*.js"
        else
            []
        ->
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
        ].concat if tavmant.stores.settings_store.attributes.resize_images
            _.map tavmant.stores.settings_store.attributes.resize_images.paths, (pth)->
                "!" + fs.realpath-sync "#{tavmant.path}/" + pth.split("/").0
                .concat "/"
                .concat _.rest(pth.split("/")).join("/").concat "/**/*.jpg"
        else
            []
        ->
            run_sequence [
                "копирование изображений и других бинарных файлов"
            ], reload

    if tavmant.stores.settings_store.attributes.category
        change_categories_debounce = _.debounce ->
            run_sequence ["построение категорий" "построение HTML"], reload
        , 300

        watch do
            [
                fs.realpath-sync "#{tavmant.path}/db/categories" .concat "/*.json"
                fs.realpath-sync "#{tavmant.path}/db/subcategories" .concat "/*.json"
                fs.realpath-sync "#{tavmant.path}/templates/categories" .concat "/**/*.html"
            ].concat if tavmant.stores.settings_store.attributes.category.portfolio
                []
            else
                fs.realpath-sync "#{tavmant.path}/db/subcategory_items" .concat "/**/*.json"
            ->
                change_categories_debounce.cancel!
                change_categories_debounce!

    if tavmant.stores.settings_store.attributes.resize_images
        resize_images_throttle = _.debounce ->
            run_sequence do
                [
                    "резка изображений"
                    "построение HTML"
                ].concat if tavmant.stores.settings_store.attributes.category
                    "построение категорий"
                else
                    []
                reload
        , 300

        watch do
            _.map tavmant.stores.settings_store.attributes.resize_images.paths, (pth)->
                fs.realpath-sync "#{tavmant.path}/" + pth.split("/").0
                .concat "/"
                .concat _.rest(pth.split("/")).join("/").concat "/**/*.jpg"
            ->
                resize_images_throttle.cancel!
                resize_images_throttle!

    done!
