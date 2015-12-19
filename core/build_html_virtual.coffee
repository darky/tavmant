# ***********************
#    NODEJS API DEFINE
# ***********************
Stream = require "stream"
path = require "path"


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

    class HTML_Builder_Virtual extends HTML_Builder

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
            content = @options.content
            path_option = @options.path

            stream = Stream.Readable object-mode : true
            stream._read = ->
                @push new gulp_util.File do
                    base     : path.join tavmant.path, "pages/"
                    contents : content
                    cwd      : process.env.PWD
                    path     : path_option
                @push null
            stream