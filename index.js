require("livescript");
if (process.env.dev) {
    require("remote").getCurrentWebContents().openDevTools();
}
require("./gulp/gulpfile.ls");
require("./electron_frontend/routes.ls");
