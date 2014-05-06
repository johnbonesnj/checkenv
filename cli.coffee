'use strict'
chalk = require('chalk')
checkenv = require('./index')
isWin = process.platform is 'win32'

console.log "Usage\n  " + chalk.blue("checkenv") + "\n\nRuns checks against the environment"  if process.argv.indexOf("-h") isnt -1 or process.argv.indexOf("--help") isnt -1

console.log require("./package").version  if process.argv.indexOf("-v") isnt -1 or process.argv.indexOf("--version") isnt -1

checkenv (err, results) ->
  throw err if err
  fail = false
  console.log chalk.underline("\nEnvironment check\n") + results.map((el) ->
    if el.fail
      fail = true
      return chalk.red((if isWin then "x " else "✘ ")) + el.title + ((if el.message then " - " + el.message else ""))
    chalk.green((if isWin then "√ " else "✔ ")) + el.title + ((if el.message then " - " + el.message else ""))
    ).join("\n")
  process.exit (if fail then 1 else 0)
  return