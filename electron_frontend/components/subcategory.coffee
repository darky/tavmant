# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
tavmant = require "../../common.coffee" .call!


Categories = require "./category.coffee"


module.exports = class extends Categories

    _dir : -> "subcategories"

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
            title : "Родитель"
            type  : "text"
        ,
            name  : "favorite"
            title : "Флаг фаворит"
            type  : "text"
        ,
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
