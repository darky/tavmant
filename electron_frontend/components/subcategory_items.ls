# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
tavmant = require "../../common.ls" .call!


Categories = require "./category.ls"


module.exports = class extends Categories

    _dir : (args)->
        if args
            "subcategory_items/#{args.item.parent or ""}"
        else
            "subcategory_items"

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
            name  : "parent"
            title : "Подкатегория"
            type  : "text"
        ,
            item-template : (value)->
                "<div style=\"white-space: nowrap; overflow: hidden; text-overflow: ellipsis;\">#{value or ""}</div>"
            name  : "meta"
            title : "Мета-информация"
            type  : "textarea"
        ,
            item-template : (value, row)->
                "
                    <img width=100 \
                    src=\"#{tavmant.path}/assets/img/tavmant-categories
                    /#{row.parent}
                    /#{row.id}.jpg?_=#{_.random 1000000000, 10000000000}\">
                "
            title : "Фото"
        ,
            type : "control"
        ]

    _get_photo_path : ($selected)->
        data = $selected.data "JSGridItem"
        "#{data.parent}/#{data.id}"

    _save : (args)->
        tavmant.radio.trigger "category:save", args.item, "#{@_dir args}"
        if args.item.parent isnt args.previous-item.parent or args.item.id isnt args.previous-item.id
            tavmant.radio.trigger "category:delete",
                "subcategory_items/#{args.previous-item.parent or ""}/#{args.previous-item.id}"
