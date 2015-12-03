try
  fs = require "fs"
  http = require "http"
  os = require "os"

  err, version <- fs.read-file "./version.txt", encoding : "utf8"
  if err then console.log "Ошибка чтения version.txt"; process.exit!

  try
    err, login <- fs.read-file "./login.txt", encoding : "utf8"
    if err then console.log "Ошибка чтения login.txt"; process.exit!

    try
      license_salt = "t1RANgvoC3lKeNHUJbRDxr06RggWYwmT"
      license_salt2 = "7nJY9Pgx39pIqB7XDu74ounx97d9444b"

      license_formula = "
        #{ os.totalmem! }
        #{ os.cpus!.0.model }
        #{ license_salt }
        #{ os.type! }
        #{ os.arch! }
        #{ license_salt2 }
        #{ os.platform! }
        #{ os.homedir! }
        #{ os.networkInterfaces!.en0?.0.mac or os.networkInterfaces!.eth0?.0.mac or os.networkInterfaces!.Ethernet?.0.mac }
      "

      decipher = require "crypto" .create-decipher "aes-256-cbc", "1WRhJ4ApQLDQu6GxZOHiPYPCZbsn9Jvq"
      cipher = require "crypto" .create-cipher "aes-256-cbc", "1WRhJ4ApQLDQu6GxZOHiPYPCZbsn9Jvq"

      auth = cipher.update license_formula, "utf8", "hex"
      auth += cipher.final "hex"

      http.request do
        host : "tavmant-license.herokuapp.com"
        path : "/?login=#{login}&version=#{version}&auth=#{auth}"
        port : 80
        (res)->
          try
            encrypted = ""
            res.on "data", (chunk)->
              try
                encrypted += chunk
            res.on "end", ->
              try
                if res.status-code isnt 200
                  console.log encrypted
                else
                  resp = JSON.parse encrypted
                  console.log "Текущая версия: #{resp.version}"
                  console.log "Лицензия истекает: #{resp.expire}"
                  code = decipher.update resp.data, "hex", "utf8"
                  code += decipher.final "utf8"
                  eval code
      .end!
