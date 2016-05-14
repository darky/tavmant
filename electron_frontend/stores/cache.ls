# **********************
#    MUST HAVE DEFINE
# **********************
Backbone = require "backbone"
del = require "del"
tavmant = require "../../common.ls" .call!


module.exports = class extends Backbone.Model

    _clear_resize_images = ->
        <~ del "#{tavmant.path}/tavmant-cache/resize_images", force: true .then
        @set "cleared", "Резак изображений"

    initialize : ->
        @listen-to tavmant.radio, "cache:clear:resize_images", _clear_resize_images
        @listen-to tavmant.radio, "cache:reset", @clear
