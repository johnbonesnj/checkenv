// Generated by CoffeeScript 1.7.1
'use strict';
var binaryCheck, checks, eachAsync, execFile, home, semver, which;

execFile = require('child_process').execFile;

which = require('which');

eachAsync = require('each-async');

semver = require('semver');

checks = [];

binaryCheck = function(bin, opts, cb) {
  var title;
  opts = opts || {};
  title = opts.title || bin[0].toUpperCase() + bin.slice(1);
  return which(bin, function(err) {
    if (err) {
      if (/not found/.test(err.message)) {
        return cb(null, {
          title: title,
          message: opts.message || 'not found',
          fail: true
        });
      }
      return cb(err);
    }
    return cb(null, {
      title: title
    });
  });
};

["ruby", "compass", "git", "yuo"].forEach(function(el) {
  var binaries;
  return checks.push(binaries = function(cb) {
    binaryCheck(el, null, cb);
  });
});

checks.push(home = function(cb) {
  var win;
  win = process.platform === "win32";
  home = (win ? process.env.USERPROFILE : process.env.HOME);
  cb(null, {
    title: (win ? "%USERPROFILE" : "$HOME"),
    message: !home && "environment variable is not set. This is required to know where your home directory is. Follow this guide: https://github.com/sindresorhus/guides/blob/master/set-environment-variables.md",
    fail: !home
  });
});

module.exports = function(cb) {
  var results;
  results = [];
  eachAsync(checks, (function(el, i, next) {
    el(function(err, result) {
      if (err) {
        return next(err);
      }
      results.push(result);
      next();
    });
  }), function(err) {
    cb(err, results);
  });
};
