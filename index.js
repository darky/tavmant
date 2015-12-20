require("livescript");
require.extensions[".coffee"] = require.extensions[".ls"];
require("./gulp/gulpfile.coffee");