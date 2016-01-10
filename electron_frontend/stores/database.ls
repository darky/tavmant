# ****************
#    NODEJS API
# ****************
fs = require "fs"
path = require "path"


# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
async = require "async"
Backbone = require "backbone"
bro = require "brototype"
dir_helper = require "node-dir"
tavmant = require "../../common.ls" .call!


module.exports = class extends Backbone.Model

    get_data_from_fs : (cb)->
        err, file_paths <~ dir_helper.files "#{tavmant.path}/db"
        if err then cb err; return
        err, files_contents <~ async.map file_paths, (file_path, next)->
            err, content <- fs.read-file file_path, encofing : "utf8"
            if err then next err else next null, [
                file_path.replace "#{tavmant.path}#{path.sep}db#{path.sep}", "" .replace /\.json$/, "" 
                JSON.parse content
            ]
        if err then cb err; return
        result = _.reduce files_contents, (accum, [file_path, content])->
            bro accum .make-it-happen do
                file_path.replace //#{path.sep}//g, "."
                content
            accum
        , {}
        @clear!
        @set result
        cb!
