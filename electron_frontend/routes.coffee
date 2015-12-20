# **********************
#    MUST HAVE DEFINE
# **********************
Backbone = require "backbone"
React = require "react"
dom = require "react-dom"


# *************
#    STORES
# *************


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
        "" : 123

router = new Router
router.on "route", ->

dom.render do
    React.create-element Menu_Comp
    document.query-selector "\#menu"
dom.render do
    React.create-element Styles_Comp
    document.query-selector "\#styles"

Backbone.history.start!
