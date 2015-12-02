var brfs = require("brfs"),
  browserify = require("browserify"),
  fs = require("fs"),
  path = require("path"),
  through = require("through2");

browserify({
  browserField : false,
  builtins : false,
  commondir : false,
  entries : ["gulpfile.js"],
  insertGlobalVars : {
    process: undefined,
    global: undefined,
    'Buffer.isBuffer': undefined,
    Buffer: undefined,
    __filename: function (file, basedir) {
        var filename = '/' + path.relative(basedir, file);
        return JSON.stringify(filename);
    },
    __dirname: function (file, basedir) {
        var dir = path.dirname('/' + path.relative(basedir, file));
        return JSON.stringify(dir);
    }
  }
}).exclude("key.js").transform(function (file, opts) {
  if (file.match(/node_modules\/gm\/index\.js/)) {
    return brfs(file, opts);
  }
  if (file.match(/node_modules\/livereload\/lib\/livereload\.js/)) {
    return brfs(file, opts);
  }
  return through();
}, {
  global : true
}).bundle().pipe(fs.createWriteStream("tavmant.js"))
