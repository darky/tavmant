# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
React = require "react"
$ = React.DOM
Backbone_Mixin = require "backbone-react-component"


module.exports = class extends React.Component

    _commit = ->
        textarea = document.query-selector "\#commit-message"
        if textarea.value isnt ""
            tavmant.radio.trigger "git:commit", textarea.value

    _pull = ->
        tavmant.radio.trigger "git:pull"

    _push = ->
        tavmant.radio.trigger "git:push"

    component-will-mount : ->
        Backbone_Mixin.on-model @, tavmant.stores.git_store
        tavmant.radio.trigger "git:status"
        tavmant.radio.trigger "git:history"
        tavmant.radio.trigger "git:diff"

    component-will-unmount : ->
        Backbone_Mixin.off @

    render : ->
        $.div null,
            $.div class-name : "row pager",
                $.div class-name : "col-lg-6 col-md-6 col-sm-6",
                    $.button class-name : "btn btn-default", on-click : _pull,
                        "Получить"
                $.div class-name : "col-lg-6 col-md-6 col-sm-6", on-click : _push,
                    $.button class-name : "btn btn-default",
                        "Отправить"
            $.div class-name : "row pager", style : marginTop : "80px",
                $.div class-name : "col-lg-6 col-md-6 col-sm-6 text-left",
                    _ ["modified", "not_added", "created", "deleted"]
                    .map (action)~>
                        _.map @state.model.status[action], (path)->
                            $.p do
                                key : _.unique-id "gitfile"
                                path.concat " "
                                $.span class-name :
                                    switch action
                                    | "not_added", "created" => "fa fa-plus"
                                    | "modified" => "fa fa-edit"
                                    | "deleted" => "fa fa-remove"
                    .flatten!value!
                $.form class-name : "col-lg-6 col-md-6 col-sm-6",
                    $.p null,
                        $.textarea cols : 30, required : true, id : "commit-message"
                    $.p null,
                        $.button class-name : "btn btn-default", on-click : _commit,
                            "Сохранить"
            $.div class-name : "row pager", style : marginTop : "80px",
                @state.model.diff.split "\n" .map (text)->
                    color = switch true
                    | text.starts-with "---" or text.starts-with "+++" => "bg-primary"
                    | text.starts-with "+" => "bg-success"
                    | text.starts-with "-" => "bg-danger"
                    $.pre do
                        class-name : "text-left small #{color}", key : _.unique-id "diff"
                        text
            $.div class-name : "row pager text-left", style : marginTop : "80px",
                if @state.model.waiting
                    $.span class-name : "bg-warning", that
                else
                    _.map @state.model.history, (item)->
                        $.p do
                            class-name : "text-left"
                            key : _.unique-id "gitlog"
                            "#{item.date} | #{item.author_name} | #{
                                item.message.replace 'HEAD -> master', 'ЛОКАЛЬНО' .replace 'origin/master', 'В ОБЛАКЕ'
                            }"
