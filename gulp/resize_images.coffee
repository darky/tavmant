# ***********************
#    NODEJS API DEFINE
# ***********************
path = require "path"


# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
async = require "async"
dir_helper = require "node-dir"


# **************
#    GRAPHICS
# **************
gm = require "gm"


module.exports =

    class Resize_Image

        # *************
        #    PRIVATE
        # *************
        _get_files = (cb)->
            err, files <- async.map tavmant.modules.resize_images.paths, (path, next)->
                err, result <- dir_helper.files "#{tavmant.path}/#{path}"
                next err, result
            cb err, _.flatten files

        _resize = (images, cb)->
            err <- async.for-each-of-series tavmant.modules.resize_images.resolutions, (px, size, next)->
                async.each images, (image, next)->
                    output = "
                        #{path.dirname image .replace 'assets', '@dev'}
                        #{path.sep}
                        #{path.basename image, '.jpg'}-#{size}.jpg
                    "
                    gm image .resize px .write output, next
                , next
            cb err


        # ************
        #    PUBLIC
        # ************
        start : (cb)->
            if global.tavmant.radio.request "gulp:current:resize:image"
                err <- _resize [that]
                return cb!
            err, files <- _get_files
            if err
                tavmant.radio.trigger "logs:new:err", err.message
                return
            err <- _resize _.filter files, (file)-> !!file.match /\.jpg$/
            if err
                tavmant.radio.trigger "logs:new:err", err.message
            else
                cb!
