# *****************
#    NODE JS API
# *****************
fs = require "fs"
path = require "path"


# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
async = require "async"
Backbone = require "backbone"
mkdirp = require "mkdirp"
to_buffer = require "blob-to-buffer"
tavmant = require "../../common.coffee" .call!


module.exports = class extends Backbone.Model

    _add_picture = (blobs, path)->
        err <~ mkdirp "#{tavmant.path}/assets/#{path}/"
        if err
            tavmant.radio.trigger "logs:new:err", (err.message or err)
            return
        err <~ async.each blobs, (blob, next)->
            err, buffer <- to_buffer blob
            if err then next err; return
            err <- fs.write-file "#{tavmant.path}/assets/#{path}/#{blob.name.to-lower-case!}", buffer
            next err
        if err
            tavmant.radio.trigger "logs:new:err", (err.message or err)
        else
            tavmant.radio.trigger "files:list"

    initialize : ->
        @listen-to tavmant.radio, "assets:add:picture", _add_picture
