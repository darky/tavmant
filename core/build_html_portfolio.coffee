# ***********************
#    NODEJS API DEFINE
# ***********************
Stream = require "stream"
path = require "path"


# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"


# **********************
#    GULP & KO DEFINE
# **********************
gulp = require "gulp"
gulp_util = require "gulp-util"


# *******************
#    CORE CLASSES
# *******************
HTML_Builder = require "./build_html.coffee"


module.exports =

    class HTML_Builder_Portfolio extends HTML_Builder

        # **********
        #    INIT
        # **********
        (options)->
            @options = options
            super ...


        # ***************
        #    PROTECTED
        # ***************
        _get_html_stream : ->
            [project_name, images_files] = @options.project
            html_generator = require "#{process.cwd()}/javascript/portfolio/get_html.js"

            stream = Stream.Readable object-mode : true
            stream._read = ->
                @push new gulp_util.File do
                    base     : path.join process.env.PWD, "pages/"
                    contents : new Buffer html_generator project_name, images_files
                    cwd      : process.env.PWD
                    path     : path.join process.env.PWD, "pages/portfolio", "#{project_name}.html"
                @push null
            stream