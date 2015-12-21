# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
Backbone = require "backbone"
git = require "simple-git"


module.exports = class extends Backbone.Model

    _repo : undefined

    _commit = (message)->
        files = _.reduce ["created", "deleted", "modified", "not_added"], (paths, action)~>
            paths.concat @get("status")[action]
        , []
        err <~ @_repo.commit message, files
        if err then tavmant.radio.trigger "logs:new:err", err.message
        tavmant.radio.trigger "git:status"
        tavmant.radio.trigger "git:history"
        tavmant.radio.trigger "git:diff"

    _diff = ->
        err, diff <~ @_repo.diff
        if err
            tavmant.radio.trigger "logs:new:err", err.message
        else
            @set "diff", diff

    _history = ->
        err, log <~ @_repo.log
        if err
            tavmant.radio.trigger "logs:new:err", err.message
        else
            @set do
                history : _.slice log.all, 0, 10
                waiting : false

    _pull = ->
        @set "waiting", "Получение..."
        err <- @_repo.pull
        if err then tavmant.radio.trigger "logs:new:err", err.message
        tavmant.radio.trigger "git:history"

    _push = ->
        @set "waiting", "Отправка..."
        err <- @_repo.push
        if err then tavmant.radio.trigger "logs:new:err", err.message
        tavmant.radio.trigger "git:history"

    _status = ->
        err, status <~ @_repo.status
        if err
            tavmant.radio.trigger "logs:new:err", err.message
        else
            @set "status", status

    defaults : ->
        diff    : ""
        history : []
        status  : []

    initialize : ->
        @listen-to tavmant.radio, "git:status", _status
        @listen-to tavmant.radio, "git:history", _history
        @listen-to tavmant.radio, "git:diff", _diff
        @listen-to tavmant.radio, "git:pull", _pull
        @listen-to tavmant.radio, "git:push", _push
        @listen-to tavmant.radio, "git:commit", _commit

        @_repo = git tavmant.path
