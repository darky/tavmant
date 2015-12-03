fs = require "fs"
http = require "http"
querystring = require "querystring"
server = http.create-server (req, res)->
  query = req.url.replace /^\/\?/, ""
  params = querystring.parse query

  if not params.login or not params.auth or not params.version
    res.write-head 418; res.end "<====3"; return

  err, users_str <- fs.read-file "users.json", encoding : "utf8"
  users = JSON.parse users_str

  if users[params.login] isnt params.auth
    res.write-head 401
    res.end "Вы не зарегистрированы в системе. Отправьте #{params.auth} на darkvlados@me.com"
    return
  if users["#{params.login}$expire"] < Date.now!
    res.write-head 402
    res.end "Срок лицензии истёк. Отправьте #{params.auth} на darkvlados@me.com"
    return

  file_name <- (cb)->
    if params.version.match /^latest(\d)+/
      err, files <- fs.readdir "."
      cb do
        files.filter (name)-> !!name.match "tavmant-#{that.1}"
        .sort!reverse!.0 or ""
    else
      cb "tavmant-#{params.version}"

  err, data <- fs.read-file file_name, encoding : "utf8"
  if err
    res.write-head 404
    res.end "#{params.version} не найдена"
  else
    res.write-head 200
    res.end JSON.stringify do
      version : file_name.match /tavmant-(.+)$/ .1
      expire : (new Date users["#{params.login}$expire"]).to-locale-string!
      data : data
server.listen process.env.PORT
