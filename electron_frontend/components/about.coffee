# **********************
#    MUST HAVE DEFINE
# **********************
React = require "react"
$ = React.DOM


module.exports = class extends React.Component

    render : ->
        $.div null,
            $.div class-name : "pager row",
                "Версия: #{global.tavmant.VERSION}"
            $.div class-name : "pager row",
                "Истекает: #{global.tavmant.EXPIRED}"
            $.ul class-name : "pager row",
                $.li null, "10.0.2 - не срабатывает лишний раз копирование изображений при резке одной фотографии"
