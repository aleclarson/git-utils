var assertStaged, assertTypes, exec, find, isType, log, optionTypes;

find = require("finder").find;

assertTypes = require("assertTypes");

isType = require("isType");

exec = require("exec");

log = require("log");

assertStaged = require("./assertStaged");

optionTypes = {
  modulePath: String,
  message: String
};

module.exports = function(options) {
  var message, modulePath;
  if (isType(options, String)) {
    options = {
      modulePath: arguments[0],
      message: arguments[1]
    };
  }
  assertTypes(options, optionTypes);
  modulePath = options.modulePath, message = options.message;
  return assertStaged(modulePath).then(function() {
    var args, newline, paragraph;
    message = message.replace("'", "\\'");
    newline = message.indexOf(log.ln);
    if (newline >= 0) {
      paragraph = message.slice(newline + 1);
      message = message.slice(0, newline);
    }
    args = ["-m", message];
    if (paragraph) {
      args.push("-m", paragraph);
    }
    return exec("git commit", args, {
      cwd: modulePath
    }).then(function(stdout) {
      var firstLine, regex;
      firstLine = stdout.slice(0, stdout.indexOf(log.ln));
      regex = /^\[.+ ([0-9a-z]{7})\]/;
      return find(regex, firstLine, 1);
    });
  });
};

//# sourceMappingURL=../../map/src/pushCommit.map
