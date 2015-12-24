# **********************
#    MUST HAVE DEFINE
# **********************
React = require "react"
$ = React.DOM
Backbone_Mixin = require "backbone-react-component"


Files = require "./files.coffee"


module.exports = class extends React.Component

    component-will-mount : ->
        Backbone_Mixin.on @, models :
            files    : tavmant.stores.files_store
            settings : tavmant.stores.settings_store

    component-will-unmount : ->
        Backbone_Mixin.off @

    render : ->
        $.div null,
            if @state.settings.category.portfolio
                123
            else
                React.create-element Files, folder : "categories"
