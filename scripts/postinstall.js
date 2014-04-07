#!/usr/bin/env node

var fs = require('fs');
var path = require('path');
var mkdirp = require('mkdirp');

var localFile   = path.normalize(__dirname + '/../config/auth.js');
var projectFolder = path.normalize(process.cwd() + '/../config/plugins');
var projectFile = path.normalize(projectFolder + '/auth.js');

if(!fs.existsSync(projectFile)){
  console.log("coppying " + localFile + " to " + projectFile);
  mkdirp.sync(projectFolder);
  fs.createReadStream(localFile).pipe(fs.createWriteStream(projectFile));
}
