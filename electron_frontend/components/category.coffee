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
        items = _get_items!
        i = 1
        while (!!_.find items, (item)-> item.id is "new#{i}")
            i += 1
        items.unshift id : "new#{i}"
        tavmant.radio.trigger "category:reorder", items, @_dir!

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

    _init_grid = ->
        _destroy_grid!
        jQuery "\#table" .js-grid do
            data : @state.model.content
            delete-confirm : "Удалить?"
            editing : true
            fields : @_fields!
            on-item-deleted : @_delete.bind @
            on-item-updated : @_save.bind @
            width : "100%"
        jQuery "\#table .jsgrid-grid-body tbody" .sortable do
            update : ~>
                tavmant.radio.trigger "category:reorder", _get_items!, @_dir!

    _delete : (args)->
        tavmant.radio.trigger "category:delete", "#{@_dir args}/#{args.item.id}"

    _dir : -> "categories"

    _fields : ->
        [
            name  : "id"
            title : "ID"
            type  : "text"
        ,
            name  : "locale"
            title : "Название"
            type  : "text"
        ,
            name  : "favorite"
            title : "Флаг фаворит"
            type  : "text"
        ,
            item-template : (value)->
                "<div style=\"white-space: nowrap; overflow: hidden; text-overflow: ellipsis;\">#{value or ""}</div>"
            name  : "meta"
            title : "Мета-информация"
            type  : "textarea"
        ,
            item-template : (value)->
                "<div style=\"white-space: nowrap; overflow: hidden; text-overflow: ellipsis;\">#{value or ""}</div>"
            name  : "content"
            title : "Текст"
            type  : "textarea"
        ,
            name  : "query"
            title : "Фильтр"
            type  : "textarea"
        ,
            item-template : (value, row)->
                "<img width=100 src=\"#{tavmant.path}/assets/img/tavmant-categories/#{row.id}.jpg?_=#{_.random 1000000000, 10000000000}\">"
            title : "Фото"
        ,
            type : "control"
        ]

    _get_items = ->
        _.map do
            jQuery "\#table .jsgrid-grid-body tr"
            (el)-> jQuery el .data "JSGridItem"

    _get_photo_path : ($selected)->
        $selected.data "JSGridItem" .id

    _save : (args)->
        tavmant.radio.trigger "category:save", args.item, "#{@_dir args}"
        if args.item.id isnt args.previous-item.id
            tavmant.radio.trigger "category:delete", "#{@_dir args}/#{args.previous-item.id}"

    component-did-mount : _init_grid

    component-did-update : _init_grid

    component-will-mount : ->
        Backbone_Mixin.on-model @, tavmant.stores.category_store
        tavmant.radio.trigger "category:read", @_dir!

    component-will-unmount : ->
        _destroy_grid!
        Backbone_Mixin.off @
        tavmant.radio.trigger "category:reset"

    render : ->
        $.div null,
            $.div class-name : "row",
                "Добавление фото"
                React.create-element Dropzone, on-drop : _add_photo.bind @
            $.div class-name : "row pager",
                $.button do
                    on-click : _add.bind @
                    "Добавить"
            $.div id : "table", class-name : "row"
