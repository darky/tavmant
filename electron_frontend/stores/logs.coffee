# **********************
#    MUST HAVE DEFINE
# **********************
Backbone = require "backbone"


module.exports = class extends Backbone.Model

    _new_log = (log)->
        @set "logs",
            @get "logs" .concat log

    _reset_logs = ->
        @set "logs", []

    defaults : logs : []

    initialize : ->
        @listen-to tavmant.radio, "logs:new", _new_log
        @listen-to tavmant.radio, "logs:reset", _reset_logs
