# **********************
#    MUST HAVE DEFINE
# **********************
React = require "react"
$ = React.DOM
Backbone_Mixin = require "backbone-react-component"


module.exports = class extends React.Component

    component-will-mount : ->
        Backbone_Mixin.on-model @, tavmant.stores.settings_store

    component-will-unmount : ->
        Backbone_Mixin.off @

    render : ->
        $.ul class-name : "nav nav-pills nav-stacked",
            $.li role : "presentation",
                $.a href : "\#git", "Облако (Получение/Отправка)"
            $.li role : "presentation",
                $.a href : "#", "Запуск сервера"
            $.li role : "presentation",
                $.a href : "\#assets", "Картинки, стили, скрипты..."
            $.li role : "presentation",
                $.a href : "\#pages", "Страницы"
            $.li role : "presentation",
                $.a href : "\#partials", "Части страниц"
            $.li role : "presentation",
                $.a href : "\#layouts", "Шаблоны"
            if @state.model.category
                $.li role : "category",
                    $.a href : "\#category", "Категории и подкатегории"
            if @state.model.category and not @state.model.category.portfolio
                $.li role : "category",
                    $.a href : "\#subcategory", "Элементы подкатегорий"
            if @state.model.category?.portfolio
                $.li role : "category",
                    $.a href : "\#portfolio", "Режим портфолио"
            $.li role : "presentation",
                $.a href : "\#settings", "Настройки"
            $.li role : "presentation",
                $.a href : "\#about", "О Tavmant"
