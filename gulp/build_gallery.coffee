# ***********************
#    NODEJS API DEFINE
# ***********************
fs = require "fs"
path = require "path"


# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
async = require "async"
dir_helper = require "node-dir"


module.exports =

    class Gallery_Build

        # *************
        #    PRIVATE
        # *************
        _generate_html = (cb)->
            err, [image_paths, template] <- async.parallel [
                async.apply dir_helper.files, "./assets/img/tavmant-gallery"
                async.apply fs.read-file, "./templates/gallery.html", encoding : "utf8"
            ]
            if err then cb err; return
            image_names = _.compact _.map image_paths, (file_path)->
                if file_path.match /\.jpg$/
                    path.basename file_path, ".jpg"
                else
                    null
            cb null, ->
                _.map _.shuffle(image_names), (name)->
                    template.replace "__image__", name
                .join ""


        # ************
        #    PUBLIC
        # ************
        get_helpers : (cb)->
            err, fn <- _generate_html!
            cb err, [
                fn   : fn
                name : "gallery"
            ]
