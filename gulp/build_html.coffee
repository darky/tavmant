# ***********************
#    NODEJS API DEFINE
# ***********************
fs = require "fs"
path = require "path"


# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
async = require "async"
dir_helper = require "node-dir"
through = require "through2"
tavmant = require "../common.coffee" .call!


# **********************
#    GULP & KO DEFINE
# **********************
gulp = require "gulp"
front_matter = require "gulp-front-matter"
html_build = require "gulp-build"
rename = require "gulp-rename"


# ***********
#    BUILD
# ***********
module.exports =

    class HTML_Builder

        # *************
        #    PRIVATE
        # *************
        _build_transform = (build_options)->
            through.obj (file, enc, cb)->
                file_name =
                    _ file.path.split path.sep
                    .drop-while (dir, i, arr)-> arr[i-1] isnt "pages"
                    .value!.join "/" .replace /\.html$/, ""

                try
                    stream = html_build do
                        _.extend file.frontMatter, file_name : file_name
                        build_options
                    stream._transform ...
                catch e
                    tavmant.radio.trigger "logs:new:err", e.message
                    cb!

        _get_helpers = (cb)->
            err, extra_helpers <- async.map [
                module_class : require "./build_categories.coffee"
                module_name : "category"
            ,
                module_class : require "./build_yakubovich.coffee"
                module_name : "yakubovich"
            ], (item, next)->
                if tavmant.stores.settings_store.attributes[item.module_name]
                    obj = new item.module_class
                    err, helpers <- obj.get_helpers!
                    next err, helpers
                else
                    next null, []
            cb err, _.flatten extra_helpers

        _get_layout_content =
            async.apply fs.read-file, "#{tavmant.path}/layouts/main.html", encoding : "utf8"

        _get_partials = (cb)->
            err, partial_paths <- dir_helper.paths "#{tavmant.path}/partials" true
            if err
                tavmant.radio.trigger "logs:new:err", (err.message or err)
                return
            partial_names = _.map partial_paths, (partial_path)->
                path.basename partial_path, ".html"
            err, partial_contents <- async.map partial_paths, (path, next)->
                fs.read-file path, encoding : "utf8", next
            cb err, _.map partial_names, (partial, i)->
                name : partial
                tpl  : partial_contents[i]

        _rename_file_to_index = !(path)->
            if path.basename isnt "index"  and  path.basename isnt "404"
                path.dirname += "/#{path.basename}"
                path.basename = "index"

        _setup = (cb)->
            err, res <- async.parallel do
                helpers  : _get_helpers
                layout   : _get_layout_content
                partials : _get_partials
            cb err, res


        # ***************
        #    PROTECTED
        # ***************
        _build : (build_options, cb)->
            @_get_html_stream!
            .pipe front_matter!
            .on "error", (e)->
                cb "Ошибка в написании мета-информации для страницы #{e.file-name}"
            .pipe _build_transform build_options
            .pipe rename _rename_file_to_index
            .pipe gulp.dest "#{tavmant.path}/@dev/"
            .on "finish", cb

        _get_html_stream : ->
            gulp.src "#{tavmant.path}/pages/**/*.html"


        # ************
        #    PUBLIC
        # ************
        start : (cb)->
            err, options <~ _setup
            if err then cb err; return
            err <- @_build options
            cb err
