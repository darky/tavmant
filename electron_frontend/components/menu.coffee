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
                $.a href : "\#pages", "Редактирование страниц"
            $.li role : "presentation",
                $.a href : "\#partials", "Редактирование частей страниц"
            $.li role : "presentation",
                $.a href : "\#layouts", "Редактирование шаблонов"
            $.li role : "presentation",
                $.a href : "\#settings", "Настройки"
