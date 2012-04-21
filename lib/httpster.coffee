#!/usr/bin/env node

/*
  HTTPster
  Copyright(c) 2010 Simeon Bateman <simeon@simb.net>
  MIT Licensed
*/

var fs = require('fs')
  , program = require('commander')
  , exec = require('child_process').exec
  , express = require('express')
  , port = 3333
  , path = "./"

program
  .version('0.1.0')
  .option('-p, --port <port>', 'Port for server to run on - defaults to 3333')
  .option('-d, --dir [path]', 'Server directory - defaults to ./')
  .parse(process.argv);

if (program.port) port = program.port;
if (program.dir){
  path = program.dir;
}else{
  path = fs.realpathSync(path);
}

startDefaultServer = function(port, path) {
  var server;
  server = express.createServer();
  server.configure(function() {
    server.use(express.static(path));
    server.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
    server.use(express.logger(':method :url :status'));
    
  });
  server.get('/', function(req, res) {
    return res.render('index.html');
  });
  server.listen(parseInt(port, 10));
  
  return server;
};

console.log("Starting Server on port %j from %s", port, path);
startDefaultServer(port, path);
