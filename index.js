if (process.env.TAVMANT_DEV) {
  global.require("livescript");
  global.require.extensions[".coffee"] = global.require.extensions[".ls"];
  global.require("remote").getCurrentWebContents().openDevTools();
}
require("./gulp/gulpfile.coffee");
require("./electron_frontend/routes.coffee");
