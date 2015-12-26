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
            $.div class-name : "pager row bg-info",
                "Вышла 11 версия! Для обновления нужно поставить libvips и прописать переменную окружения для его запускаемых файлов. \
                После этого GraphicsMagick можно удалить."
                $.br!
                $.a href : "http://www.vips.ecs.soton.ac.uk/supported/current/win32/", target : "_blank", "Скачать отсюда"
            $.ul class-name : "pager row",
                $.li null, "10.0.2 - не срабатывает лишний раз копирование изображений при резке одной фотографии"
