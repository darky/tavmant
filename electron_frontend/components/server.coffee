# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
React = require "react"
$ = React.DOM
Backbone_Mixin = require "backbone-react-component"


module.exports = class extends React.Component

    _dev = ->
        tavmant.radio.trigger "logs:reset"
        tavmant.radio.trigger "server:start:dev"

    _prod = ->
        tavmant.radio.trigger "logs:reset"
        tavmant.radio.trigger "server:start:prod"

    component-will-mount : ->
        Backbone_Mixin.on @,
            models : 
                server_state : tavmant.stores.server_store
                logs_state : tavmant.stores.logs_store

    component-will-unmount : ->
        Backbone_Mixin.off @

    render : ->
        $.div null,
            $.div class-name : "row pager",
                $.div class-name : "col-lg-6 col-md-6 col-sm-6",
                    $.button class-name : "btn btn-default", on-click : _dev,
                        "Запуск в режиме разработчика"
                $.div class-name : "col-lg-6 col-md-6 col-sm-6",
                    $.button class-name : "btn btn-default", on-click : _prod,
                        "Запуск в боевом режиме"
            $.div class-name : "row pager",
                if @state.server_state.errored
                    $.span class-name : "bg-danger", "Произошла ошибка запуска"
                else if @state.server_state.waiting
                    $.span class-name : "bg-warning", "Запускается..."
                else if @state.server_state.running is "dev"
                    $.span class-name : "bg-success", "Запущено в режиме разработчика"
                else if @state.server_state.running is "prod"
                    $.span class-name : "bg-success", "Запущено в боевом разработчика"
            $.div class-name : "row pager small",
                _.map @state.logs_state.logs, (log)->
                    $.p do
                        key : _.unique-id "log"
                        class-name : if log.type is "error" then "bg-danger"
                        log.text
