# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
React = require "react"
$ = React.DOM
Backbone_Mixin = require "backbone-react-component"
tavmant = require "../../common.coffee" .call!


# ***********
#    GRID
# ***********
window.jQuery = require "jquery"
require "jquery-ui"
require "jsgrid/dist/jsgrid.js"


# ***********
#    PHOTO
# ***********
alertify = require "alertify.js"
Dropzone = require "react-dropzone"


module.exports = class extends React.Component

    _add = ->
        jQuery "\#table" .js-grid "insertItem", ["","","","","","",""]

    _add_photo = (files)->
        $selected = jQuery "\#table .jsgrid-grid-body tr:hidden"
        if $selected.length
            file = files.0
            if file.type isnt "image/jpeg"
                alertify.log "Нужно фотографию jpg"
            else
                photo_path = @_get_photo_path $selected
                tavmant.radio.trigger "category:add:photo", photo_path, file
        else
            alertify.log "Нужно выбрать подкатегорию сначала"

    _destroy_grid = ->
        jQuery "\#table .jsgrid-grid-body tbody" .sortable "destroy"
        jQuery "\#table" .js-grid "destroy"

    _init_grid = (obj = {})->
        _destroy_grid!
        jQuery "\#table" .js-grid do
            data : obj.new_data or @_get_content!
            delete-confirm : "Удалить?"
            editing : true
            fields : @_fields!
            width : "100%"
        jQuery "\#table .jsgrid-grid-body tbody" .sortable do
            update : ~>
                reordered_data = _.map do
                    jQuery "\#table .jsgrid-grid-body tr"
                    (el)-> jQuery el .data "JSGridItem"
                _init_grid.call @, new_data : reordered_data

    _fields : ->
        [
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
            item-template : (value)->
                "<div style=\"white-space: nowrap; overflow: hidden; text-overflow: ellipsis;\">#{value}</div>"
            name  : "5"
            title : "Текст"
            type  : "textarea"
        ,
            name  : "6"
            title : "Фильтр"
            type  : "textarea"
        ,
            item-template : (value, row)->
                "<img width=100 src=\"#{tavmant.path}/assets/img/tavmant-categories/#{row.0}.jpg?_=#{_.random 1000000000, 10000000000}\">"
            title : "Фото"
        ,
            type : "control"
        ]

    _get_content : ->
        @state.model.content

    _get_photo_path : ($selected)->
        $selected.data "JSGridItem" .0

    _save : ->
        tavmant.radio.trigger "category:save",
            jQuery "\#table" .data "JSGrid" .data
            "tavmant-list.csv"

    component-did-mount : _init_grid

    component-did-update : _init_grid

    component-will-mount : ->
        Backbone_Mixin.on-model @, tavmant.stores.category_store
        tavmant.radio.trigger "category:read", "tavmant-list.csv"

    component-will-unmount : ->
        _destroy_grid!
        Backbone_Mixin.off @
        tavmant.radio.trigger "category:reset"

    render : ->
        $.div null,
            $.div id : "table", class-name : "row"
            $.div class-name : "row pager",
                $.button do
                    on-click : _add
                    "Добавить"
                $.button do
                    on-click : @_save.bind @
                    "Сохранить"
            $.div class-name : "row",
                "Добавление фото"
                React.create-element Dropzone, on-drop : _add_photo.bind @
