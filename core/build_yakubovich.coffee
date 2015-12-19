# ***********************
#    NODEJS API DEFINE
# ***********************
fs = require "fs"


# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"

module.exports =

    class Yakubovich

        # *************
        #    PRIVATE
        # *************
        _extend = (dest, source)->
            _.each source, (source_item)->
                finded = _.find dest, (dest_item)-> dest_item.name is source_item.name
                if finded then _.remove dest, finded
                dest.push source_item
            dest

        _get_built_in = ->
            [
                name : "заголовок1"
                fn : (text)-> "<h1>#{text}</h1>"
            ,
                name : "заголовок2"
                fn : (text)-> "<h2>#{text}</h2>"
            ,
                name : "заголовок3"
                fn : (text)-> "<h3>#{text}</h3>"
            ,
                name : "заголовок4"
                fn : (text)-> "<h4>#{text}</h4>"
            ,
                name : "заголовок5"
                fn : (text)-> "<h5>#{text}</h5>"
            ,
                name : "заголовок6"
                fn : (text)-> "<h6>#{text}</h6>"
            ,
                name : "параграф"
                fn : (opts)-> "<p>#{opts.fn!}</p>"
            ,
                name : "картинка"
                fn : (link)-> "<img src=\"#{link}\">"
            ,
                name : "ссылка"
                fn : (text, link)-> "<a href=\"#{link}\">#{text}</a>"
            ,
                name : "жирным"
                fn : (text)-> "<b>#{text}</b>"
            ,
                name : "курсив"
                fn : (text)-> "<i>#{text}</i>"
            ,
                name : "список"
                fn : (opts)-> "<ul>#{opts.fn!}</ul>"
            ,
                name : "элемент_списка"
                fn : (text)-> "<li>#{text}</li>"
            ,
                name : "перенос"
                fn : -> "<br>"
            ]


        # ************
        #    PUBLIC
        # ************
        get_helpers : (cb)->
            require.cache ?= {}
            require.cache[fs.realpath-sync "#{tavmant.path}/api/yakubovich.js"] = null
            cb _extend _get_built_in!, require "#{tavmant.path}/api/yakubovich.js"
