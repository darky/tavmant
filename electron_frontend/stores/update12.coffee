# *****************
#    NODEJS API
# *****************
fs = require "fs"
path = require "path"


# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
async = require "async"
Backbone = require "backbone"
csv_parse = require "csv-parse"
dir_helper = require "node-dir"
mkdirp = require "mkdirp"
rimraf = require "rimraf"
tavmant = require "../../common.coffee" .call!


module.exports = class extends Backbone.Model

    _do_it = ->
        err <~ mkdirp "#{tavmant.path}/db/categories"
        if err then tavmant.radio.trigger "logs:new:err", (err.message or err); return
        err <~ mkdirp "#{tavmant.path}/db/subcategories"
        if err then tavmant.radio.trigger "logs:new:err", (err.message or err); return
        err <~ mkdirp "#{tavmant.path}/db/subcategory_items"
        if err then tavmant.radio.trigger "logs:new:err", (err.message or err); return

        err, files <~ dir_helper.files "#{tavmant.path}/categories"
        if err then tavmant.radio.trigger "logs:new:err", (err.message or err); return
        csv_files = _.filter files, (file)-> !!file.match /\.csv$/
        err <~ async.each csv_files, (csv_file, next)->
            err, content <- fs.read-file csv_file, encoding : "utf8"
            if err then next err; return
            err, parsed <- csv_parse content.replace(/\r\n/g, "\n"), delimiter : ";"
            async.for-each-of parsed, (row, i, next)->
                if csv_file.match /tavmant-list\.csv$/
                    if row.2
                        fs.write-file "#{tavmant.path}/db/subcategories/#{row.0}.json",
                            JSON.stringify do
                                do ->
                                    obj = {}
                                    obj.id = row.0
                                    obj.locale = row.1
                                    obj.parent = row.2
                                    obj.favorite = row.3
                                    obj.meta = row.4
                                    obj.content = row.5
                                    obj.query = row.6
                                    obj.order = i
                                    obj
                                null
                                2
                            next
                    else
                        fs.write-file "#{tavmant.path}/db/categories/#{row.0}.json",
                            JSON.stringify do
                                do ->
                                    obj = {}
                                    obj.id = row.0
                                    obj.locale = row.1
                                    obj.favorite = row.3
                                    obj.meta = row.4
                                    obj.content = row.5
                                    obj.query = row.6
                                    obj.order = i
                                    obj
                                null
                                2
                            next
                else
                    err <- mkdirp "#{tavmant.path}/db/subcategory_items/#{path.basename csv_file, '.csv'}"
                    if err then next err; return
                    fs.write-file "#{tavmant.path}/db/subcategory_items/#{path.basename csv_file, '.csv'}/#{row.0}.json",
                        JSON.stringify do
                            do ->
                                obj = {}
                                obj.id = row.0
                                obj.locale = row.1
                                obj.price = row.2
                                obj.favorite = row.3
                                obj.parent = path.basename csv_file, ".csv"
                                obj.extra1 = row.4
                                obj.extra2 = row.5
                                obj.extra3 = row.6
                                obj.order = i
                                obj
                            null
                            2
                        next
            , next
        if err then tavmant.radio.trigger "logs:new:err", (err.message or err); return
        err <~ rimraf "#{tavmant.path}/categories"
        if err then tavmant.radio.trigger "logs:new:err", (err.message or err); return
        err <~ fs.write-file "#{tavmant.path}/version.txt", "latest12"
        if err
            tavmant.radio.trigger "logs:new:err", (err.message or err)
        else
            @set "updated", true

    initialize : ->
        @listen-to tavmant.radio, "update12:start", _do_it 
