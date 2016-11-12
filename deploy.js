#!/usr/bin/env node

var argv = process.argv.slice(2);
if (argv.length == 0) {
  console.error("Usage: ./deploy.js <x.sol>");
  process.exit(1);
}

var solFile = argv[0];
var rootName = solFile.substring(0, solFile.lastIndexOf('.'));

var fs = require('fs');
var templatefile = "./template.js";
var template = fs.readFileSync(templatefile, "utf8");
var templateAbiFile = "./template-abi.js";
var templateAbi = fs.readFileSync(templateAbiFile, "utf8");

var exec = require('child_process').exec;
var cmd = 'solc --bin --abi -o ./bin ' + solFile;
exec(cmd, function(error, stdout, stderr) {
  // command output is in stdout
  if (!error) {
    var abi = fs.readFileSync("./bin/" + rootName + ".abi", "utf8").trim();
    var bin = fs.readFileSync("./bin/" + rootName + ".bin", "utf8").trim();
    template = template.replace(/\$ABI/, abi);
    template = template.replace(/\$BIN/, bin);
    templateAbi = templateAbi.replace(/\$ABI/, abi);
    fs.writeFileSync(rootName + ".js", template, "utf8");
    fs.writeFileSync(rootName + "-abi.js", templateAbi, "utf8");
  } else {
    console.error("Solc compilation error!");
    console.error(stderr);
    process.exit(1)
  }
});

