# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
React = require "react"
$ = React.DOM
Backbone_Mixin = require "backbone-react-component"


# ***********
#    GRID
# ***********
window.jQuery = require "jquery"
require "jquery-ui"
require "jsgrid/dist/jsgrid.js"


module.exports = class extends React.Component

    _add = ->
        jQuery "\#table" .js-grid "insertItem", ["","","","","","",""]

    _destroy_grid = ->
        jQuery "\#table .jsgrid-grid-body tbody" .sortable "destroy"
        jQuery "\#table" .js-grid "destroy"

    _init_grid = (obj = {})->
        _destroy_grid!
        jQuery "\#table" .js-grid do
            data : obj.new_data or @state.model.content
            delete-confirm : "Удалить?"
            editing : true
            fields : [
                name  : "0"
                title : "ID"
                type  : "text"
            ,
                name  : "1"
                title : "Название"
                type  : "text"
            ,
                name  : "2"
                title : "Родитель (для подкатегории)"
                type  : "text"
            ,
                name  : "3"
                title : "Флаг фаворит"
                type  : "text"
            ,
                name  : "4"
                title : "Мета-информация"
                type  : "textarea"
            ,
                name  : "5"
                title : "Текст"
                type  : "textarea"
            ,
                name  : "6"
                title : "Фильтр"
                type  : "textarea"
            ,
                item-template : (value, row)->
                    "<img width=100 src=\"#{tavmant.path}/assets/img/tavmant-categories/#{row.0}.jpg\">"
                title : "Фото"
            ,
                type : "control"
            ]
            width : "100%"
        jQuery "\#table .jsgrid-grid-body tbody" .sortable do
            update : ->
                reordered_data = _.map do
                    jQuery "\#table .jsgrid-grid-body tr"
                    (el)-> jQuery el .data "JSGridItem"
                _init_grid new_data : reordered_data

    _save = ->
        tavmant.radio.trigger "category:save",
            jQuery "\#table" .data "JSGrid" .data

    component-did-mount : _init_grid

    component-did-update : _init_grid

    component-will-mount : ->
        Backbone_Mixin.on-model @, tavmant.stores.category_store
        tavmant.radio.trigger "category:read"

    component-will-unmount : ->
        _destroy_grid!
        Backbone_Mixin.off @

    render : ->
        $.div null,
            $.div id : "table", class-name : "row"
            $.div class-name : "row pager",
                $.button do
                    on-click : _add
                    "Добавить"
                $.button do
                    on-click : _save.bind @
                    "Сохранить"
