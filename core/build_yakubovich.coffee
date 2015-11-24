module.exports =

    class Yakubovich

        # ************
        #    PUBLIC
        # ************
        get_helpers : (cb)->
            cb require "#{process.cwd!}/api/yakubovich.js"
