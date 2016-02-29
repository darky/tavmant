if (process.env.TAVMANT_DEV) {
  global.require("livescript");
  global.require("remote").BrowserWindow.addDevToolsExtension(process.env.HOME + "/.config/chromium/Default/Extensions/bomhdjeadceaggdgfoefmpeafkjhegbo/2.0.7_0");
  global.require("remote").getCurrentWebContents().openDevTools();
}
require("./gulp/gulpfile.ls");
require("./electron_frontend/routes.ls");
