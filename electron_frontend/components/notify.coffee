# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
alertify = require "alertify.js"
React = require "react"
$ = React.DOM
Backbone_Mixin = require "backbone-react-component"
tavmant = require "../../common.coffee" .call!


module.exports = class extends React.Component

    component-will-mount : ->
        Backbone_Mixin.on-model @, tavmant.stores.logs_store

    component-will-unmount : ->
        Backbone_Mixin.off @

    render : ->
        last_log = _.last @state.model.logs
        if last_log?.type is "error"
            alertify.error last_log.text
        $.div null
