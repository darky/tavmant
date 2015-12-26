# **********************
#    MUST HAVE DEFINE
# **********************
Backbone = require "backbone"
gulp = require "gulp"
tavmant = require "../../common.coffee" .call!


module.exports = class extends Backbone.Model

    _dev_start = ->
        gulp.start "сборка для разработчика", (e)->
            if e
                tavmant.radio.trigger "server:errored"
            else
                tavmant.radio.trigger "server:started:dev"
        @set do
            errored : false
            waiting : true

    _errored = ->
        unless @get "running"
            @set "errored", true

    _prod_start = ->
        gulp.start "боевая сборка", (e)->
            if e
                tavmant.radio.trigger "server:errored"
            else
                tavmant.radio.trigger "server:started:dev"
        @set do
            errored : false
            waiting : true

    _dev_ready = ->
        @set running : "dev", waiting : false

    _prod_ready = ->
        @set running : "prod", waiting : false

    initialize : ->
        @listen-to tavmant.radio, "server:start:dev", _dev_start
        @listen-to tavmant.radio, "server:start:prod", _prod_start
        @listen-to tavmant.radio, "server:started:dev", _dev_ready
        @listen-to tavmant.radio, "server:started:prod", _prod_ready
        @listen-to tavmant.radio, "server:errored", _errored
