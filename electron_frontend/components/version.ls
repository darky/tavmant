# **********************
#    MUST HAVE DEFINE
# **********************
React = require "react"
$ = React.DOM
Backbone_Mixin = require "backbone-react-component"
tavmant = require "../../common.ls" .call!


module.exports = class extends React.Component

    _save_version = ->
        tavmant.radio.trigger "files:save", @refs.version.value

    component-will-mount : ->
        Backbone_Mixin.on-model @, tavmant.stores.files_store
        # TODO replace to async, when this resolved https://github.com/facebook/react/issues/4618
        tavmant.radio.trigger "files:select:sync", "#{tavmant.path}/version.txt"

    component-will-unmount : ->
        Backbone_Mixin.off @

    render : ->
        $.div class-name : "form-group",
            $.label class-name : "checkbox-inline",
                $.input type : "text", ref : "version", default-value : @state.model.content
            $.span do
                class-name : "btn btn-default"
                on-click : _save_version.bind @
                "Сохранить"
