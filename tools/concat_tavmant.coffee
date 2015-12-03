brfs = require "brfs"
browserify = require "browserify"
fs = require "fs"
path = require "path"
through = require "through2"

browserify do
  browser-field : false
  builtins : false
  commondir : false
  entries : ["gulpfile.js"]
  insert-global-vars : do
    process: undefined
    global: undefined
    "Buffer.isBuffer": undefined
    Buffer: undefined
    __filename: (file, basedir)->
        filename = '/' + path.relative basedir, file
        JSON.stringify filename
    __dirname: (file, basedir)->
        dir = path.dirname '/' + path.relative basedir, file
        JSON.stringify dir
.exclude "key.js"
.transform do
  (file, opts)->
    if file.match /node_modules\/gm\/index\.js/
      brfs file, opts
    else if file.match /node_modules\/livereload\/lib\/livereload\.js/
      brfs file, opts
    else
      through!
  global : true
.bundle!
.pipe fs.createWriteStream "tavmant.js"
