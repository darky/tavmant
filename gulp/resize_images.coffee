# ***********************
#    NODEJS API DEFINE
# ***********************
exec = require "child_process" .exec
path = require "path"


# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
async = require "async"
dir_helper = require "node-dir"
tavmant = require "../common.coffee" .call!


module.exports =

    class Resize_Image

        # *************
        #    PRIVATE
        # *************
        _get_files = (cb)->
            err, files <- async.map tavmant.stores.settings_store.attributes.resize_images.paths, (path, next)->
                err, result <- dir_helper.files "#{tavmant.path}/#{path}"
                next err, result
            cb err, _.flatten files

        _resize = (images, cb)->
            err <- async.for-each-of-series tavmant.stores.settings_store.attributes.resize_images.resolutions, (px, size, next)->
                async.each images, (image, next)->
                    output = "
                        #{path.dirname image .replace 'assets', '@dev'}
                        #{path.sep}
                        #{path.basename image, '.jpg'}-#{size}.jpg
                    "
                    exec "vipsthumbnail --size #{px} -o \"#{output}\" \"#{image}\"", next
                , next
            cb err


        # ************
        #    PUBLIC
        # ************
        start : (cb)->
            if tavmant.radio.request "gulp:current:resize:image"
                err <- _resize [that]
                cb err
            else
                err, files <- _get_files
                if err then cb err; return
                err <- _resize _.filter files, (file)-> !!file.match /\.jpg$/
                cb err
