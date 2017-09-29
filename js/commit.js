// Generated by CoffeeScript 1.12.4
var Promise, assertValid, exec, find, git, os;

find = require("finder").find;

assertValid = require("assertValid");

Promise = require("Promise");

exec = require("exec");

os = require("os");

require("./isStaged");

git = require("./core");

module.exports = git.commit = function(modulePath, message) {
  assertValid(modulePath, "string");
  assertValid(message, "string");
  return git.isStaged(modulePath).assert("No changes were staged!").then(function() {
    var args, newline, paragraph;
    newline = message.indexOf(os.EOL);
    if (newline >= 0) {
      paragraph = message.slice(newline + 1);
      message = message.slice(0, newline);
    }
    args = ["-m", message];
    paragraph && args.push("-m", paragraph);
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
