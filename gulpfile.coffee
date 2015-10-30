# *****************
#    NODEJS API
# *****************
os = require "os"


# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"


# *******************
#    LICENSE CHECK
# *******************
sha1 =
    require "crypto"
    .create-hash "sha1"

license_salt = "PR93lFP1R9GiQ79o5849987013T6570n"
license_salt2 = "iwNA8qaaTVB8pqOJQlqvmbagkOObAiIT"

license_formula = "
    #{ os.totalmem() }
    #{ os.cpus()[0].model }
    #{ license_salt }
    #{ os.type() }
    #{ os.arch() }
    #{ license_salt2 }
    #{ os.platform() }
    #{ os.homedir() }
    #{ os.networkInterfaces().en0[0].mac }
"

calculated_sha =
    sha1.update license_formula, "utf8"
    .digest "hex"
must_sha = try require "./key.js"

if calculated_sha isnt must_sha
    cipher =
        require "crypto"
        .create-cipher "aes-256-cbc", "r9qignYPa3d2glAbdMV963UDy7KqpZsv"

    console.log "LICENSE ERROR! Send information between * to darkvlados@me.com for receiving license"
    console.log """
        **********************************
        #{ cipher.update license_formula, "utf8", "hex" }\
        #{ cipher.final "hex" }
        **********************************
    """
    process.exit()


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


# ***************
#    BUILD DEV
# ***************
gulp.task "clear_dev_prod", (cb)->
    del ["@dev/**/*.*", "@prod/**/*.*"], cb

gulp.task "build_categories", ["build_html"], ->
    Categories_Build = require "./core/build_categories.coffee"
    categories_builder = new Categories_Build
    categories_builder.start!

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
    gulp.src ["./assets/**/*", "!./assets/**/*.js", "!./assets/**/*.css", "!./assets/img/tavmant-portfolio/**/*.jpg"]
    .pipe gulp.dest "./@dev/"

gulp.task "build_dev", ["clear_dev_prod"], (cb)->
    run_sequence [
        "build_categories"
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
        gutil.log("Starting", "\'" + chalk.cyan(e.task) + "\'...")

      gulpInst.on "task_stop", (e)->
        time = prettyTime(e.hrDuration)
        gutil.log(
          "Finished", "\'" + chalk.cyan(e.task) + "\'",
          "after", chalk.magenta(time)
        )

      gulpInst.on "task_err", (e)->
        msg = formatError(e)
        time = prettyTime(e.hrDuration)
        gutil.log(
          "\'" + chalk.cyan(e.task) + "\'",
          chalk.red("errored after"),
          chalk.magenta(time)
        )
        gutil.log(msg)

      gulpInst.on "task_not_found", (err)->
        gutil.log(
          chalk.red("Task \'" + err.task + "\' is not in your gulpfile")
        )
        gutil.log("Please check the documentation for proper gulpfile formatting")
        process.exit(1)

    logEvents gulp
    gulp.start [that]
