var Promise, assertType, exec, find, isStaged, os;

find = require("finder").find;

assertType = require("assertType");

Promise = require("Promise");

exec = require("exec");

os = require("os");

isStaged = require("./isStaged");

module.exports = function(modulePath, message) {
  assertType(modulePath, String);
  assertType(message, String);
  return isStaged(modulePath).assert("No changes were staged!").then(function() {
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

//# sourceMappingURL=map/commit.map
