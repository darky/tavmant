# **********************
#    MUST HAVE DEFINE
# **********************
React = require "react"
$ = React.DOM


# *************
#    EDITOR
# *************
Ace = require "react-ace"
require "brace/mode/handlebars"
require "brace/mode/css"
require "brace/mode/javascript"
require "brace/theme/monokai"


module.exports = class extends React.Component

    _save_content = ->
        tavmant.radio.trigger "files:save", @refs.ace.editor.get-value!

    render : ->
        $.div null,
            $.div class-name : "row",
                React.create-element Ace,
                    ref      : "ace"
                    mode     : switch @props.ext
                        | ".css" => "css"
                        | ".js" => "javascript"
                        | otherwise => "handlebars"
                    tab-size : 2
                    theme    : "monokai"
                    value    : @props.content
                    width : "100%"
            $.div class-name : "row pager",
                $.button do
                    on-click : _save_content.bind @
                    "Сохранить"
