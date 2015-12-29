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
tavmant = require "../../common.coffee" .call!


Files = require "./files.coffee"
Yakubovich = require "./yakubovich.coffee"
Ace = require "./ace.coffee"


module.exports = class extends React.Component

    _folder : "pages"

    component-will-mount : ->
        Backbone_Mixin.on-model @, tavmant.stores.files_store

    component-will-unmount : ->
        Backbone_Mixin.off @

    render : ->
        $.div null,
            $.div class-name : "col-md-3 col-lg-3",
                React.create-element Files, folder : @_folder
            $.div class-name : "col-md-9 col-lg-9",
                React.create-element Ace,
                    ext     : path.extname @state.model.current
                    content : @state.model.content
                if not @_no_yakubovich
                    React.create-element Yakubovich
