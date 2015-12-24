# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
React = require "react"
$ = React.DOM
Backbone_Mixin = require "backbone-react-component"


alertify = require "alertify.js"
Dropzone = require "react-dropzone"


module.exports = class extends React.Component

    _add_folder = ->
        folder <- alertify.prompt "Название папки"
        tavmant.radio.trigger "portfolio:add:folder", folder

    _add_photos = (file_blobs)->
        no_jpg = _.any file_blobs, (blob)-> blob.type isnt "image/jpeg"
        if no_jpg
            alertify.log "Нужно все фотографии jpg"
        else
            tavmant.radio.trigger "portfolio:add:photos", file_blobs

    _delete_folder = ->
        <- alertify.confirm "Удалить?"
        tavmant.radio.trigger "portfolio:delete:folder"

    _delete_picture = (e)->
        if e.target.dataset.picture
            <- alertify.confirm "Удалить?"
            tavmant.radio.trigger "portfolio:delete:picture", that

    _select_folder = (e)->
        tavmant.radio.trigger "portfolio:read:folder", e.target.inner-text

    component-will-mount : ->
        Backbone_Mixin.on-model @, tavmant.stores.portfolio_store
        tavmant.radio.trigger "portfolio:read:folders"

    component-will-unmount : ->
        Backbone_Mixin.off @

    render : ->
        $.div null,
            $.div class-name : "col-md-3 col-lg-3",
                $.div class-name : "row pager",
                    $.button class-name : "fa fa-plus", on-click : _add_folder
                    $.button class-name : "fa fa-remove", on-click : _delete_folder, disabled : not @state.model.current
                $.ul on-click : _select_folder,
                    _.map @state.model.folders, (folder)~>
                        $.li do
                            class-name : if @state.model.current is folder then "bg-info"
                            key : _.unique-id "folder"
                            folder
            $.div class-name : "col-md-9 col-lg-9", on-click : _delete_picture,
                _.map @state.model.pictures, (picture)~>
                    $.div do
                        class-name : "thumbnail"
                        key : _.unique-id "picture"
                        $.button class-name : "fa fa-remove", "data-picture" : picture
                        $.img src : "#{tavmant.path}/assets/img/tavmant-categories/#{@state.model.current}/#{picture}"
                React.create-element Dropzone, on-drop : _add_photos
