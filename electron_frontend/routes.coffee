# **********************
#    MUST HAVE DEFINE
# **********************
Backbone = require "backbone"
React = require "react"
dom = require "react-dom"


# ****************
#    COMPONENTS
# ****************
Menu_Comp = require "./components/menu.coffee"
Styles_Comp = require "./components/styles.coffee"


# **************
#    ROUTING
# **************
class Router extends Backbone.Router

    routes :
        "" : require "./components/server.coffee"

router = new Router
router.on "route", (route)->
    dom.render do
        React.create-element @routes[route]
        document.query-selector "\#content"


# *******************
#    RENDER INITIAL
# *******************
dom.render do
    React.create-element Styles_Comp
    document.query-selector "\#styles"
dom.render do
    React.create-element Menu_Comp
    document.query-selector "\#menu"

Backbone.history.start!
