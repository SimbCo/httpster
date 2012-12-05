fs = require("fs")
crypto = require("crypto")

module.exports = favicon = (path, options) ->
  options = options or {}
  maxAge = options.maxAge or 86400000
  icon = undefined
  # favicon cache
  favicon = (req, res, next) ->
    if "/favicon.ico" is req.url
      if icon
        res.writeHead 200, icon.headers
        res.end icon.body
      else
        path = __dirname + "/../bin"  unless fs.existsSync(path + "/favicon.ico")
        fs.readFile path + "/favicon.ico", (err, buf) ->
          return next(err)  if err
          icon =
            headers:
              "Content-Type": "image/x-icon"
              "Content-Length": buf.length
              ETag: "\"" + md5(buf) + "\""
              "Cache-Control": "public, max-age=" + (maxAge / 1000)

            body: buf

          res.writeHead 200, icon.headers
          res.end icon.body

    else
      next()

md5 = (str, encoding) ->
  crypto.createHash("md5").update(str).digest encoding or "hex"