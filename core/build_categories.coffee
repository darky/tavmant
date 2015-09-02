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
thunkify = require "thunkify"


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
            yield thunkify(async.each)(
                parsed
                (item, next)-> co ->*
                    builder = yield _get_builder item, parsed
                    yield builder.start!
                    next!
            )

        _get_builder = (item, parsed)-> co ->*
            list_wrapper_content = yield thunkify fs.read-file
            .call fs, "#{process.cwd()}/templates/categories/list-wrapper.html",
                encoding : "utf8"

            new HTML_Categories_Build do
                html : list_wrapper_content.replace "__content__",
                    if item.2
                        yield _get_html_subcategory_item item
                    else
                        yield _get_html_subcategory item, parsed
                name : item.0

        _get_favorites = (parsed)-> co ->*
            html_content = yield thunkify fs.read-file
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

        _get_html_subcategory = (item, parsed)-> co ->*
            list_content = yield thunkify fs.read-file
            .call fs, "#{process.cwd()}/templates/categories/list.html",
                encoding : "utf8"

            _ parsed
            .filter (subitem)-> subitem.2 is item.0
            .map (subitem)->
                list_content.replace /__name__/g, subitem.0
                .replace /__locale__/g, subitem.1
                .replace /__link__/g, "/#{subitem.2}/#{subitem.0}"
            .value!.join ""

        _get_html_subcategory_item = (item)-> co ->*
            [subcategory_content, subcategory_template] = yield [
                thunkify fs.read-file
                .call fs, "#{process.cwd()}/categories/#{item.0}.csv", encoding : "utf8"
                thunkify fs.read-file
                .call fs, "#{process.cwd()}/templates/categories/subcategory-list.html", encoding : "utf8"
            ]

            parsed_subcategory = yield new Promise (resolve)->
                csv_parse subcategory_content, delimiter : ";", (err, result)->
                    resolve result

            _ parsed_subcategory
            .map (subitem)->
                subcategory_template.replace /__name__/g, subitem.0
                .replace /__locale__/g, subitem.1
                .replace /__link__/g, "/#{subitem.2}/#{subitem.0}"
            .value!.join ""

        _get_menu = (parsed)-> co ->*
            [html_category, html_subcategory] = yield [
                thunkify fs.read-file
                .call fs,
                    "#{process.cwd()}/templates/categories/menu-category.html"
                    encoding : "utf8"
                thunkify fs.read-file
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

        _get_parsed = -> co ->*
            content = yield thunkify fs.read-file
            .call fs,
                "#{process.cwd()}/categories/tavmant-list.csv"
                encoding : "utf8"

            yield new Promise (resolve)->
                csv_parse content, delimiter : ";", (err, result)->
                    resolve result


        # ************
        #    PUBLIC
        # ************
        get_helpers : -> co ->*
            parsed = yield _get_parsed()

            [
                fn   : yield _get_menu parsed
                name : "categories_menu"
            ,
                fn   : yield _get_favorites parsed
                name : "categories_favorites"
            ]

        start : -> co ->*
            parsed = yield _get_parsed!
            yield _generate parsed
