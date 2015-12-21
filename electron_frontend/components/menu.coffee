# **********************
#    MUST HAVE DEFINE
# **********************
React = require "react"
$ = React.DOM


module.exports = class extends React.Component

    render : ->
        $.ul class-name : "nav nav-pills nav-stacked",
            $.li role : "presentation",
                $.a href : "\#git", "Облако (Получение/Отправка)"
            $.li role : "presentation",
                $.a href : "#", "Запуск сервера"
