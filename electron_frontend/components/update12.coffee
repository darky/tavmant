# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
React = require "react"
$ = React.DOM
Backbone_Mixin = require "backbone-react-component"
tavmant = require "../../common.coffee" .call!


alertify = require "alertify.js"


module.exports = class extends React.Component

    _do_it = ->
         <- alertify.confirm "Убедитесь, что вы перед обновлением сохранили все ваши изменения в разделе \"Облако\""
         tavmant.radio.trigger "update12:start"

    component-will-mount : ->
        Backbone_Mixin.on-model @, tavmant.stores.update12_store

    component-will-unmount : ->
        Backbone_Mixin.off @

    render : ->
        if @state.model.updated
            alertify.log "Готово, скоро будет перезагрузка..."
            _.delay do
                -> location.reload!
                5000

        $.div null,
            $.p null,
                "Для процедуры обновления необходимо в разделе \"Облако\" сохранить все изменения. \
                Затем тут нажмите \"Обновиться до 12 версии\". \
                После успешного обновления программа автоматически перезагрузится. \
                После перезагрузки снова сохраните изменения в разделе \"Облако\""
            $.span do
                class-name : "btn btn-default"
                on-click : _do_it
                "Обновиться до 12 версии"
