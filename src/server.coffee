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

program
  .version('0.4.0')
  .option('-p, --port <port>', 'Port for server to run on - defaults to 3333')
  .option('-d, --dir [path]', 'Server directory - defaults to ./')
  .option('-z, --compress', 'Add support for compression')
  .parse(process.argv)

port = program.port ? 3333
path = program.dir ? fs.realpathSync(path)
useCompress = program.compress ? false

startDefaultServer = (port, path) ->

  app = express()

  if useCompress == true
    app.use express.compress()
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

console.log("Starting Server on port %j from %s", port, path)
startDefaultServer(port, path)
