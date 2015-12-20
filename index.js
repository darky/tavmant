require("livescript");
require.extensions[".coffee"] = require.extensions[".ls"];
require("./common.coffee");
require("./gulp/gulpfile.coffee");