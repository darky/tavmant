# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
co = require "co"
dir_helper = require "node-dir"
thunkify = require "thunkify"


module.exports =

    class Gallery_Build

        # **********
        #    INIT
        # **********
        (options)->
            {@template} = options


        # *************
        #    PRIVATE
        # *************
        _generate_html = (self)-> co ->*
            image_paths = yield thunkify(
                dir_helper.paths
            )(
                "./assets/img/portfolio"
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

            ->
                _.map _.shuffle(image_names), (name)->
                    self.template.replace "__image__", name
                .join ""


        # ************
        #    PUBLIC
        # ************
        start : -> co ~>*
            [
                fn   : yield _generate_html @
                name : "gallery"
            ]
