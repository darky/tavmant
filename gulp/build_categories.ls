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
mkdirp = require "mkdirp"
tavmant = require "../common.ls" .call!


# ***********
#    PARSE
# ***********
sjs = require "searchjs"
yaml = require "js-yaml"


# *******************
#    CORE CLASSES
# *******************
HTML_Virtual_Build = require "./build_html_virtual.ls"


module.exports =

    class Categories_Build

        # *************
        #    PRIVATE
        # *************
        _generate = (parsed, cb)->
            err <- async.each parsed, (item, next)->
                err, builder <- _get_builder item, parsed
                if err
                    next err
                else
                    err <- builder.start!
                    next err
            cb err

        _get_builder = (item, parsed, cb)->
            err, [list_wrapper_content, meta] <- async.parallel [
                (next)->
                    template_name = if item.parent then "subcategory-list-wrapper.html" else "list-wrapper.html"
                    fs.read-file "#{tavmant.path}/templates/categories/#{template_name}", encoding : "utf8", next
                (next)->
                    if _.is-error meta = yaml.safe-load item.meta
                        next meta
                    else
                        next null, meta
            ]
            if err then cb err; return
            get_html_fn = if item.parent
                _.partial _get_html_subcategory_item, item
            else
                _.partial _get_html_subcategory, item, parsed
            err, html_content <- get_html_fn
            if err
                cb err
            else
                cb null, new HTML_Virtual_Build do
                    content : new Buffer do
                        list_wrapper_content.replace "__content__", html_content
                        .replace "__title__", meta?.title
                        .replace "__text__", item.content
                        .replace "__name__", item.id
                    path : path.join tavmant.path, "pages/", "#{item.parent or ""}/#{item.id}.html"

        _get_favorites = (parsed, cb)->
            err, html_content <- fs.read-file "#{tavmant.path}/templates/categories/favorites.html" encoding : "utf8"
            if err then cb err else cb null, ->
                _ parsed
                .filter (item)-> !!item.favorite
                .map (item)->
                    html_content.replace /__name__/g, item.id
                    .replace /__locale__/g, item.locale
                    .replace /__link__/g, if item.parent then "/#{item.parent}/#{item.id}" else item.id
                .join ""

        _get_categories_items_favorites = (cb)->
            if tavmant.stores.settings_store.attributes.category.portfolio then return cb null, ""
            err, favorites_template <- fs.read-file "#{tavmant.path}/templates/categories/subcategory-list-favorites.html",
                encoding : "utf8"
            if err then cb err; return
            items = []
            _.each tavmant.stores.database_store.attributes.subcategory_items, (contain_subcategory_items)->
                _.each contain_subcategory_items, (subcategory_item)-> items.push subcategory_item
            if err then cb err else cb null, ->
                _ items
                .filter (subitem)-> !!subitem.favorite
                .map (subitem)->
                    favorites_template.replace /__locale__/g, subitem.locale
                    .replace /__link__/g, "#{subitem.parent}/#{subitem.id}"
                    .replace /__price__/g, subitem.price
                    .replace /__4__/g, (subitem.extra1 or "")
                    .replace /__5__/g, (subitem.extra2 or "")
                    .replace /__6__/g, (subitem.extra3 or "")
                .value!.join ""

        _get_html_subcategory = (item, parsed, cb)->
            err, list_content <- fs.read-file "#{tavmant.path}/templates/categories/list.html" encoding : "utf8"
            if err
                cb err
            else
                cb null,
                    _ if item.query then _transform_parsed parsed, item.query else parsed
                    .filter (subitem)-> if item.query then true else subitem.parent is item.id
                    .map (subitem)->
                        list_content.replace /__name__/g, subitem.id
                        .replace /__locale__/g, subitem.locale
                        .replace /__link__/g, "/#{subitem.parent}/#{subitem.id}"
                        .replace /__parent__/g, subitem.parent
                    .value!.join ""

        _get_html_subcategory_item = (item, cb)->
            err, subcategory_template <- fs.read-file "#{tavmant.path}/templates/categories/subcategory-list.html", encoding : "utf8"
            if err then cb err; return
            err, parsed_subcategory <- (next)->
                if tavmant.stores.settings_store.attributes.category.portfolio
                    err <- mkdirp "#{tavmant.path}/assets/img/tavmant-categories/#{item.id}"
                    if err then next err; return
                    err, paths <- dir_helper.paths "#{tavmant.path}/assets/img/tavmant-categories/#{item.id}", true
                    if err
                        next err
                    else
                        next null,
                            _ paths
                            .filter (path_item)-> !!path_item.match(/\.jpg$/)
                            .map (path_item)-> path.basename path_item, ".jpg"
                            .sort-by (item)-> parse-int item
                            .map (name)-> id : name, locale : name
                            .value!
                else
                    subcategory_items = []
                    _.each do
                        tavmant.stores.database_store.attributes.subcategory_items[item.id]
                        (subcategory_item)-> subcategory_items.push subcategory_item
                    next null, _.sort-by subcategory_items, "order"
            if err
                cb err
            else
                cb null,
                    _ parsed_subcategory
                    .map (subitem)->
                        subcategory_template.replace /__locale__/g, subitem.locale
                        .replace /__link__/g, "#{item.id}/#{subitem.id}"
                        .replace /__price__/g, subitem.price
                        .replace /__4__/g, _.identity -> subitem.extra1 or ""
                        .replace /__5__/g, _.identity -> subitem.extra2 or ""
                        .replace /__6__/g, _.identity -> subitem.extra3 or ""
                    .value!.join ""

        _get_menu = (parsed, cb)->
            err, [html_category, html_subcategory] <- async.parallel [
                async.apply fs.read-file, "#{tavmant.path}/templates/categories/menu-category.html", encoding : "utf8"  
                async.apply fs.read-file, "#{tavmant.path}/templates/categories/menu-subcategory.html", encoding : "utf8"
            ]
            if err then cb err else cb null, ->
                _ parsed
                .group-by (item)-> if item.query then item.id else item.parent or ""
                .map-values (items, name)->
                    if name is "" then return null
                    html_category.replace /__content__/g,
                        _.map items, (item)->
                            html_subcategory.replace /__name__/g, item.id
                            .replace /__locale__/g, item.locale
                            .replace /__link__/g, "/#{name}/#{item.id}"
                        .join ""
                    .replace /__name__/g, name
                    .replace /__locale__/g,
                        ((_.find parsed, (item)-> item.id is name) or [])
                        .locale
                .values!.compact!.value!.join ""

        _get_parsed = (cb)->
            parsed = []
            _.each tavmant.stores.database_store.attributes.categories, (item)->
                parsed.push item
            _.each tavmant.stores.database_store.attributes.subcategories, (item)->
                parsed.push item
            cb null, _.sort-by parsed, "order"

        _transform_fields =
            0 : "id"
            1 : "locale"
            2 : "parent"
            3 : "favorite"
            4 : "meta"
            5 : "content"
            6 : "query"

        _transform_parsed = (data, meta)->
            action = meta.split "---" .0 .trim!
            query =
                _(meta.split "---" .1 .trim!)
                .thru yaml.load .map-keys (val, key)->
                    if _.is-NaN parse-int key then key else _transform_fields[key - 1]
                .value!
            switch action
            | "filter" => sjs.match-array data, query


        # ************
        #    PUBLIC
        # ************
        get_helpers : (cb)->
            err, parsed <- _get_parsed!
            if err then cb err; return
            err, result <- async.parallel [
                async.apply _get_menu, parsed
                async.apply _get_favorites, parsed
                async.apply _get_categories_items_favorites
            ]
            cb err, [
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
            err, parsed <- _get_parsed!
            if err then cb err; return
            err <- _generate parsed
            cb err
