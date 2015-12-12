# *****************
#    NODEJS API
# *****************
fs = require "fs"
os = require "os"


# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
yaml = require "js-yaml"


# ********************
#    GLOBAL DEFINE
# ********************
global.tavmant = {}
global.tavmant.radio = {}
modules = fs.read-file-sync "settings/modules.yaml", encoding : "utf8"
global.tavmant.modules = yaml.safe-load modules
global.tavmant.helpers = require "./core/helpers.coffee"


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
static_server = require "node-static"
uglify = require "gulp-uglify"
useref = require "gulp-useref"


# ******************
#    LOCAL SERVER
# ******************
up_server = (dir)->
    file = new static_server.Server dir
    require "http" .create-server (req, res)->
        req.add-listener "end", -> file.serve req, res
        .resume!
    .listen 9000, -> console.log "Сервер поднят по адресу localhost:9000"


# ***************
#    BUILD DEV
# ***************
gulp.task "очистка", (cb)->
    del ["@dev/**/*.*", "@prod/**/*.*"], cb

gulp.task "построение категорий", (cb)->
    Categories_Build = require "./core/build_categories.coffee"
    categories_builder = new Categories_Build
    categories_builder.start cb

gulp.task "построение HTML", (cb)->
    HTML_Build = require "./core/build_html.coffee"
    html_builder = new HTML_Build
    html_builder.start cb

gulp.task "резка изображений", (cb)->
    Resize_Images = require "./core/resize_images.coffee"
    resize_images = new Resize_Images
    resize_images.start cb

gulp.task "копирование CSS JS", ->
    gulp.src [
        "./assets/**/*.js"
        "./assets/**/*.css"
    ]
    .pipe cache "text_assets"
    .pipe gulp.dest "./@dev/"

gulp.task "копирование изображений и других бинарных файлов", ->
    gulp.src ["./assets/**/*", "!./assets/**/*.js", "!./assets/**/*.css", "!./assets/img/tavmant-portfolio/**/*.jpg"]
    .pipe gulp.dest "./@dev/"

gulp.task "базовая сборка", ["очистка"], (cb)->
    run_sequence do
        [
            "построение HTML"
            "копирование изображений и других бинарных файлов"
            "копирование CSS JS"
        ].concat if tavmant.modules.category then "построение категорий" else []
        .concat if tavmant.modules.resize_images then "резка изображений" else []
        cb

gulp.task "сервер", ["базовая сборка"], ->
    up_server "./@dev"
    require "./core/livereload.coffee" .call!

# *****************
#    PRODUCTION
# *****************
gulp.task "копирование шрифтов", ->
    gulp.src "@dev/font/**/*.*"
    .pipe gulp.dest "@prod/font"

gulp.task "копирование файлов в корень сайта", ->
    gulp.src "./site_root/**/*"
    .pipe gulp.dest "@prod"

gulp.task "сжатие изображений", ->
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

gulp.task "объединение CSS JS", ->
    assets = useref.assets()
    gulp.src "@dev/**/*.html"
    .pipe assets
    .pipe assets.restore()
    .pipe useref()
    .pipe gulp.dest "@prod"

gulp.task "сжатие HTML", ["объединение CSS JS"], ->
    gulp.src "@prod/**/*.html"
    .pipe minify_html do
        collapseWhitespace : true
        removeComments     : true
    .pipe gulp.dest "@prod"

minify_js_css = !(type, cb)->
    try_resolve = _.after 2, cb
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

gulp.task "сжатие JS", ["объединение CSS JS"], (cb)->
    minify_js_css "js", cb

gulp.task "сжатие CSS", ["объединение CSS JS"], (cb)->
    minify_js_css "css", cb

gulp.task "боевая сборка", ["базовая сборка"], ->
    run_sequence [
        "сжатие изображений"
        "сжатие HTML"
        "сжатие CSS"
        "сжатие JS"
        "копирование шрифтов"
        "копирование файлов в корень сайта"
    ], ->
        up_server "./@prod"


# **********************
#    DEFAULT DEV SITE
# **********************
gulp.task "сборка для разработчика", ["сервер"]


# ******************
#    RUN PACKAGED
# ******************
if process.env.TAVMANT_PACKAGE
    # from gulp 3.9.0
    chalk = require "chalk"
    gutil = require "gulp-util"
    prettyTime = require "pretty-hrtime"

    formatError = (e)->
      unless e.err
        return e.message;

      # PluginError
      if typeof e.err.showStack is "boolean"
        return e.err.toString()

      # Normal error
      if e.err.stack
        return e.err.stack

      # Unknown (string, number, etc.)
      return new Error(String(e.err)).stack

    logEvents = (gulpInst)->

      # Total hack due to poor error management in orchestrator
      gulpInst.on "err", ->
        failed = true

      gulpInst.on "task_start", (e)->
        # TODO: batch these
        # so when 5 tasks start at once it only logs one time with all 5
        gutil.log("Стартовало", "\'" + chalk.cyan(e.task) + "\'...")

      gulpInst.on "task_stop", (e)->
        time = prettyTime(e.hrDuration)
        gutil.log(
          "Завершилось", "\'" + chalk.cyan(e.task) + "\'",
          "после", chalk.magenta(time)
        )

      gulpInst.on "task_err", (e)->
        msg = formatError(e)
        time = prettyTime(e.hrDuration)
        gutil.log(
          "\'" + chalk.cyan(e.task) + "\'",
          chalk.red("завершилось с ошибкой после"),
          chalk.magenta(time)
        )
        gutil.log(msg)

      gulpInst.on "task_not_found", (err)->
        gutil.log(
          chalk.red("Задача \'" + err.task + "\' отсутствует")
        )
        process.exit(1)

    logEvents gulp
    gulp.start [that]
