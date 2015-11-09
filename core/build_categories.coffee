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


# *********
#    CSV
# *********
csv_parse = require "csv-parse"


# *******************
#    CORE CLASSES
# *******************
HTML_Virtual_Build = require "./build_html_virtual.coffee"


module.exports =

    class Categories_Build

        # *************
        #    PRIVATE
        # *************
        _generate = (parsed, cb)->
            err <- async.each parsed, (item, next)->
                builder <- _get_builder item, parsed
                <- builder.start!
                next!
            if err then throw err else cb!

        _get_builder = (item, parsed, cb)->
            err, list_wrapper_content <- fs.read-file "#{process.cwd()}/templates/categories/list-wrapper.html" encoding : "utf8"
            {title} = JSON.parse item.4
            get_html_fn = if item.2
                _.partial _get_html_subcategory_item, item
            else
                _.partial _get_html_subcategory, item, parsed
            html_content <- get_html_fn
            cb new HTML_Virtual_Build do
                content : new Buffer do
                    list_wrapper_content.replace "__content__", html_content
                    .replace "__title__", title
                    .replace "__text__", item.5
                    .replace "__name__", item.0
                path : path.join process.env.PWD, "pages/", "#{item.2}/#{item.0}.html"

        _get_favorites = (parsed, cb)->
            err, html_content <- fs.read-file "#{process.cwd()}/templates/categories/favorites.html" encoding : "utf8"
            cb err, 
                _ parsed
                .filter (item)-> !!item.3
                .map (item)->
                    html_content.replace /__name__/g, item.0
                    .replace /__locale__/g, item.1
                    .replace /__link__/g, if item.2 then "/#{item.2}/#{item.0}" else item.0
                .join ""

        _get_categories_items_favorites = (cb)->
            err, files_names <- fs.readdir "#{process.cwd()}/categories"
            files_names = _.filter files_names, (file_name)-> file_name isnt "tavmant-list.csv"

            err, file_contents <- async.map files_names, (item, cb)->
                fs.read-file "#{process.cwd()}/categories/#{item}",
                    encoding : "utf8"
                    (err, content)-> cb null, content

            err, all_items <- async.map file_contents, (item, cb)->
                csv_parse item, delimiter : ";", (err, result)-> cb null, result

            err, favorites_template <- fs.read-file "#{process.cwd()}/templates/categories/subcategory-list-favorites.html",
                encoding : "utf8"

            cb err,
                _ all_items
                .map (items, i)->
                    _ items
                    .filter (subitem)-> !!subitem.3
                    .map (subitem)->
                        favorites_template.replace /__locale__/g, subitem.1
                        .replace /__link__/g, "#{files_names[i].replace /\.csv/, ""}/#{subitem.0}"
                        .replace /__price__/g, subitem.2
                        .replace /__4__/g, subitem.4
                        .replace /__5__/g, subitem.5
                        .replace /__6__/g, subitem.6
                    .value!.join ""
                .value!.join ""

        _get_html_subcategory = (item, parsed, cb)->
            err, list_content <- fs.read-file "#{process.cwd()}/templates/categories/list.html" encoding : "utf8"

            cb do
                _ parsed
                .filter (subitem)-> subitem.2 is item.0
                .map (subitem)->
                    list_content.replace /__name__/g, subitem.0
                    .replace /__locale__/g, subitem.1
                    .replace /__link__/g, "/#{subitem.2}/#{subitem.0}"
                .value!.join ""

        _get_html_subcategory_item = (item, cb)->
            err, [subcategory_content, subcategory_template] <- async.parallel [
                async.apply fs.read-file, "#{process.cwd()}/categories/#{item.0}.csv", encoding : "utf8"
                async.apply fs.read-file, "#{process.cwd()}/templates/categories/subcategory-list.html", encoding : "utf8"
            ]

            err, parsed_subcategory <- csv_parse subcategory_content, delimiter : ";"

            cb do
                _ parsed_subcategory
                .map (subitem)->
                    subcategory_template.replace /__locale__/g, subitem.1
                    .replace /__link__/g, "#{item.0}/#{subitem.0}"
                    .replace /__price__/g, subitem.2
                    .replace /__4__/g, _.identity -> subitem.4 or ""
                    .replace /__5__/g, _.identity -> subitem.5 or ""
                    .replace /__6__/g, _.identity -> subitem.6 or ""
                .value!.join ""

        _get_menu = (parsed, cb)->
            err, [html_category, html_subcategory] <- async.parallel [
                async.apply fs.read-file, "#{process.cwd()}/templates/categories/menu-category.html", encoding : "utf8"  
                async.apply fs.read-file, "#{process.cwd()}/templates/categories/menu-subcategory.html", encoding : "utf8"
            ]

            cb err,
                _ parsed
                .group-by (item)-> item.2
                .map-values (items, name)->
                    if name is "" then return null
                    html_category.replace /__content__/g,
                        _.map items, (item)->
                            html_subcategory.replace /__name__/g, item.0
                            .replace /__locale__/g, item.1
                            .replace /__link__/g, "/#{name}/#{item.0}"
                        .join ""
                    .replace /__name__/g, name
                    .replace /__locale__/g,
                        _.find parsed, (item)-> item.0 is name
                        .1
                .values!.compact!.value!.join ""

        _get_parsed = (cb)->
            err, data <- fs.read-file "#{process.cwd()}/categories/tavmant-list.csv", encoding : "utf8"
            content = if err then "" else data
            err, result <- csv_parse content, delimiter : ";"
            cb result


        # ************
        #    PUBLIC
        # ************
        get_helpers : (cb)->
            parsed <- _get_parsed!

            err, result <- async.parallel [
                async.apply _get_menu, parsed
                async.apply _get_favorites, parsed
                async.apply _get_categories_items_favorites
            ]
            if err then throw err
            cb [
                fn   : result.0
                name : "categories_menu"
            ,
                fn   : result.1
                name : "categories_favorites"
            ,
                fn   : result.2
                name : "categories_items_favorites"
            ]

        start : (cb)->
            parsed <- _get_parsed!
            <- _generate parsed
            cb!
