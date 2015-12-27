brfs = require "brfs"
browserify = require "browserify"
fs = require "fs"
path = require "path"
through = require "through2"

browserify do
  browser-field : false
  builtins : false
  commondir : false
  entries : ["tavmant.js"]
  insert-global-vars : do
    process: undefined
    global: undefined
    "Buffer.isBuffer": undefined
    Buffer: undefined
    __filename: (file, basedir)->
        filename = '/' + path.relative basedir, file
        JSON.stringify filename
    __dirname: undefined
.ignore "remote"
.transform do
  (file, opts)->
    if file.match /node_modules\/livereload\/lib\/livereload\.js/
      brfs file, opts
    else
      through!
  global : true
.bundle!
.pipe fs.createWriteStream "tavmant2.js"
