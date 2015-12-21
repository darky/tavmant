# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
Backbone = require "backbone"
git = require "simple-git"


module.exports = class extends Backbone.Model

    _history = ->
        err, log <~ @get "repo" .log
        if err
            tavmant.radio.trigger "logs:new:err", err.message
        else
            @set "history",
                _.slice log.all, 0, 10

    _status = ->
        err, status <~ @get "repo" .status
        if err
            tavmant.radio.trigger "logs:new:err", err.message
        else
            @set "status", status

    defaults : ->
        repo    : git tavmant.path
        history : []
        status  : []

    initialize : ->
        @listen-to tavmant.radio, "git:status", _status
        @listen-to tavmant.radio, "git:history", _history
