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
co = require "co"
dir_helper = require "node-dir"
through = require "through2"
thunkify = require "thunkify"


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
        _get_helpers = -> co ->*
            Gallery_Build = require "./build_gallery.coffee"
            gallery_build = new Gallery_Build
            Categories_Build = require "./build_categories.coffee"
            categories_build = new Categories_Build
            []
            .concat yield categories_build.get_helpers()
            .concat yield gallery_build.start()
        .catch (e)-> console.error e

        _get_layout_content = ->
            thunkify(
                fs.readFile
            )(
                "./layouts/main.html"
                encoding : "utf8"
            )

        _get_partials = -> co ->*
            partial_paths = yield thunkify(
                dir_helper.paths
            )(
                "./partials"
                true
            )

            partial_names = _.map partial_paths, (partial_path)->
                path.basename partial_path, ".html"

            partial_contents = yield thunkify(
                async.map
            )(
                partial_paths
                (path, next)-> fs.readFile(
                    path
                    encoding : "utf8"
                    next
                )
            )

            _.map partial_names, (partial, i)->
                name : partial
                tpl  : partial_contents[i]
        .catch (e)-> console.error e

        _rename_file_to_index = (path)->
            if path.basename isnt "index"  and  path.basename isnt "404"
                path.dirname += "/#{path.basename}"
                path.basename = "index"
                undefined

        _setup = -> co ->*
            helpers  : yield _get_helpers()
            layout   : yield _get_layout_content()
            partials : yield _get_partials()
        .catch (e)-> console.error e


        # ***************
        #    PROTECTED
        # ***************
        _build : (build_options)->
            new Promise (resolve)~>
                @_get_html_stream!
                .pipe front_matter()
                .pipe @_build_transform build_options
                .pipe rename _rename_file_to_index
                .pipe gulp.dest "./@dev/"
                .on "finish", resolve

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
        start : -> co ~>*
            yield @_build <| yield _setup()
        .catch (e)-> console.error e
