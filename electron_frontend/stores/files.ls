# *****************
#    NODE JS API
# *****************
fs = require "fs"
path = require "path"


# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
Backbone = require "backbone"
dir_helper = require "node-dir"
mkdirp = require "mkdirp"
tavmant = require "../../common.ls" .call!


clipboard = global.require "electron" .clipboard


module.exports = class extends Backbone.Model

    _add = (file)->
        folder = @get "folder"
        file_path = "#{tavmant.path}/#{folder}/#{file}"
        err <~ mkdirp path.dirname file_path
        if err
            tavmant.radio.trigger "logs:new:err", (err.message or err)
            return
        err <~ fs.write-file file_path, ""
        if err
            tavmant.radio.trigger "logs:new:err", (err.message or err)
        else
            tavmant.radio.trigger "files:list", @get "filter"

    _copy_clipboard = ->
        clipboard.write-text <| @get "current" .replace "#{tavmant.path}#{path.sep}assets", ""

    _delete = ->
        err <~ fs.unlink @get "current"
        if err then tavmant.radio.trigger "logs:new:err", (err.message or err)
        tavmant.radio.trigger "files:list", @get "filter"

    _list = (filter)->
        folder = @get "folder"
        err, files_list <~ dir_helper.files "#{tavmant.path}/#{folder}"
        if err
            tavmant.radio.trigger "logs:new:err", (err.message or err)
        else
            @set do
                files : _.filter files_list, (file_path)~>
                    if filter
                        not file_path.match filter
                    else
                        true
                filter  : filter
                current : ""
                content : ""

    _save = (content)->
        err <~ fs.write-file do
            @get "current"
            content
        if err
            tavmant.radio.trigger "logs:new:err", (err.message or err)
        else
            @set "content", content

    _select = (file)->
        if not file then return
        err, content <~ fs.read-file file, encoding : "utf8"
        if err
            tavmant.radio.trigger "logs:new:err", (err.message or err)
        else
            @set content : content, current : file

    _set_folder = (folder)->
        @set "folder", folder

    initialize : ->
        @listen-to tavmant.radio, "files:list", _list
        @listen-to tavmant.radio, "files:select", _select
        @listen-to tavmant.radio, "files:save", _save
        @listen-to tavmant.radio, "files:delete", _delete
        @listen-to tavmant.radio, "files:set:folder", _set_folder
        @listen-to tavmant.radio, "files:add", _add
        @listen-to tavmant.radio, "files:copy:clipboard", _copy_clipboard
