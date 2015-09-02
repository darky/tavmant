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

    class HTML_Builder_Categories extends HTML_Builder

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
            {html, name} = @options

            stream = Stream.Readable object-mode : true
            stream._read = ->
                @push new gulp_util.File do
                    base     : path.join process.env.PWD, "pages/"
                    contents : new Buffer html
                    cwd      : process.env.PWD
                    path     : path.join process.env.PWD, "pages/", "#{name}.html"
                @push null
            stream