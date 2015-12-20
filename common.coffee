# *****************
#    NODEJS API
# *****************
fs = require "fs"


# **********************
#    MUST HAVE DEFINE
# **********************
yaml = require "js-yaml"


# ********************
#    GLOBAL DEFINE
# ********************
process.env.PATH = process.env.PATH.concat ":/usr/local/bin"
global.tavmant = {}
global.tavmant.radio = {}
global.tavmant.path = __dirname
modules = fs.read-file-sync "#{tavmant.path}/settings/modules.yaml", encoding : "utf8"
global.tavmant.modules = yaml.safe-load modules
