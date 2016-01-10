# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
React = require "react"
$ = React.DOM
Backbone_Mixin = require "backbone-react-component"
tavmant = require "../../common.ls" .call!


alertify = require "alertify.js"
clipboard = global.require "electron" .clipboard


module.exports = class extends React.Component

    _get_helper = (e)->
        unless e.target.dataset.yakubovich then return
        <- (cb)->
            if e.target.dataset.value-inner
                alertify.ok-btn "Да, вложенный" .cancel-btn "Нет, обычный"
                .confirm "Использовать вложенный ус Якубовича?" ->
                    clipboard.write-text that
                    cb!
                , ->
                    clipboard.write-text e.target.dataset.value
                    cb!
            else
                clipboard.write-text e.target.dataset.value
                cb!
        alertify.log "Скопировано в буфер обмена"

    component-will-mount : ->
        tavmant.radio.trigger "yakubovich:read"
        Backbone_Mixin.on-model @, tavmant.stores.yakubovich_store

    component-will-unmount : ->
        Backbone_Mixin.off @

    render : ->
        $.ul do
            on-click : _get_helper
            _.map @state.model.helpers, (helper)->
                $.li do
                    "data-yakubovich" : true
                    "data-value" : helper.template
                    "data-value-inner" : helper.template-inner
                    class-name : "btn btn-default"
                    key : _.unique-id "yakubovich"
                    helper.name
