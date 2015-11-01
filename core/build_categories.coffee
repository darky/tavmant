# ***********************
#    NODEJS API DEFINE
# ***********************
fs = require "fs"


# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
async = require "async"
co = require "co"
promisify = require "promisify-node"


# *********
#    CSV
# *********
csv_parse = require "csv-parse"


# *******************
#    CORE CLASSES
# *******************
HTML_Categories_Build = require "./build_html_categories.coffee"


module.exports =

    class Categories_Build

        # *************
        #    PRIVATE
        # *************
        _generate = (parsed)-> co ->*
            yield promisify(async.each)(
                parsed
                (item, next)-> co ->*
                    builder = yield _get_builder item, parsed
                    yield builder.start!
                    next!
                .catch (e)-> console.error e
            )
        .catch (e)-> console.error e

        _get_builder = (item, parsed)-> co ->*
            list_wrapper_content = yield promisify fs.read-file
            .call fs, "#{process.cwd()}/templates/categories/list-wrapper.html",
                encoding : "utf8"

            {title} = JSON.parse item.4

            new HTML_Categories_Build do
                html : list_wrapper_content.replace "__content__",
                    if item.2
                        yield _get_html_subcategory_item item
                    else
                        yield _get_html_subcategory item, parsed
                .replace "__title__", title
                .replace "__text__", item.5
                .replace "__name__", item.0
                name : "#{item.2}/#{item.0}"
        .catch (e)-> console.error e

        _get_favorites = (parsed)-> co ->*
            html_content = yield promisify fs.read-file
            .call fs,
                "#{process.cwd()}/templates/categories/favorites.html"
                encoding : "utf8"

            _ parsed
            .filter (item)-> !!item.3
            .map (item)->
                html_content.replace /__name__/g, item.0
                .replace /__locale__/g, item.1
                .replace /__link__/g, if item.2 then "/#{item.2}/#{item.0}" else item.0
            .join ""
        .catch (e)-> console.error e

        _get_categories_items_favorites = -> co ->*
            files_names = _.filter do
                yield promisify fs.readdir
                .call fs, "#{process.cwd()}/categories"
                (file_name)-> file_name isnt "tavmant-list.csv"

            file_contents = yield new Promise (resolve)->
                async.map do
                    files_names
                    (item, cb)->
                        fs.read-file "#{process.cwd()}/categories/#{item}",
                            encoding : "utf8"
                            (err, content)-> cb null, content
                    (err, results)-> resolve results

            all_items = yield new Promise (resolve)->
                async.map do
                    file_contents
                    (item, cb)->
                        csv_parse item, delimiter : ";", (err, result)->
                            cb null, result
                    (err, results)-> resolve results

            favorites_template = yield promisify fs.read-file
            .call fs,
                "#{process.cwd()}/templates/categories/subcategory-list-favorites.html"
                encoding : "utf8"

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
        .catch (e)-> console.error e

        _get_html_subcategory = (item, parsed)-> co ->*
            list_content = yield promisify fs.read-file
            .call fs, "#{process.cwd()}/templates/categories/list.html",
                encoding : "utf8"

            _ parsed
            .filter (subitem)-> subitem.2 is item.0
            .map (subitem)->
                list_content.replace /__name__/g, subitem.0
                .replace /__locale__/g, subitem.1
                .replace /__link__/g, "/#{subitem.2}/#{subitem.0}"
            .value!.join ""
        .catch (e)-> console.error e

        _get_html_subcategory_item = (item)-> co ->*
            [subcategory_content, subcategory_template] = yield [
                promisify fs.read-file
                .call fs, "#{process.cwd()}/categories/#{item.0}.csv", encoding : "utf8"
                promisify fs.read-file
                .call fs, "#{process.cwd()}/templates/categories/subcategory-list.html", encoding : "utf8"
            ]

            parsed_subcategory = yield new Promise (resolve)->
                csv_parse subcategory_content, delimiter : ";", (err, result)->
                    resolve result

            _ parsed_subcategory
            .map (subitem)->
                subcategory_template.replace /__locale__/g, subitem.1
                .replace /__link__/g, "#{item.0}/#{subitem.0}"
                .replace /__price__/g, subitem.2
                .replace /__4__/g, _.identity -> subitem.4 or ""
                .replace /__5__/g, _.identity -> subitem.5 or ""
                .replace /__6__/g, _.identity -> subitem.6 or ""
            .value!.join ""
        .catch (e)-> console.error e

        _get_menu = (parsed)-> co ->*
            [html_category, html_subcategory] = yield [
                promisify fs.read-file
                .call fs,
                    "#{process.cwd()}/templates/categories/menu-category.html"
                    encoding : "utf8"
                promisify fs.read-file
                .call fs,
                    "#{process.cwd()}/templates/categories/menu-subcategory.html"
                    encoding : "utf8"
            ]

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
        .catch (e)-> console.error e

        _get_parsed = -> co ->*
            content = yield new Promise (resolve)->
                fs.read-file "#{process.cwd()}/categories/tavmant-list.csv",
                    encoding : "utf8", (err, data)->
                        resolve if err then "" else data


            yield new Promise (resolve)->
                csv_parse content, delimiter : ";", (err, result)->
                    resolve result
        .catch (e)-> console.error e


        # ************
        #    PUBLIC
        # ************
        get_helpers : -> co ->*
            parsed = yield _get_parsed()

            if parsed.length
                [
                    fn   : yield _get_menu parsed
                    name : "categories_menu"
                ,
                    fn   : yield _get_favorites parsed
                    name : "categories_favorites"
                ,
                    fn   : yield _get_categories_items_favorites!
                    name : "categories_items_favorites"
                ]
            else
                []
        .catch (e)-> console.error e

        start : -> co ->*
            try
                parsed = yield _get_parsed!
            catch
                return
            yield _generate parsed
        .catch (e)-> console.error e
