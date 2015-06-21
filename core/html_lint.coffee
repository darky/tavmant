# ************
#    DEFINE
# ************
html5lint = require "html5-lint"


# *************
#    LINTING
# *************
module.exports = (file)->
    html5lint(
        file.contents.toString "utf8"

        errorsOnly : true
        output     : "text"

        (err, messages)->
            console.log """
                *****************************
                   Ошибки HTML #{file.path}
                *****************************
            """
            console.log messages
    )