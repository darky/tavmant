# ****************
#    NODEJS API
# ****************
path = require "path"


# **********************
#    MUST HAVE DEFINE
# **********************
React = require "react"
$ = React.DOM
Backbone_Mixin = require "backbone-react-component"
tavmant = require "../../common.ls" .call!


alertify = require "alertify.js"
Dropzone = require "react-dropzone"
Files = require "./files.ls"


module.exports = class extends React.Component

    _add_picture = (files)->
        path <- alertify.prompt "В какую папку положить?"
        tavmant.radio.trigger "images:add:picture", files, path

    _copy_link = ->
        tavmant.radio.trigger "files:copy:clipboard"
        alertify.log "Скопировано"

    component-will-mount : ->
        Backbone_Mixin.on @, models :
            images : tavmant.stores.images_store
            files  : tavmant.stores.files_store

    component-will-unmount : ->
        Backbone_Mixin.off @

    render : ->
        $.div null,
            $.div class-name : "col-md-3 col-lg-3",
                React.create-element Files, folder : "assets/img"
            $.div class-name : "col-md-9 col-md-9",
                if @state.files.current
                    $.div class-name : "thumbnail",
                        $.img src : @state.files.current
                        $.button on-click : _copy_link, "Скопировать ссылку в буфер обмена"
                React.create-element Dropzone, on-drop : _add_picture
