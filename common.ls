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
global.tavmant ?= {}
tavmant = {}
tavmant.radio = _.extend {}, Backbone.Events
tavmant.path = __dirname

modules_content = fs.read-file-sync "#{tavmant.path}/settings/modules.json", encoding : "utf8"
modules = JSON.parse modules_content

module.exports = -> tavmant


# ************
#    STORES
# ************
Server_Store = require "./electron_frontend/stores/server.ls"
Logs_Store = require "./electron_frontend/stores/logs.ls"
Git_Store = require "./electron_frontend/stores/git.ls"
Files_Store = require "./electron_frontend/stores/files.ls"
Settings_Store = require "./electron_frontend/stores/settings.ls"
Category_Store = require "./electron_frontend/stores/category.ls"
Portfolio_Store = require "./electron_frontend/stores/portfolio.ls"
Assets_Store = require "./electron_frontend/stores/assets.ls"
Yakubovich_Store = require "./electron_frontend/stores/yakubovich.ls"
Cache_Store = require "./electron_frontend/stores/cache.ls"
Database_Store = require "./electron_frontend/stores/database.ls"


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
tavmant.stores.cache_store = new Cache_Store
tavmant.stores.database_store = new Database_Store
