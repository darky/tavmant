# *****************
#    NODE JS API
# *****************
fs = require "fs"


# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
Backbone = require "backbone"
tavmant = require "../../common.ls" .call!


Yakubovich = require "../../gulp/build_yakubovich.ls"


module.exports = class extends Backbone.Model

    _instance : null

    _read = (query)->
        err, helpers <~ @_instance.get_helpers!
        if err
            tavmant.radio.trigger "logs:new:err", (err.message or err)
        else if query
            @set "helpers", helpers.filter (helper)-> !! helper.name.match query
        else
            @set "helpers", helpers

    initialize : ->
        @_instance = new Yakubovich
        @listen-to tavmant.radio, "yakubovich:read", _read
