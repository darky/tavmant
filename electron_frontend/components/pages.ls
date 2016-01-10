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


Files = require "./files.ls"
Yakubovich = require "./yakubovich.ls"
Ace = require "./ace.ls"


module.exports = class extends React.Component

    _folder : "pages"

    component-will-mount : ->
        Backbone_Mixin.on @, models :
            files    : tavmant.stores.files_store
            settings : tavmant.stores.settings_store

    component-will-unmount : ->
        Backbone_Mixin.off @

    render : ->
        $.div null,
            $.div class-name : "col-md-3 col-lg-3",
                React.create-element Files, folder : @_folder
            $.div class-name : "col-md-9 col-lg-9",
                React.create-element Ace,
                    ext     : path.extname @state.files.current
                    content : @state.files.content
                if @state.settings.yakubovich and not @_no_yakubovich
                    React.create-element Yakubovich
