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
                $.li null,
                    "11.0.1"
                    $.ul null,
                        $.li null, "Список файлов в контейнере с прокруткой"
                        $.br!
                        $.li null, "Исправлена ошибка, где в Windows не открывались категории"
                $.li null,
                    "11.0.0"
                    $.ul null,
                        $.li null, "резка изображений в ~2 раза быстрее из-за использования libvips вместо GraphicsMagick"
                $.li null,
                    "10.0.2"
                    $.ul null,
                        $.li null, "не срабатывает лишний раз копирование изображений при резке одной фотографии"
