require("livescript");
require.extensions[".coffee"] = require.extensions[".ls"];
require("./common.coffee");
if (process.env.TAVMANT_DEV) {
  require(tavmant.path + "/dev.coffee");
}
require("./gulp/gulpfile.coffee");