#!/usr/bin/env node

###
  HTTPster
  Copyright(c) 2010 Simeon Bateman <simeon@simb.net>
  MIT Licensed
###

fs = require('fs')
program = require('commander')
exec = require('child_process').exec
express = require('express')
path = "./"
port = undefined
fav = require('./fav')
pack = require('../package.json')

program
  .version(pack.version)
  .option('-p, --port <port>', 'Port for server to run on - defaults to 3333')
  .option('-d, --dir [path]', 'Server directory - defaults to ./')
  .parse(process.argv)

port = program.port ? 3333
path = program.dir ? fs.realpathSync(path)

startDefaultServer = (port, path) ->

  app = express()

  app.use( fav(path) )
  app.use express.static(path)
  app.use express.logger(format:"dev")
  app.use express.errorHandler(dumpExceptions: true, showStack: true)

  # production only
  app.configure('production', ->
    app.use express.staticCache()
  )

  #app.use '/', (req, res) ->  res.render('index.html')
  app.listen(parseInt(port, 10))

  app

console.log("Starting HTTPster v%s on port %j from %s", pack.version, port, path)
startDefaultServer(port, path)