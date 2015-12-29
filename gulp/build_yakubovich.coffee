# ***********************
#    NODEJS API DEFINE
# ***********************
fs = require "fs"


# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
tavmant = require "../common.coffee" .call!


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
                template : """
                  {{{заголовок1 "!!!текст!!!"}}}
                """
            ,
                name : "заголовок2"
                fn : (text)-> "<h2>#{text}</h2>"
                template : """
                  {{{заголовок2 "!!!текст!!!"}}}
                """
            ,
                name : "заголовок3"
                fn : (text)-> "<h3>#{text}</h3>"
                template : """
                  {{{заголовок3 "!!!текст!!!"}}}
                """
            ,
                name : "заголовок4"
                fn : (text)-> "<h4>#{text}</h4>"
                template : """
                  {{{заголовок4 "!!!текст!!!"}}}
                """
            ,
                name : "заголовок5"
                fn : (text)-> "<h5>#{text}</h5>"
                template : """
                  {{{заголовок5 "!!!текст!!!"}}}
                """
            ,
                name : "заголовок6"
                fn : (text)-> "<h6>#{text}</h6>"
                template : """
                  {{{заголовок6 "!!!текст!!!"}}}
                """
            ,
                name : "параграф"
                fn : (opts)-> "<p>#{opts.fn!}</p>"
                template : """
                  {{\#параграф}}
                    !!!содержимое!!!
                  {{/параграф}}
                """
            ,
                name : "картинка"
                fn : (link)-> "<img src=\"#{link}\">"
                template : """
                  {{{картинка "!!!ссылка!!!"}}}
                """
            ,
                name : "ссылка"
                fn : (text, link)-> "<a href=\"#{link}\">#{text}</a>"
                template : """
                  {{{ссылка "!!!текст!!!" "!!!ссылка!!!"}}}
                """
            ,
                name : "жирным"
                fn : (text)-> "<b>#{text}</b>"
                template : """
                  {{{жирным "!!!текст!!!"}}}
                """
            ,
                name : "курсив"
                fn : (text)-> "<i>#{text}</i>"
                template : """
                  {{{курсив "!!!текст!!!"}}}
                """
            ,
                name : "список"
                fn : (opts)-> "<ul>#{opts.fn!}</ul>"
                template : """
                  {{\#список}}
                    !!!элементы списка!!!
                  {{/список}}
                """
            ,
                name : "элемент_списка"
                fn : (text)-> "<li>#{text}</li>"
                template : """
                  {{{элемент_списка "!!!текст!!!"}}}
                """
            ,
                name : "перенос"
                fn : -> "<br>"
                template : """
                  {{{перенос}}}
                """
            ]


        # ************
        #    PUBLIC
        # ************
        get_helpers : (cb)->
            global.require.cache[fs.realpath-sync "#{tavmant.path}/api/yakubovich.js"] = null
            cb null, _extend _get_built_in!, global.require "#{tavmant.path}/api/yakubovich.js"
