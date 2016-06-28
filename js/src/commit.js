var Promise, assertType, exec, find, isStaged, os, quoteWrap;

find = require("finder").find;

assertType = require("assertType");

Promise = require("Promise");

exec = require("exec");

os = require("os");

isStaged = require("./isStaged");

quoteWrap = function(s) {
  return "\"" + s + "\"";
};

module.exports = function(modulePath, message) {
  assertType(modulePath, String);
  assertType(message, String);
  return Promise.assert("No changes were staged!", function() {
    return isStaged(modulePath);
  }).then(function() {
    var args, newline, paragraph;
    message = message.replace("'", "\\'");
    newline = message.indexOf(os.EOL);
    if (newline >= 0) {
      paragraph = message.slice(newline + 1);
      message = message.slice(0, newline);
    }
    args = ["-m", quoteWrap(message)];
    if (paragraph) {
      args.push("-m", quoteWrap(paragraph));
    }
    return exec.async("git commit", args, {
      cwd: modulePath
    }).then(function(stdout) {
      var firstLine, regex;
      firstLine = stdout.slice(0, stdout.indexOf(os.EOL));
      regex = /^\[.+ ([0-9a-z]{7})\]/;
      return find(regex, firstLine, 1);
    });
  });
};

//# sourceMappingURL=../../map/src/commit.map
