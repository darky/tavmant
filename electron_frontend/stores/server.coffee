# **********************
#    MUST HAVE DEFINE
# **********************
Backbone = require "backbone"
gulp = require "gulp"


module.exports = class extends Backbone.Model

    _dev_start = ->
        gulp.start "сборка для разработчика", -> tavmant.radio.trigger "server:started:dev"
        @set "waiting", true

    _prod_start = ->
        gulp.start "боевая сборка", -> tavmant.radio.trigger "server:started:prod"
        @set "waiting", true

    _dev_ready = ->
        @set server : "dev", waiting : false

    _prod_ready = ->
        @set server : "prod", waiting : false

    initialize : ->
        @listen-to tavmant.radio, "server:start:dev", _dev_start
        @listen-to tavmant.radio, "server:start:prod", _prod_start
        @listen-to tavmant.radio, "server:started:dev", _dev_ready
        @listen-to tavmant.radio, "server:started:prod", _prod_ready
