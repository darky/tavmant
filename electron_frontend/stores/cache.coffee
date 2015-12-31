# **********************
#    MUST HAVE DEFINE
# **********************
Backbone = require "backbone"
rimraf = require "rimraf"
tavmant = require "../../common.coffee" .call!


module.exports = class extends Backbone.Model

    _clear_resize_images = ->
        err <~ rimraf "#{tavmant.path}/tavmant-cache/resize_images"
        if err
            tavmant.radio.trigger "logs:new:err", (err.message or err)
        else
            @set "cleared", "Резак изображений"

    initialize : ->
        @listen-to tavmant.radio, "cache:clear:resize_images", _clear_resize_images
        @listen-to tavmant.radio, "cache:reset", @clear
