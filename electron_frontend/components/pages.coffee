# **********************
#    MUST HAVE DEFINE
# **********************
React = require "react"
$ = React.DOM
Backbone_Mixin = require "backbone-react-component"


Files = require "./files.coffee"


# *************
#    EDITOR
# *************
Ace = require "react-ace"
require "brace/mode/handlebars"
require "brace/theme/monokai"


module.exports = class extends React.Component

    _save_content = ->
        tavmant.radio.trigger "files:save", @refs.ace.editor.get-value!

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
                $.div class-name : "row",
                    React.create-element Ace,
                        ref   : "ace"
                        mode  : "handlebars"
                        theme : "monokai"
                        value : @state.model.content
                        width : "100%"
                $.div class-name : "row pager",
                    $.button do
                        on-click : _save_content.bind @
                        "Сохранить"
