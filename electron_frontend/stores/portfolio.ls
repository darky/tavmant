# ****************
#    NODEJS API
# ****************
fs = require "fs"


# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
async = require "async"
Backbone = require "backbone"
tavmant = require "../../common.ls" .call!


del = require "del"
to_buffer = require "blob-to-buffer"


module.exports = class extends Backbone.Model

    _add_folder = (name, dir)->
        err <- fs.mkdir "#{tavmant.path}/assets/img/#{dir}/#{name}"
        if err
            tavmant.radio.trigger "logs:new:err", (err.message or err)
        else
            tavmant.radio.trigger "portfolio:read:folders", dir

    _add_photos = (file_blobs, dir)->
        err, buffers <~ async.map file_blobs, (blob, next)->
            to_buffer blob, (err, buffer)-> next err, [buffer, blob.name]
        if err
            tavmant.radio.trigger "logs:new:err", (err.message or err)
            return
        err <~ async.each buffers, ([buffer, name], next)~>
            fs.write-file do
                "#{tavmant.path}/assets/img/#{dir}/#{@get 'current'}/#{name.to-lower-case!}"
                buffer
                next
        if err
            tavmant.radio.trigger "logs:new:err", (err.message or err)
        else
            tavmant.radio.trigger "portfolio:read:folder", @get("current"), dir

    _delete_folder = (dir)->
        err <- del "#{tavmant.path}/assets/img/#{dir}/#{@get 'current'}" .then
        tavmant.radio.trigger "portfolio:read:folders", dir

    _delete_picture = (picture, dir)->
        err <~ del "#{tavmant.path}/assets/img/#{dir}/#{@get 'current'}/#{picture}" .then
        tavmant.radio.trigger "portfolio:read:folder", @get("current"), dir

    _read_folder = (folder, dir)->
        err, list <~ fs.readdir "#{tavmant.path}/assets/img/#{dir}/#{folder}"
        if err
            tavmant.radio.trigger "logs:new:err", (err.message or err)
            return
        pictures = _.filter list, (item)-> !!item.match /\.jpg$/
        @set do
            current  : folder
            pictures : pictures

    _read_folders = (dir)->
        err, list <~ fs.readdir "#{tavmant.path}/assets/img/#{dir}"
        if err
            tavmant.radio.trigger "logs:new:err", (err.message or err)
            return
        folders = _.filter list, (item)-> item.index-of(".") is -1
        @set "folders", folders

    initialize : ->
        @listen-to tavmant.radio, "portfolio:read:folders", _read_folders
        @listen-to tavmant.radio, "portfolio:read:folder", _read_folder
        @listen-to tavmant.radio, "portfolio:add:photos", _add_photos
        @listen-to tavmant.radio, "portfolio:delete:folder", _delete_folder
        @listen-to tavmant.radio, "portfolio:add:folder", _add_folder
        @listen-to tavmant.radio, "portfolio:delete:picture", _delete_picture
