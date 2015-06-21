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


        # *************
        #    PRIVATE
        # *************
        _generate_html = (project_name, images_files)->
            locale_project_name = _.capitalize do
                project_name
                .replace /-/g, " "

            _.reduce do
                images_files
                (accum, image_file, i)->
                    accum += """
                        <div class="parallax-project parallax-project-#{project_name}-#{i + 1}">
                        </div>
                    """
                """
                    ---
                    title: Проект от Custom-Pro - #{locale_project_name}
                    style: true
                    script: true
                    ---

                """

        # ***************
        #    PROTECTED
        # ***************
        _get_html_stream : ->
            [project_name, images_files] = @options.project

            stream = Stream.Readable object-mode : true
            stream._read = ->
                @push new gulp_util.File do
                    base     : path.join process.env.PWD, "pages/"
                    contents : new Buffer _generate_html project_name, images_files
                    cwd      : process.env.PWD
                    path     : path.join process.env.PWD, "pages/portfolio", "#{project_name}.html"
                @push null
            stream