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
        _get_helpers = (cb)->
            err, extra_helpers <- async.map [
                module_class : require "./build_gallery.coffee"
                module_name : "gallery"
            ,
                module_class : require "./build_categories.coffee"
                module_name : "category"
            ], (item, next)->
                if global["tavmant:modules"][item.module_name]
                    obj = new item.module_class
                    helpers <- obj.get_helpers!
                    next null, helpers
                else
                    next null, []
            cb err, _.flatten extra_helpers

        _get_layout_content =
            async.apply fs.read-file, "./layouts/main.html", encoding : "utf8"

        _get_partials = (cb)->
            err, partial_paths <- dir_helper.paths "./partials" true
            if err then console.log err; return
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
            if err then console.log err; return
            cb res


        # ***************
        #    PROTECTED
        # ***************
        _build : (build_options, cb)->
            @_get_html_stream!
            .pipe front_matter()
            .pipe @_build_transform build_options
            .pipe rename _rename_file_to_index
            .pipe gulp.dest "./@dev/"
            .on "finish", cb

        _build_transform : (build_options)->
            through.obj (file, enc, cb)->
                file_name =
                    _ file.path.split path.sep
                    .drop-while (dir, i, arr)-> arr[i-1] isnt "pages"
                    .value!.join "/" .replace /\.html$/, ""

                html_build(
                    _.extend file.frontMatter,
                        file_name : file_name
                    build_options
                )
                ._transform ...

        _get_html_stream : ->
            gulp.src "./pages/**/*.html"


        # ************
        #    PUBLIC
        # ************
        start : (cb)->
            options <~ _setup
            <- @_build options
            cb!
