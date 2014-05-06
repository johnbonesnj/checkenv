'use strict'

execFile  = require('child_process').execFile
which     = require 'which'
eachAsync = require 'each-async'
semver    = require 'semver'
checks    = []

# cb = (opts, obj) ->
#   console.log 'Title: ' + obj.title
#   console.log 'Message: ' + obj.message
#   console.log 'Failed?: ' + obj.fail


binaryCheck = (bin, opts, cb) ->
  opts = opts || {}
  title = opts.title || bin[0].toUpperCase() + bin.slice(1);
  which(bin, (err) ->
    if (err)
      if (/not found/.test(err.message))
        return cb(null, {
          title: title,
          message: opts.message || 'not found',
          fail: true
          })
      return cb(err)
    cb(null, {title: title})
  )


[
  "ruby"
  "compass"
  "git"
  "yo"
].forEach (el) ->
  checks.push binaries = (cb) ->
    binaryCheck el, null, cb
    return

home = (cb) ->
  win = process.platform is "win32"
  home = (if win then process.env.USERPROFILE else process.env.HOME)
  cb null,
    title: (if win then "%USERPROFILE" else "$HOME")
    message: not home and "environment variable is not set. This is required to know where your home directory is. Follow this guide: https://github.com/sindresorhus/guides/blob/master/set-environment-variables.md"
    fail: not home
  return
checks.push home

node = (cb) ->
  try
    bin = which.sync("node")
  catch err
    return cb(null,
      title: "Node.js"
      message: "Not installed. Please install from http://nodejs.org"
      fail: true
    )
  execFile bin, ["--version"], (err, stdout) ->
    return cb(err) if err
    version = stdout.trim()
    pass = semver.satisfies(version, ">=0.10.0")
    cb null,
      title: "Node.js"
      message: not pass and version + " is outdated. Please update at http://nodejs.org"
      fail: not pass
    return
  return
checks.push node

npm = (cb) ->
  try
    bin = which.sync("npm")
  catch err
    return cb(null,
      title: "npm"
      message: "Not installed. Please install Node.js (which bundles npm) from http://nodejs.org"
      fail: true
    )
  execFile bin, ["--version"], (err, stdout) ->
    return cb(err)  if err
    version = stdout.trim()
    pass = semver.satisfies(version, ">=1.3.10")
    cb null,
      title: "npm"
      message: not pass and version + " is outdated. Please update by running: npm update --global npm"
      fail: not pass

    return

  return
checks.push npm


module.exports = (cb) ->
  results = []
  eachAsync checks, ((el, i, next) ->
    el (err, result) ->
      return next(err)  if err
      results.push result
      next()
      return

    return
  ), (err) ->
    cb err, results
    return

  return