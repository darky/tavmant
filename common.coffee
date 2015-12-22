# *****************
#    NODEJS API
# *****************
fs = require "fs"


# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
Backbone = require "backbone"
Radio = require "backbone.radio"
yaml = require "js-yaml"


# ************
#    STORES
# ************
Server_Store = require "./electron_frontend/stores/server.coffee"
Logs_Store = require "./electron_frontend/stores/logs.coffee"
Git_Store = require "./electron_frontend/stores/git.coffee"
Files_Store = require "./electron_frontend/stores/files.coffee"


# ********************
#    GLOBAL DEFINE
# ********************
global.tavmant = {}
global.tavmant.radio = _.extend {}, Radio.Requests, Backbone.Events
global.tavmant.path = __dirname

modules = fs.read-file-sync "#{tavmant.path}/settings/modules.yaml", encoding : "utf8"
global.tavmant.modules = yaml.safe-load modules

global.tavmant.stores = {}
global.tavmant.stores.server_store = new Server_Store
global.tavmant.stores.logs_store = new Logs_Store
global.tavmant.stores.git_store = new Git_Store
global.tavmant.stores.files_store = new Files_Store
