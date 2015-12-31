# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
React = require "react"
$ = React.DOM
Backbone_Mixin = require "backbone-react-component"
tavmant = require "../../common.coffee" .call!


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
        tavmant.radio.trigger "git:refresh"

    component-will-unmount : ->
        Backbone_Mixin.off @

    render : ->
        changes = _ ["modified", "not_added", "created", "deleted", "conflicted"]
        .map (action)~>
            path <- _.map @state.model.status[action]
            $.p do
                key : _.unique-id "gitfile"
                path.concat " "
                $.span class-name :
                    switch action
                    | "not_added", "created" => "fa fa-plus"
                    | "modified" => "fa fa-edit"
                    | "deleted" => "fa fa-remove"
                    | "conflicted" => "fa fa-medkit"
        .flatten!value!

        $.div null,
            $.div class-name : "row pager",
                $.div class-name : "col-lg-6 col-md-6 col-sm-6",
                    $.button class-name : "btn btn-default", on-click : _pull,
                        "Получить ", $.span class-name : "fa fa-long-arrow-down"
                $.div class-name : "col-lg-6 col-md-6 col-sm-6", on-click : _push,
                    $.button class-name : "btn btn-default",
                        "Отправить ", $.span class-name : "fa fa-long-arrow-up"
            $.div class-name : "row pager", style : marginTop : "50px",
                $.div class-name : "col-lg-6 col-md-6 col-sm-6 text-left",
                    if changes.length then changes else "Изменения отсутствуют"
                $.form class-name : "col-lg-6 col-md-6 col-sm-6",
                    $.p null,
                        $.textarea do
                            cols : 30, required : true, id : "commit-message"
                            placeholder : "Кратко о том, что изменено"
                    $.p null,
                        $.span class-name : "btn btn-default", on-click : _commit,
                            "Сохранить изменения"
            if changes.length
                $.details class-name : "row pager",
                    $.summary null, "Подробно об изменениях"
                    @state.model.diff.split "\n" .map (text)->
                        color = switch true
                        | text.starts-with "---" or text.starts-with "+++" => "bg-primary"
                        | text.starts-with "+" => "bg-success"
                        | text.starts-with "-" => "bg-danger"
                        $.pre do
                            class-name : "text-left small #{color}", key : _.unique-id "diff"
                            text
            $.div class-name : "row pager text-left", style : marginTop : "50px",
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
