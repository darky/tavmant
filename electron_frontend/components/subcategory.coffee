# ****************
#    NODEJS API
# ****************
path = require "path"


# **********************
#    MUST HAVE DEFINE
# **********************
_ = require "lodash"
React = require "react"
$ = React.DOM
Backbone_Mixin = require "backbone-react-component"


Files = require "./files.coffee"
Categories = require "./category.coffee"


class Subcategory extends Categories

    _get_subcategory_file_name = (self)->
        _.last self.state.files.current.split path.sep

    _fields : ->
        [
            name  : "0"
            title : "ID"
            type  : "text"
            width : 50
        ,
            name  : "1"
            title : "Название"
            type  : "text"
            width : 50
        ,
            name  : "2"
            title : "Цена"
            type  : "text"
            width : 50
        ,
            name  : "3"
            title : "Флаг фаворит"
            type  : "text"
            width : 50
        ,
            name  : "4"
            title : "4"
            type  : "text"
        ,
            name  : "5"
            title : "5"
            type  : "text"
        ,
            name  : "6"
            title : "6"
            type  : "text"
        ,
            item-template : (value, row)~>
                "
                    <img width=100 \
                    src=\"#{tavmant.path}/assets/img/tavmant-categories
                    /#{path.basename @state.files.current, '.csv'}
                    /#{row.0}.jpg?_=#{_.random 1000000000, 10000000000}\">
                "
            title : "Фото"
        ,
            type : "control"
        ]

    _get_content : ->
        @state.category.content

    _get_photo_path : ($selected)->
        "#{path.basename @state.files.current, '.csv'}#{path.sep}#{$selected.data 'JSGridItem' .0}"

    _save : ->
        tavmant.radio.trigger "category:save",
            jQuery "\#table" .data "JSGrid" .data
            _get_subcategory_file_name @

    component-will-mount : ->
        Backbone_Mixin.on @, models :
            category : tavmant.stores.category_store
            files    : tavmant.stores.files_store

    component-will-update : ->
        if @state.files.current
            tavmant.radio.trigger "category:read", _get_subcategory_file_name @

module.exports = class extends React.Component

    component-will-mount : ->
        Backbone_Mixin.on @, models :
            files    : tavmant.stores.files_store
            settings : tavmant.stores.settings_store

    component-will-unmount : ->
        Backbone_Mixin.off @

    render : ->
        $.div null,
            if @state.settings.category.portfolio
                123
            else
                $.div class-name : "col-md-2 col-lg-2",
                    React.create-element Files, folder : "categories"
            if @state.settings.category.portfolio
                123
            else
                $.div class-name : "col-md-10 col-lg-10",
                    React.create-element Subcategory
