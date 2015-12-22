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
Notify_Comp = require "./components/notify.coffee"


# **************
#    ROUTING
# **************
class Router extends Backbone.Router

    routes :
        ""         : require "./components/server.coffee"
        "git"      : require "./components/git.coffee"
        "pages"    : require "./components/pages.coffee"
        "partials" : require "./components/partials.coffee"
        "layouts"  : require "./components/layouts.coffee"

router = new Router
router.on "route", ->
    route = location.hash.replace "#", ""
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
dom.render do
    React.create-element Notify_Comp
    document.query-selector "\#notify"

Backbone.history.start!
