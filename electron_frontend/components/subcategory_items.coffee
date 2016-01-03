# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
tavmant = require "../../common.coffee" .call!


Categories = require "./category.coffee"


module.exports = class extends Categories

    _dir : (args)->
        if args
            "subcategory_items/#{args.item.parent}"
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
            name  : "price"
            title : "Цена"
            type  : "text"
        ,
            name  : "parent"
            title : "Подкатегория"
            type  : "text"
        ,
            name  : "favorite"
            title : "Флаг фаворит"
            type  : "text"
        ,
            name  : "extra1"
            title : "4"
            type  : "text"
        ,
            name  : "extra2"
            title : "5"
            type  : "text"
        ,
            name  : "extra3"
            title : "6"
            type  : "text"
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
