# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
React = require "react"
$ = React.DOM
Backbone_Mixin = require "backbone-react-component"
tavmant = require "../../common.ls" .call!


Cache = require "./cache.ls"
Version = require "./version.ls"


module.exports = class extends React.Component

    _save = ->
        result = {}
        if @refs.category.checked
            result.category = {}
        if @refs.category_portfolio.checked
            result.category ?= {}
            result.category.portfolio = true
        if @refs.rezak.checked
            result.resize_images = {}
        if @refs.rezak_paths.value
            result.resize_images ?= {}
            result.resize_images.paths =
                _.compact that.split "\n"
                .map (path)-> path.trim!
        if @refs.rezak_res.value
            result.resize_images ?= {}
            result.resize_images.resolutions = {}
            _.compact that.split "\n"
            .map (res)-> res.trim!
            .for-each (res)->
                [postfix, px] = res.split " "
                result.resize_images.resolutions[postfix] = parse-int px
        if @refs.yakubovich.checked
            result.yakubovich = {}
        tavmant.radio.trigger "settings:save", result

    component-will-mount : ->
        Backbone_Mixin.on-model @, tavmant.stores.settings_store
        tavmant.radio.trigger "settings:read"

    component-will-unmount : ->
        Backbone_Mixin.off @

    render : ->
        $.form null,
            $.h4 null, "Настройки модулей"
            $.div class-name : "checkbox",
                $.label class-name : "checkbox-inline",
                    $.input type : "checkbox", default-checked : @state.model.category, ref : "category"
                    "Категоризатор"
                $.label class-name : "checkbox-inline",
                    $.input type : "checkbox", default-checked : @state.model.category?.portfolio, ref : "category_portfolio"
                    "Портфолио-режим"
            $.div class-name : "form-group",
                $.label class-name : "checkbox-inline",
                    $.input type : "checkbox", default-checked : @state.model.resize_images, ref : "rezak"
                    "Резак изображений"
                $.div class-name : "form-inline"
                    "Список путей "
                    $.textarea cols : 50, rows : 5, ref : "rezak_paths", default-value : @state.model.resize_images?.paths.join "\n"
                $.div class-name : "form-inline"
                    "Разрешения "
                    $.textarea cols : 50, rows : 5, ref : "rezak_res", default-value :
                        _.reduce @state.model.resize_images?.resolutions, (accum, val, key)->
                            "#{accum}\n#{key} #{val}"
                        , ""
                        .trim!
            $.div class-name : "checkbox",
                $.label class-name : "checkbox-inline",
                    $.input type : "checkbox", default-checked : @state.model.yakubovich, ref : "yakubovich"
                    "Якубович"
            $.div class-name : "form-group",
                $.span do
                    class-name : "btn btn-default"
                    on-click : _save.bind @
                    "Сохранить"
            $.h4 null, "Версия"
            React.create-element Version
            $.h4 null, "Очистка кеша"
            React.create-element Cache
