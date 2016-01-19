# ****************
#    NODEJS API
# ****************
path = require "path"


# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
React = require "react"
$ = React.DOM
Backbone_Mixin = require "backbone-react-component"
tavmant = require "../../common.ls" .call!


# *************
#    DIALOGS
# *************
alertify = require "alertify.js"


module.exports = class extends React.Component

    _add = ->
        path <- alertify.cancel-btn "Отмена" .prompt "Введите путь нового файла (Примеры: contacts.html, portfolio/biser.html)"
        tavmant.radio.trigger "files:add", path

    _delete = ->
        <- alertify.cancel-btn "Отмена" .confirm "Удалить?"
        tavmant.radio.trigger "files:delete"

    _select_file = (e)->
        tavmant.radio.trigger "files:select", e.target.dataset.path

    component-will-mount : ->
        Backbone_Mixin.on-model @, tavmant.stores.files_store
        tavmant.radio.trigger "files:set:folder", @props.folder
        tavmant.radio.trigger "files:list", @props.filter

    component-will-unmount : ->
        Backbone_Mixin.off @

    render : ->
        $.div null,
            $.div class-name : "row pager",
                $.button class-name : "fa fa-plus", on-click : _add
                $.button class-name : "fa fa-remove", on-click : _delete, disabled : not @state.model.current
            $.ul on-click : _select_file, class-name : "row pre-scrollable",
                _.map @state.model.files, (file_path)~> $.li do
                    "data-path" : file_path
                    class-name : if file_path is @state.model.current then "bg-info"
                    key : _.unique-id "file"
                    file_path.split "#{tavmant.path}#{path.sep}#{@props.folder.replace(/\//g, path.sep)}#{path.sep}" .1
