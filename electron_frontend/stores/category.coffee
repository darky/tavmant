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


module.exports = class extends Backbone.Model

    _save = (data)->
        err, content <~ csv_stringify data, delimiter : ";"
        if err
            tavmant.radio.trigger "logs:new:err", err.message or err
            return
        err <~ fs.write-file "#{tavmant.path}/categories/tavmant-list.csv", content
        if err
            tavmant.radio.trigger "logs:new:err", err.message or err
        else
            tavmant.radio.trigger "category:read"

    _read = ->
        err, content <~ fs.read-file "#{tavmant.path}/categories/tavmant-list.csv", encoding : "utf8"
        if err
            tavmant.radio.trigger "logs:new:err", err.message or err
            return
        err, parsed <~ csv_parse content, delimiter : ";"
        if err
            tavmant.radio.trigger "logs:new:err", err.message or err
        else
            @set "content", parsed

    initialize : ->
        @listen-to tavmant.radio, "category:read", _read
        @listen-to tavmant.radio, "category:save", _save
