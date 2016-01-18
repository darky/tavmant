# ****************
#    NODEJS API
# ****************
path = require "path"


# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
dir_helper = require "node-dir"
yaml = require "js-yaml"
tavmant = require "../common.ls" .call!


HTML_Virtual_Build = require "./build_html_virtual.ls"


module.exports = [
    name : "yaml",
    fn   : (obj, opts)->
        opts.fn yaml.safe-load obj
,
    name : "range",
    fn : (end, opts)->
        opts.fn _.range parse-int end
,
    name : "create_html"
    fn : (...path_parts, opts)->
        path = path_parts.join ""
        new Promise (resolve)->
            builder = new HTML_Virtual_Build do
                content : new Buffer opts.fn!
                path    : "#{tavmant.path}/@dev/#{path}.html"
            err <- builder.start
            if err then tavmant.radio.trigger "logs:new:err", (err.message or err)
            resolve ""
,
    name : "join"
    fn   : (...paths, opts)->
        paths.join ""
,
    name : "files_list"
    fn   : (...path_parts, opts)->
        dir_path = path_parts.join ""
        new Promise (resolve)->
            err, list <- dir_helper.files "#{tavmant.path}#{dir_path}"
            if err
                tavmant.radio.trigger "logs:new:err", (err.message or err)
                resolve ""
            else
                resolve opts.fn list.map (file_path)-> file_path.replace "#{tavmant.path}#{path.sep}assets", ""
]