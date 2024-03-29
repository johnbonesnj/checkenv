// Generated by CoffeeScript 1.7.1
'use strict';
var chalk, checkenv, isWin;

chalk = require('chalk');

checkenv = require('./index');

isWin = process.platform === 'win32';

if (process.argv.indexOf("-h") !== -1 || process.argv.indexOf("--help") !== -1) {
  console.log("Usage\n  " + chalk.blue("checkenv") + "\n\nRuns checks against the environment");
}

if (process.argv.indexOf("-v") !== -1 || process.argv.indexOf("--version") !== -1) {
  console.log(require("./package").version);
}

checkenv(function(err, results) {
  var fail;
  if (err) {
    throw err;
  }
  fail = false;
  console.log(chalk.underline("\nEnvironment check\n") + results.map(function(el) {
    if (el.fail) {
      fail = true;
      return chalk.red((isWin ? "x " : "✘ ")) + el.title + (el.message ? " - " + el.message : "");
    }
    return chalk.green((isWin ? "√ " : "✔ ")) + el.title + (el.message ? " - " + el.message : "");
  }).join("\n"));
  process.exit((fail ? 1 : 0));
});
