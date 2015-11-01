# ***********************
#    NODEJS API DEFINE
# ***********************
fs = require "fs"


# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
co = require "co"
dir_helper = require "node-dir"
promisify = require "promisify-node"


module.exports =

    class Gallery_Build

        # *************
        #    PRIVATE
        # *************
        _generate_html = -> co ->*
            try
                image_paths = yield promisify(
                    dir_helper.paths
                )(
                    "./assets/img/tavmant-gallery"
                    true
                )

                image_names = _.map image_paths, (path)->
                    path.match(
                        //
                            / (
                                \w+ \.(jpg|jpeg|png|gif) 
                            )$
                        //
                    )[1]

                template = yield promisify(
                    fs.read-file
                )(
                    "./templates/gallery.html"
                    encoding : "utf8"
                )

            ->
                _.map _.shuffle(image_names or []), (name)->
                    template.replace "__image__", name
                .join ""
        .catch (e)-> console.error e


        # ************
        #    PUBLIC
        # ************
        start : -> co ~>*
            [
                fn   : yield _generate_html @
                name : "gallery"
            ]
        .catch (e)-> console.error e
