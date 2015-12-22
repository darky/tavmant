# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
React = require "react"
$ = React.DOM
Backbone_Mixin = require "backbone-react-component"


# *************
#    EDITOR
# *************
Ace = require "react-ace"
require "brace/mode/handlebars"
require "brace/theme/monokai"


# *************
#    DIALOGS
# *************
Dialogs = require "dialogs"
dialogs = new Dialogs cancel : "Отмена"


module.exports = class extends React.Component

    _add = ->
        path <- dialogs.prompt "Введите путь нового файла (Примеры: contacts.html, portfolio/biser.html)"
        if path then tavmant.radio.trigger "files:add", path

    _delete = ->
        ok <- dialogs.confirm "Удалить?"
        if ok then tavmant.radio.trigger "files:delete"

    _save_content = ->
        tavmant.radio.trigger "files:save", @refs.ace.editor.get-value!

    _select_file = (e)->
        tavmant.radio.trigger "files:select", e.target.inner-text

    _folder : "pages"

    component-will-mount : ->
        Backbone_Mixin.on-model @, tavmant.stores.files_store
        tavmant.radio.trigger "files:set:folder", @_folder
        tavmant.radio.trigger "files:list"

    component-will-unmount : ->
        Backbone_Mixin.off @

    render : ->
        $.div null,
            $.div class-name : "col-md-6 col-lg-5",
                $.div class-name : "row pager",
                    $.button class-name : "fa fa-plus", on-click : _add
                    $.button class-name : "fa fa-remove", on-click : _delete, disabled : not @state.model.current
                $.ul on-click : _select_file, class-name : "row",
                    _.map @state.model.files, (path)~> $.li do
                        class-name : if path is @state.model.current then "bg-info"
                        key : _.unique-id "file"
                        path
            $.div class-name : "col-md-6 col-lg-7",
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
