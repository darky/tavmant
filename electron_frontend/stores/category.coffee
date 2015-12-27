# *****************
#    NODE JS API
# *****************
fs = require "fs"
path = require "path"


# *****************
#    NODE JS API
# *****************
fs = require "fs"


# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
Backbone = require "backbone"
csv_parse = require "csv-parse"
csv_stringify = require "csv-stringify"
mkdirp = require "mkdirp"
to_buffer = require "blob-to-buffer"
tavmant = require "../../common.coffee" .call!


module.exports = class extends Backbone.Model

    _add_photo = (photo_path, file_blob)->
        err, buffer <~ to_buffer file_blob
        if err
            tavmant.radio.trigger "logs:new:err", err.message or err
            return
        err <~ mkdirp path.dirname "#{tavmant.path}/assets/img/tavmant-categories/#{photo_path}.jpg"
        if err
            tavmant.radio.trigger "logs:new:err", err.message or err
            return
        err <~ fs.write-file "#{tavmant.path}/assets/img/tavmant-categories/#{photo_path}.jpg", buffer
        if err
            tavmant.radio.trigger "logs:new:err", err.message or err
        else
            @set "forceupdate", _.random 1000000000, 10000000000

    _save = (data, file)->
        trimmed_data = _.map data, (row)-> _.map row, (col)-> col.trim!
        err, content <~ csv_stringify trimmed_data, delimiter : ";"
        if err
            tavmant.radio.trigger "logs:new:err", err.message or err
            return
        err <~ fs.write-file "#{tavmant.path}/categories/#{file}", content
        if err
            tavmant.radio.trigger "logs:new:err", err.message or err

    _read = (file)->
        err, content <~ fs.read-file "#{tavmant.path}/categories/#{file}", encoding : "utf8"
        if err
            tavmant.radio.trigger "logs:new:err", err.message or err
            return
        err, parsed <~ csv_parse do
            content.replace /\r\n/g, "\n"
            delimiter : ";"
        if err
            tavmant.radio.trigger "logs:new:err", err.message or err
        else
            @set "content", parsed

    _reset = ->
        @set "content", []

    initialize : ->
        @listen-to tavmant.radio, "category:reset", _reset
        @listen-to tavmant.radio, "category:read", _read
        @listen-to tavmant.radio, "category:save", _save
        @listen-to tavmant.radio, "category:add:photo", _add_photo
