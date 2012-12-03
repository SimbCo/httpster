#!/usr/bin/env node

###
  HTTPster
  Copyright(c) 2010 Simeon Bateman <simeon@simb.net>
  MIT Licensed
###

fs = require('fs')
program = require('commander')
exec = require('child_process').exec
connect = require('connect')
path = "./"
port = undefined

program
  .version('0.1.0')
  .option('-p, --port <port>', 'Port for server to run on - defaults to 3333')
  .option('-d, --dir [path]', 'Server directory - defaults to ./')
  .parse(process.argv)

port = program.port ? 3333
path = program.dir ? fs.realpathSync(path)

startDefaultServer = (port, path) ->

  app = connect()

  app.use connect.static(path)
  app.use connect.logger(format:"dev")
  app.use connect.errorHandler(dumpExceptions: true, showStack: true)

  #app.use '/', (req, res) ->  res.render('index.html')
  app.listen(parseInt(port, 10))

  app

console.log("Starting Server on port %j from %s", port, path)
startDefaultServer(port, path)