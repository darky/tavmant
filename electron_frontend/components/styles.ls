# **********************
#    MUST HAVE DEFINE
# **********************
React = require "react"
$ = React.DOM


module.exports = class extends React.Component

    render : ->
        $.div null,
            $.link rel : "stylesheet", href : "https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css"
            $.link rel : "stylesheet", href : "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
            $.link rel : "stylesheet", href : "https://raw.githubusercontent.com/tabalinas/jsgrid/master/dist/jsgrid.css"
            $.link rel : "stylesheet", href : "https://raw.githubusercontent.com/tabalinas/jsgrid/master/dist/jsgrid-theme.css"
