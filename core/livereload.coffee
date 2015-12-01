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
module.exports = ->
    watch [
        fs.realpath-sync "layouts" .concat "/**/*.html"
        fs.realpath-sync "partials" .concat "/**/*.html"
        fs.realpath-sync "pages" .concat "/**/*.html"
        fs.realpath-sync "templates" .concat "/**/*.html"
    ], (file)->
        run_sequence [
            "build_html"
        ]

    watch [
        fs.realpath-sync "assets" .concat "/**/*.js"
        fs.realpath-sync "assets" .concat "/**/*.css"
    ], ->
        run_sequence [
            "copy_text_assets"
        ]

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
                "copy_assets"
            ]

    if tavmant.modules.category
        watch [
            fs.realpath-sync "categories" .concat "/*.csv"
        ], ->
            run_sequence ["build_categories"]

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
                ]
