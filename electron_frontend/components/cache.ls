# **********************
#    MUST HAVE DEFINE
# **********************
React = require "react"
$ = React.DOM
Backbone_Mixin = require "backbone-react-component"
tavmant = require "../../common.ls" .call!


alertify = require "alertify.js"


module.exports = class extends React.Component

    _clear_resize_images = ->
        <- alertify.confirm "Почистить?"
        tavmant.radio.trigger "cache:clear:resize_images"

    component-will-mount : ->
        Backbone_Mixin.on-model @, tavmant.stores.cache_store

    component-will-unmount : ->
        Backbone_Mixin.off @
        tavmant.radio.trigger "cache:reset"

    render : ->
        if @state.model.cleared
            alertify.log "Почищено - #{that}"

        $.div null,
            $.div class-name : "row",
                $.span do
                    class-name : "btn btn-default"
                    on-click : _clear_resize_images
                    "Очистить кеш - Резак изображений"
