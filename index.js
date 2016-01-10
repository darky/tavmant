if (process.env.TAVMANT_DEV) {
  global.require("livescript");
  global.require("remote").BrowserWindow.addDevToolsExtension(process.env.HOME + "/Library/Application Support/Google/Chrome/Default/Extensions/bomhdjeadceaggdgfoefmpeafkjhegbo/2.0.5_0");
  global.require("remote").getCurrentWebContents().openDevTools();
}
require("./gulp/gulpfile.ls");
require("./electron_frontend/routes.ls");
