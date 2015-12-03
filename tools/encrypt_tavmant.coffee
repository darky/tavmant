cipher =
  require "crypto"
  .create-cipher "aes-256-cbc", "1WRhJ4ApQLDQu6GxZOHiPYPCZbsn9Jvq"
fs = require "fs"

err, data <- fs.read-file "tavmant.js", encoding : "utf8"
result = cipher.update data, "utf8", "hex"
result += cipher.final "hex"
err, version <- fs.read-file "version.txt", encoding : "utf8"
fs.write-file "tavmant-#{version}", result
