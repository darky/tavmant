beep = require "beepbeep"

module.exports = {
    is_error : (err)->
        if err
            console.log err
            beep 3
            true
}