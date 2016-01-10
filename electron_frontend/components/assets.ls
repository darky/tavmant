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


Ace = require "./ace.ls"
alertify = require "alertify.js"
Dropzone = require "react-dropzone"
Files = require "./files.ls"


module.exports = class extends React.Component

    _add_picture = (files)->
        path <- alertify.prompt "Куда закинуть? (Например: img/portfolio)"
        tavmant.radio.trigger "assets:add:picture", files, path

    component-will-mount : ->
        Backbone_Mixin.on @, models :
            assets : tavmant.stores.assets_store
            files  : tavmant.stores.files_store

    component-will-unmount : ->
        Backbone_Mixin.off @

    render : ->
        $.div null,
            $.div class-name : "col-md-3 col-lg-3",
                React.create-element Files, folder : "assets"
            $.div class-name : "col-md-9 col-md-9",
                if path.extname(@state.files.current) in [".jpg", ".png", ".gif"]
                    $.div class-name : "thumbnail",
                        $.img src : @state.files.current
                else
                    React.create-element Ace,
                        ext     : path.extname @state.files.current
                        content : @state.files.content
                React.create-element Dropzone, on-drop : _add_picture
