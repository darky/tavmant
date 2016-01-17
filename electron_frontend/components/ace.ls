# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
React = require "react"
$ = React.DOM
tavmant = require "../../common.ls" .call!


# *************
#    EDITOR
# *************
Ace = require "react-ace"
require "brace/mode/handlebars"
require "brace/mode/css"
require "brace/mode/javascript"
require "brace/theme/monokai"


module.exports = class extends React.Component

    _save_content = _.debounce (val)->
        tavmant.radio.trigger "files:save", val
    , 300

    render : ->
        $.div null,
            $.div class-name : "row",
                React.create-element Ace,
                    mode     : switch @props.ext
                        | ".css" => "css"
                        | ".js" => "javascript"
                        | otherwise => "handlebars"
                    on-change : _save_content
                    tab-size  : 2
                    theme     : "monokai"
                    value     : @props.content
                    width     : "100%"
