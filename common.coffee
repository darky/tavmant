# *****************
#    NODEJS API
# *****************
fs = require "fs"


# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
backbone = require "backbone"
radio = require "backbone.radio"
yaml = require "js-yaml"


# ********************
#    GLOBAL DEFINE
# ********************
global.tavmant = {}
global.tavmant.radio = _.extend {}, radio.Requests, backbone.Events
global.tavmant.path = __dirname
modules = fs.read-file-sync "#{tavmant.path}/settings/modules.yaml", encoding : "utf8"
global.tavmant.modules = yaml.safe-load modules
