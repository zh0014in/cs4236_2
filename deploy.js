#!/usr/bin/env node

var argv = process.argv.slice(2);
if (argv.length == 0) {
  console.error("Usage: ./deploy.js <x.sol>");
  process.exit(1);
}

var fs = require('fs');
var templatefile = "./template.js";
var template = fs.readFileSync(templatefile, "utf8");

var exec = require('child_process').exec;
var cmd = 'solc --bin --abi -o ./bin lottery.sol';
exec(cmd, function(error, stdout, stderr) {
  // command output is in stdout
  if (!error) {
    var abi = fs.readFileSync("./bin/lottery.abi", "utf8");
    var bin = fs.readFileSync("./bin/lottery.bin", "utf8");
    template = template.replace(/\$ABI/, abi);
    template = template.replace(/\$BIN/, bin);
    fs.writeFileSync("lottery.js", template, "utf8");
  } else {
    console.error("Solc compilation error!");
    process.exit(1)
  }
});

