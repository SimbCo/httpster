#!/usr/bin/env node

###
  HTTPster
  Copyright(c) 2018 Simeon Bateman <simeon@simb.net>
  MIT Licensed
###

fs = require('fs')
program = require('commander')
exec = require('child_process').exec
express = require('express')
serveIndex = require('serve-index')
cors = require('cors')
path = "./"
port = undefined
fav = require('./fav')
pack = require('../package.json')
env = require('node-env-file')
basicAuth = require('basic-auth')
morgan = require('morgan')

program
  .version(pack.version)
  .option('-p, --port <port>', 'Port for server to run on - defaults to 3333')
  .option('-d, --dir [path]', 'Server directory - defaults to ./')
  .option('-z, --compress', 'Add support for compression')
  .option('-s, --pushstate', 'Add support for HTML5 pushstate')
  .option('-e, --env', 'Add support for setting environmental variables from .env file')
  .option('-b, --basic_auth', 'Add support for basic auth security. Uses environmental variables HTTPSTER_AUTH_USER and HTTPSTER_AUTH_PASS to authenticate')
  .option('-c, --cors', 'Add cors support')
  .parse(process.argv)

if program.env
  env(fs.realpathSync(path) + "/.env")

port = program.port ? 3333
path = program.dir ? fs.realpathSync(path)
useCompress = program.compress ? false
useCors = program.cors ? false
usePushstate = program.pushstate ? false

if program.basic_auth
  if !process.env.HTTPSTER_AUTH_USER?
    throw('HTTPSTER Basic Authentication Enabled but no HTTPSTER_AUTH_USER environmental variable was found')
  if !process.env.HTTPSTER_AUTH_PASS?
    throw('HTTPSTER Basic Authentication Enabled but no HTTPSTER_AUTH_PASS environmental variable was found')

startDefaultServer = (port, path) ->

  app = express()

  if useCompress == true
    app.use express.compress()

  app.use fav(path)
  app.use basicAuth(process.env.HTTPSTER_AUTH_USER, process.env.HTTPSTER_AUTH_PASS) if program.basic_auth
  app.use cors() if useCors
  app.use express.static(path)
  app.use serveIndex(path)
  app.use morgan("dev")
  # app.use express.errorHandler(dumpExceptions: true, showStack: true)

  # pushstate support
  if usePushstate == true
    app.all "/*", (req, res) ->
      res.sendfile "index.html",
        root: path
      return

  # production only
  if ( app.get('env') == 'production')
    app.use express.staticCache()
  

  app.listen(parseInt(port, 10))

  app

console.log("Starting HTTPster v%s on port %j from %s", pack.version, port, path)
startDefaultServer(port, path)
