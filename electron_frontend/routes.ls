# **********************
#    MUST HAVE DEFINE
# **********************
Backbone = require "backbone"
React = require "react"
dom = require "react-dom"


# ****************
#    COMPONENTS
# ****************
Menu_Comp = require "./components/menu.ls"
Styles_Comp = require "./components/styles.ls"
Notify_Comp = require "./components/notify.ls"


# **************
#    ROUTING
# **************
class Router extends Backbone.Router

    routes :
        ""                  : require "./components/server.ls"
        "git"               : require "./components/git.ls"
        "assets"            : require "./components/assets.ls"
        "pages"             : require "./components/pages.ls"
        "partials"          : require "./components/partials.ls"
        "layouts"           : require "./components/layouts.ls"
        "settings"          : require "./components/settings.ls"
        "category"          : require "./components/category.ls"
        "rawcategory"       : require "./components/rawcategory.ls"
        "subcategory"       : require "./components/subcategory.ls"
        "portfolio"         : require "./components/portfolio.ls"
        "about"             : require "./components/about.ls"
        "subcategory_items" : require "./components/subcategory_items.ls"

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
