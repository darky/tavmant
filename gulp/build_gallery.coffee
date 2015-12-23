# ***********************
#    NODEJS API DEFINE
# ***********************
fs = require "fs"


# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
dir_helper = require "node-dir"


module.exports =

    class Gallery_Build

        # *************
        #    PRIVATE
        # *************
        _generate_html = (cb)->
            err, [image_paths, template] <- async.parallel [
                async.apply dir_helper.paths, "./assets/img/tavmant-gallery", true
                async.apply fs.read-file, "./templates/gallery.html", encoding : "utf8"
            ]
            if err
                tavmant.radio.trigger "logs:new:err", err.message or err
                return
            image_names = _.map image_paths, (path)->
                path.match(
                    //
                        / (
                            \w+ \.(jpg|jpeg|png|gif) 
                        )$
                    //
                ).1
            cb ->
                _.map _.shuffle(image_names), (name)->
                    template.replace "__image__", name
                .join ""


        # ************
        #    PUBLIC
        # ************
        get_helpers : (cb)->
            fn <- _generate_html!
            cb [
                fn   : fn
                name : "gallery"
            ]
