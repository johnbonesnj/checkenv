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
  "yuo"
].forEach (el) ->
  checks.push binaries = (cb) ->
    binaryCheck el, null, cb
    return

checks.push home = (cb) ->
  win = process.platform is "win32"
  home = (if win then process.env.USERPROFILE else process.env.HOME)
  cb null,
    title: (if win then "%USERPROFILE" else "$HOME")
    message: not home and "environment variable is not set. This is required to know where your home directory is. Follow this guide: https://github.com/sindresorhus/guides/blob/master/set-environment-variables.md"
    fail: not home
  return


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