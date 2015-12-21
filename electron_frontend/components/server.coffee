# **********************
#    MUST HAVE DEFINE
# **********************
React = require "react"
$ = React.DOM
Backbone_Mixin = require "backbone-react-component"


# ************
#    STORES
# ************
Server_Store = require "../stores/server.coffee"
server_store = new Server_Store


module.exports = class extends React.Component

    _dev = ->
        tavmant.radio.trigger "server:start:dev"

    _prod = ->
        tavmant.radio.trigger "server:start:prod"

    component-will-mount : ->
        Backbone_Mixin.on-model @, model : server_store

    component-will-unmount : ->
        Backbone_Mixin.off @

    render : ->
        $.div null,
            $.div class-name : "row pager",
                $.button class-name : "btn btn-default", on-click : _dev,
                    "Запуск в режиме разработчика"
                $.button class-name : "btn btn-default", on-click : _prod,
                    "Запуск в боевом режиме"
            $.div class-name : "row pager",
                if @state.model.waiting
                    "Запускается..."
                else if @state.model.server is "dev"
                    "Запущено в режиме разработчика"
                else if @state.model.server is "prod"
                    "Запущено в боевом разработчика"
