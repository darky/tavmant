# *****************
#    NODE JS API
# *****************
fs = require "fs"
path = require "path"


# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
async = require "async"
Backbone = require "backbone"
dir_helper = require "node-dir"
mkdirp = require "mkdirp"
to_buffer = require "blob-to-buffer"
tavmant = require "../../common.ls" .call!


module.exports = class extends Backbone.Model

    _add_photo = (photo_path, file_blob)->
        err, buffer <~ to_buffer file_blob
        if err
            tavmant.radio.trigger "logs:new:err", (err.message or err)
            return
        err <~ mkdirp path.dirname "#{tavmant.path}/assets/img/tavmant-categories/#{photo_path}.jpg"
        if err
            tavmant.radio.trigger "logs:new:err", (err.message or err)
            return
        err <~ fs.write-file "#{tavmant.path}/assets/img/tavmant-categories/#{photo_path}.jpg", buffer
        if err
            tavmant.radio.trigger "logs:new:err", (err.message or err)
        else
            @set "forceupdate", _.random 1000000000, 10000000000

    _delete = (file_path)->
        err <- fs.unlink "#{tavmant.path}/db/#{file_path}.json"
        if err then tavmant.radio.trigger "logs:new:err", (err.message or err)

    _save = (data, dir)->
        trimmed_data = _.map-values data, (val)-> val.trim?! or val
        err <~ mkdirp "#{tavmant.path}/db/#{dir}"
        if err
            tavmant.radio.trigger "logs:new:err", (err.message or err)
            return
        err <~ fs.write-file "#{tavmant.path}/db/#{dir}/#{trimmed_data.id}.json", JSON.stringify trimmed_data, null, 2
        if err
            tavmant.radio.trigger "logs:new:err", (err.message or err)

    _read = (dir)->
        err, list <~ dir_helper.files "#{tavmant.path}/db/#{dir}"
        if err
            tavmant.radio.trigger "logs:new:err", (err.message or err)
            return
        json_files = list.filter (file)-> !!file.match /\.json$/
        err, parsed <~ async.map json_files, (file, next)->
            err, content <- fs.read-file file, encoding : "utf8"
            if err then next err; return
            next err, JSON.parse content
        if err
            tavmant.radio.trigger "logs:new:err", (err.message or err)
        else
            @set "content", _.sort-by parsed, "order"

    _reorder = (data, dir)->
        err <- async.for-each-of data, (item, i, next)->
            item.order = i
            if dir is "subcategory_items"
                parent = item.parent or ""
            else
                parent = ""
            fs.write-file do
                "#{tavmant.path}/db/#{dir}/#{parent}/#{item.id}.json"
                JSON.stringify item, null, 2
                (err)-> next err
        if err
            tavmant.radio.trigger "logs:new:err", (err.message or err)
        else
            tavmant.radio.trigger "category:read", dir

    _reset = ->
        @set "content", []

    initialize : ->
        @listen-to tavmant.radio, "category:reset", _reset
        @listen-to tavmant.radio, "category:read", _read
        @listen-to tavmant.radio, "category:save", _save
        @listen-to tavmant.radio, "category:delete", _delete
        @listen-to tavmant.radio, "category:reorder", _reorder
        @listen-to tavmant.radio, "category:add:photo", _add_photo
