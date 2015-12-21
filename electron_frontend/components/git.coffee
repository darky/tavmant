# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
React = require "react"
$ = React.DOM
Backbone_Mixin = require "backbone-react-component"


module.exports = class extends React.Component

    _render_files = (status)->
        _ ["modified", "not_added", "created", "deleted"]
        .map (action)->
            _.map status[action], (path)->
                $.p do
                    key : _.unique-id "gitfile"
                    path.concat " "
                    $.span class-name :
                        switch action
                        | "not_added", "created" => "fa fa-plus"
                        | "modified" => "fa fa-edit"
                        | "deleted" => "fa fa-remove"
        .flatten!value!

    component-will-mount : ->
        Backbone_Mixin.on-model @, tavmant.stores.git_store
        tavmant.radio.trigger "git:status"
        tavmant.radio.trigger "git:history"

    component-will-unmount : ->
        Backbone_Mixin.off @

    render : ->
        $.div null,
            $.div class-name : "row pager",
                $.div class-name : "col-lg-6 col-md-6 col-sm-6",
                    $.button class-name : "btn btn-default",
                        "Получить"
                $.div class-name : "col-lg-6 col-md-6 col-sm-6",
                    $.button class-name : "btn btn-default",
                        "Отправить"
            $.div class-name : "row pager", style : marginTop : "80px",
                $.div class-name : "col-lg-6 col-md-6 col-sm-6 text-left",
                    _render_files @state.model.status
                $.div class-name : "col-lg-6 col-md-6 col-sm-6",
                    $.p null,
                        $.textarea cols : 30
                    $.p null,
                        $.button class-name : "btn btn-default",
                            "Сохранить"
            $.div class-name : "row pager text-left", style : marginTop : "80px",
                _.map @state.model.history, (item)->
                    $.p do
                        class-name : "text-left"
                        key : _.unique-id "gitlog"
                        "#{item.date} | #{item.author_name} | #{item.message}"
