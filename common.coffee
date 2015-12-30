# *****************
#    NODEJS API
# *****************
fs = require "fs"


# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
Backbone = require "backbone"


# ********************
#    TAVMANT DEFINE
# ********************
tavmant = {}
tavmant.radio = _.extend {}, Backbone.Events
tavmant.path = __dirname

modules_content = fs.read-file-sync "#{tavmant.path}/settings/modules.json", encoding : "utf8"
modules = JSON.parse modules_content

module.exports = -> tavmant


# ************
#    STORES
# ************
Server_Store = require "./electron_frontend/stores/server.coffee"
Logs_Store = require "./electron_frontend/stores/logs.coffee"
Git_Store = require "./electron_frontend/stores/git.coffee"
Files_Store = require "./electron_frontend/stores/files.coffee"
Settings_Store = require "./electron_frontend/stores/settings.coffee"
Category_Store = require "./electron_frontend/stores/category.coffee"
Portfolio_Store = require "./electron_frontend/stores/portfolio.coffee"
Assets_Store = require "./electron_frontend/stores/assets.coffee"
Yakubovich_Store = require "./electron_frontend/stores/yakubovich.coffee"


tavmant.stores = {}
tavmant.stores.server_store = new Server_Store
tavmant.stores.logs_store = new Logs_Store
tavmant.stores.git_store = new Git_Store
tavmant.stores.files_store = new Files_Store
tavmant.stores.settings_store = new Settings_Store modules
tavmant.stores.category_store = new Category_Store
tavmant.stores.portfolio_store = new Portfolio_Store
tavmant.stores.assets_store = new Assets_Store
tavmant.stores.yakubovich_store = new Yakubovich_Store
