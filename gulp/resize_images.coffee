# ***********************
#    NODEJS API DEFINE
# ***********************
crypto = require "crypto"
exec = require "child_process" .exec
fs = require "fs"
path = require "path"


# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
async = require "async"
dir_helper = require "node-dir"
gulp = require "gulp"
mkdirp = require "mkdirp"
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
                    err, data <- fs.read-file image
                    if err then next err; return
                    hash = crypto.create-hash "sha1" .update data .digest "hex"
                    cache_path = "#{tavmant.path}/tavmant-cache/assets/img/tavmant-categories/#{hash}-#{size}"
                    err <- fs.access cache_path
                    new_name = "#{path.basename image, '.jpg'}-#{size}.jpg"
                    output = "#{path.dirname image .replace 'assets', '@dev'}#{path.sep}#{new_name}"
                    if err
                        err <- mkdirp "#{path.dirname image .replace 'assets', '@dev'}"
                        if err then next err; return
                        err <- exec "vipsthumbnail --size #{px} -o \"#{output}\" \"#{image}\""
                        if err then next err; return
                        err <- mkdirp cache_path
                        if err then next err; return
                        gulp.src output
                        .pipe gulp.dest cache_path
                        .on "error", next
                        .on "finish", next
                    else
                        gulp.src "#{cache_path}/#{new_name}"
                        .pipe gulp.dest "#{path.dirname image .replace 'assets', '@dev'}"
                        .on "error", next
                        .on "finish", next
                , next
            cb err


        # ************
        #    PUBLIC
        # ************
        start : (cb)->
            err, files <- _get_files
            if err then cb err; return
            err <- _resize _.filter files, (file)-> !!file.match /\.jpg$/
            cb err
