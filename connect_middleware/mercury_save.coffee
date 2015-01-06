_ = require "lodash"
async = require "async"
co = require "co"
fs = require "fs"
thunkify = require "thunkify"

module.exports = (options)->
    {partials} = options

    (req, res, next)->
        if req.method is "PUT" and req.url is "/" then co ->
            yield thunkify(
                async.each
            )(
                _.pairs req.body.content
                ([key, obj], next)->
                    fs.writeFile(
                        if key in partials
                            "./partials/#{key}.html"
                        obj.value
                        next
                    )
            )

            res.setHeader "Content-Type", "application/json"
            res.end """
                "{}"
            """
        else
            next()