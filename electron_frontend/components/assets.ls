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
Files = require "./files.ls"


module.exports = class extends React.Component

    component-will-mount : ->
        Backbone_Mixin.on @, models :
            files : tavmant.stores.files_store

    component-will-unmount : ->
        Backbone_Mixin.off @

    render : ->
        $.div null,
            $.div class-name : "col-md-3 col-lg-3",
                React.create-element Files, folder : "assets", filter : /(\/|\\)assets(\/|\\)img(\/|\\)/
            $.div class-name : "col-md-9 col-md-9",
                React.create-element Ace,
                    ext     : path.extname @state.files.current
                    content : @state.files.content
