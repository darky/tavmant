module.exports =

    class Yakubovich

        # ************
        #    PUBLIC
        # ************
        get_helpers : (cb)->
            require.cache[require.resolve "#{process.cwd!}/api/yakubovich.js"] = null
            cb require "#{process.cwd!}/api/yakubovich.js"
