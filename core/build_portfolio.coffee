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


# **********************
#    GULP & KO DEFINE
# **********************
gulp = require "gulp"


# **************
#    GRAPHICS
# **************
gm = require "gm" .sub-class image-magick : true


# *******************
#    CORE CLASSES
# *******************
HTML_Portfolio_Build = require "./build_html_portfolio.coffee"


module.exports =

    class Build_Portfolio


        # *************
        #    PRIVATE 
        # *************
        _res_to_px =
            low  : "767px"
            med  : "1400px"
            high : "1920px"

        _get_projects = (cb)->
            err, data <- dir_helper.paths "./assets/img/tavmant-portfolio"
            cb do
                _ data.dirs
                .map (dir_path)->
                    result = []
                    result.push path.basename dir_path
                    result.push do
                        _ data.files
                        .filter (file_path)->
                            !!file_path.replace(/\\/g, "").match dir_path.replace(/\\/g, "")
                        .map (file_path)->
                            path.basename file_path
                        .value!
                    result
                .value!

        _get_settings = (projects, cb)->
            err, contents <- async.map projects, ([project], next)->
                err, content <- fs.read-file "./settings/portfolio/#{project}.txt" encoding : "utf8"
                next null, [project, content]

            cb _.map contents, ([project, content])->
                per_image_str = content.split "\n"
                per_res_str = _.map per_image_str, (str)->
                    str.split "|"
                [
                    project
                    do ->
                        res_str_arr <- _.map per_res_str
                        accum, res, i <- _.reduce ["low", "med", "high"], _, {}
                        accum["#res"] = _.compact res_str_arr[i].split " "
                        accum
                ]

        _generate_text_assets = (settings, type, cb)->
            <- fs.mkdir "#{process.cwd()}/@dev/#{type}/custom/portfolio"
            css_generator = require "#{process.cwd()}/javascript/portfolio/get_css.js"
            js_generator = require "#{process.cwd()}/javascript/portfolio/get_js.js"

            <- async.map settings, (settings_item, next)->
                fs.write-file "#{process.cwd()}/@dev/#{type}/custom/portfolio/#{settings_item.0}.html.#{type}",
                    _.reduce do
                        settings_item.1
                        (accum, image_setting, i)->
                            accum +=
                                switch type
                                | "css" => css_generator image_setting, settings_item.0, i + 1
                                | "js" => js_generator image_setting, settings_item.0, i + 1, settings_item.1.length
                        ""
                    next
            cb!

        _generate_images = (settings, projects, cb)->
            <- async.map settings, (settings_item, next)->
                length = _.find projects, (project)-> project.0 is settings_item.0
                .1.length

                async.map-series [1 to length], (i, cb)->
                    async.for-each-of-series _res_to_px, (px, res, cb)->
                        _image_process settings_item,
                            i
                            parse-int px
                            res
                            cb
                    , cb
                , next
            cb!

        _image_process = ([project_name, settings], i, size, res, cb)->
            vertical_offset = settings[i-1][res][3]
            vertical_offset = "+0" if vertical_offset is "0"

            horizontal_offset = settings[i-1][res][2]
            horizontal_offset = "+0" if horizontal_offset is "0"

            err, {width, height} <- gm "#{process.cwd()}/assets/img/tavmant-portfolio/#{project_name}/#{i}.jpg" .size

            <- gm "#{process.cwd()}/assets/img/tavmant-portfolio/#{project_name}/#{i}.jpg"
                .resize size
                .page size, height / (width / size), "#{horizontal_offset}#{vertical_offset}"
                .flatten()
                .write "#{process.cwd()}/@dev/img/tavmant-portfolio/#{project_name}/#{i}-#{res}.jpg"

            cb!


        # ************
        #    PUBLIC
        # ************
        start : (cb)->
            projects <- _get_projects!

            if global["current:portfolio:project"]
                projects = _.filter projects, (project)->
                    project.0 is that

            <- async.each projects, (project, next)->
                html_portfolio_builder =
                    new HTML_Portfolio_Build project : project
                html_portfolio_builder.start next

            settings <- _get_settings projects
            err <- async.parallel [
                async.apply _generate_text_assets, settings, "css"
                async.apply _generate_text_assets, settings, "js"
                async.apply _generate_images, settings, projects
            ]
            if err then throw err else cb!
