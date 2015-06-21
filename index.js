require("livescript");
require.extensions[".coffee"] = require.extensions[".ls"];
module.exports = require("./node_modules/gulp/bin/gulp.js");