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
thunkify = require "thunkify"


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

        _get_projects = -> co ->*
            paths = yield do
                thunkify dir_helper.paths
                .call dir_helper, "./assets/img/tavmant-portfolio"

            _ paths.dirs
            .map (dir_path)->
                result = []
                result.push path.basename dir_path
                result.push do
                    _ paths.files
                    .filter (file_path)->
                        !!file_path.match dir_path
                    .map (file_path)->
                        path.basename file_path
                    .value!
                result
            .value!

        _get_settings = (projects)-> co ->*
            read_file = thunkify fs.read-file 

            contents = yield _.map projects, ([project])-> co ->*
                content = yield read_file "./settings/portfolio/#{project}.txt",
                    encoding : "utf8"
                [project, content]

            _.map contents, ([project, content])->
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

        _generate_text_assets = (settings, type)-> co ->*
            write_file = thunkify fs.write-file
            mkdir = thunkify fs.mkdir  
            try yield mkdir "#{process.cwd()}/@dev/#{type}/custom/portfolio"
            css_generator = require "#{process.cwd()}/javascript/portfolio/get_css.js"
            js_generator = require "#{process.cwd()}/javascript/portfolio/get_js.js"

            yield _.map settings, (settings_item)-> co ->*
                yield write_file do
                    "#{process.cwd()}/@dev/#{type}/custom/portfolio/#{settings_item.0}.html.#{type}"
                    _.reduce do
                        settings_item.1
                        (accum, image_setting, i)->
                            accum +=
                                switch type
                                | "css" => css_generator image_setting, settings_item.0, i + 1
                                | "js" => js_generator image_setting, settings_item.0, i + 1, settings_item.1.length
                        ""
                    encoding : "utf8"

        _generate_images = (settings, projects)-> co ->*
            yield _.map settings, (settings_item)-> co ->*
                length = _.find projects, (project)-> project.0 is settings_item.0
                .1.length

                yield new Promise (resolve)->
                    async.map-series [1 to length], (i, cb)->
                        async.for-each-of-series _res_to_px, (px, res, cb)->
                            _image_process settings_item,
                                i
                                parse-int px
                                res
                                cb
                        , cb
                    , resolve

        _image_process = ([project_name, settings], i, size, res, cb)-> co ->*
            vertical_offset = settings[i-1][res][3]
            vertical_offset = "+0" if vertical_offset is "0"

            horizontal_offset = settings[i-1][res][2]
            horizontal_offset = "+0" if horizontal_offset is "0"

            {width, height} = yield new Promise (resolve)->
                gm "#{process.cwd()}/assets/img/tavmant-portfolio/#{project_name}/#{i}.jpg"
                .size (err, size)-> resolve size

            yield new Promise (resolve)->
                gm "#{process.cwd()}/assets/img/tavmant-portfolio/#{project_name}/#{i}.jpg"
                .resize size
                .page size, height / (width / size), "#{horizontal_offset}#{vertical_offset}"
                .flatten()
                .write "#{process.cwd()}/@dev/img/tavmant-portfolio/#{project_name}/#{i}-#{res}.jpg",
                    resolve

            cb()


        # ************
        #    PUBLIC
        # ************
        start : -> co ~>*
            try
                projects = yield _get_projects!
            catch
                return

            if global["current:portfolio:project"]
                projects = _.filter projects, (project)->
                    project.0 is that

            yield _.map projects, (project)->
                html_portfolio_builder =
                    new HTML_Portfolio_Build project : project
                html_portfolio_builder.start!

            settings = yield _get_settings projects

            yield [
                _generate_text_assets settings, "css"
                _generate_text_assets settings, "js"
                _generate_images settings, projects
            ]
