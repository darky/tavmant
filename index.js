require("livescript");
if (!require.extensions) {
  require.extensions = {};
}
require.extensions[".coffee"] = require.extensions[".ls"];
require("./common.coffee");
if (process.env.TAVMANT_DEV) {
  require("remote").getCurrentWebContents().openDevTools();
}
require("./gulp/gulpfile.coffee");
require("./electron_frontend/routes.coffee");
