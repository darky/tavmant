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


# ***********
#    PARSE
# ***********
csv_parse = require "csv-parse"
sjs = require "searchjs"
yaml = require "js-yaml"


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
            <- async.each-series parsed, (item, next)->
                builder <- _get_builder item, parsed
                <- builder.start!
                next!
            cb!

        _get_builder = (item, parsed, cb)->
            err, [list_wrapper_content, meta] <- async.parallel [
                (next)->
                    template_name = if item.2 then "subcategory-list-wrapper.html" else "list-wrapper.html"
                    fs.read-file "#{tavmant.path}/templates/categories/#{template_name}", encoding : "utf8", next
                (next)->
                    if _.is-error meta = yaml.safe-load item.4
                        next meta
                    else
                        next null, meta
            ]
            if err
                tavmant.radio.trigger "logs:new:err", err.message
                return
            get_html_fn = if item.2
                _.partial _get_html_subcategory_item, item
            else
                _.partial _get_html_subcategory, item, parsed
            html_content <- get_html_fn
            cb new HTML_Virtual_Build do
                content : new Buffer do
                    list_wrapper_content.replace "__content__", html_content
                    .replace "__title__", meta.title
                    .replace "__text__", item.5
                    .replace "__name__", item.0
                path : path.join tavmant.path, "pages/", "#{item.2}/#{item.0}.html"

        _get_favorites = (parsed, cb)->
            err, html_content <- fs.read-file "#{tavmant.path}/templates/categories/favorites.html" encoding : "utf8"
            if err then cb err else cb null, 
                _ parsed
                .filter (item)-> !!item.3
                .map (item)->
                    html_content.replace /__name__/g, item.0
                    .replace /__locale__/g, item.1
                    .replace /__link__/g, if item.2 then "/#{item.2}/#{item.0}" else item.0
                .join ""

        _get_categories_items_favorites = (cb)->
            err, favorites_template <- fs.read-file "#{tavmant.path}/templates/categories/subcategory-list-favorites.html",
                encoding : "utf8"
            if err
                tavmant.radio.trigger "logs:new:err", err.message
                return
            err, files_names <- async.waterfall [
                async.apply fs.readdir, "#{tavmant.path}/categories"
                (files_names, next)-> next null, _.filter files_names, (file_name)-> file_name isnt "tavmant-list.csv"
            ]
            if err
                tavmant.radio.trigger "logs:new:err", err.message
                return
            err, all_items <- async.waterfall [
                (next)->
                    err, file_contents <- async.map files_names, (item, cb)->
                        fs.read-file "#{tavmant.path}/categories/#{item}", encoding : "utf8", (err, content)-> cb err, content
                    if err then next err else next null, file_contents
                (file_contents, next)->
                    async.map file_contents, (item, cb)->
                        csv_parse item, delimiter : ";", (err, result)-> cb err, result
                    , next
            ]
            if err then cb err else cb null,
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
            err, list_content <- fs.read-file "#{tavmant.path}/templates/categories/list.html" encoding : "utf8"
            if err
                tavmant.radio.trigger "logs:new:err", err.message
                return
            cb do
                _ if item.6 then _transform_parsed parsed, item.6 else parsed
                .filter (subitem)-> if item.6 then true else subitem.2 is item.0
                .map (subitem)->
                    list_content.replace /__name__/g, subitem.0
                    .replace /__locale__/g, subitem.1
                    .replace /__link__/g, "/#{subitem.2}/#{subitem.0}"
                    .replace /__parent__/g, subitem.2
                .value!.join ""

        _get_html_subcategory_item = (item, cb)->
            err, subcategory_template <- fs.read-file "#{tavmant.path}/templates/categories/subcategory-list.html", encoding : "utf8"
            if err
                tavmant.radio.trigger "logs:new:err", err.message
                return
            err, parsed_subcategory <- (next)->
                if tavmant.stores.settings_store.attributes.category.portfolio
                    err, paths <- dir_helper.paths "#{tavmant.path}/assets/img/tavmant-categories/#{item.0}", true
                    if err
                        next err
                    else
                        next null,
                            _ paths
                            .filter (path_item)-> !!path_item.match(/\.jpg$/)
                            .map (path_item)-> path.basename path_item, ".jpg"
                            .sort-by (item)-> parse-int item
                            .map (name)-> [name, name]
                            .value!
                else
                    err, subcategory_content <- fs.read-file "#{tavmant.path}/categories/#{item.0}.csv", encoding : "utf8"
                    if err then next err else csv_parse subcategory_content, delimiter : ";", next
            if err
                tavmant.radio.trigger "logs:new:err", err.message
                return
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
                async.apply fs.read-file, "#{tavmant.path}/templates/categories/menu-category.html", encoding : "utf8"  
                async.apply fs.read-file, "#{tavmant.path}/templates/categories/menu-subcategory.html", encoding : "utf8"
            ]
            if err then cb err else cb null,
                _ parsed
                .group-by (item)-> if item.6 then item.0 else item.2
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
            err, result <- async.waterfall [
                async.apply fs.read-file, "#{tavmant.path}/categories/tavmant-list.csv", encoding : "utf8"
                (data, next)-> csv_parse data, delimiter : ";", next
            ]
            if err
                tavmant.radio.trigger "logs:new:err", err.message
                return
            cb _.map result, (item)-> _.to-plain-object item

        _transform_parsed = (data, meta)->
            action = meta.split "---" .0 .trim!
            query =
                _(meta.split "---" .1 .trim!)
                .thru yaml.safe-load .map-keys (val, key)->
                    if _.is-NaN parse-int key then key else key - 1
                .value!
            switch action
            | "filter" => sjs.match-array data, query


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
            if err
                tavmant.radio.trigger "logs:new:err", err.message
                return
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
