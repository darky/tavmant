# *****************
#    NODE JS API
# *****************
fs = require "fs"


# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
Backbone = require "backbone"
tavmant = require "../../common.coffee" .call!


module.exports = class extends Backbone.Model

    _read = ->
        err, content <~ fs.read-file "#{tavmant.path}/settings/modules.json", encoding : "utf8"
        if err
            tavmant.radio.trigger "logs:new:err", err.message or err
        else
            @set JSON.parse content

    _save = (content)->
        err <~ fs.write-file "#{tavmant.path}/settings/modules.json",
            JSON.stringify content, null, 2
        if err
            tavmant.radio.trigger "logs:new:err", err.message or err
        else
            @clear silent : true
            @set content
            tavmant.radio.trigger "settings:read"

    initialize : ->
        @listen-to tavmant.radio, "settings:read", _read
        @listen-to tavmant.radio, "settings:save", _save
