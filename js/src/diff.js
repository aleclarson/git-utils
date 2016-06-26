var assertTypes, exec, find, isType, optionTypes;

find = require("finder").find;

assertTypes = require("assertTypes");

isType = require("isType");

exec = require("exec");

optionTypes = {
  modulePath: String,
  from: String,
  to: String.Maybe
};

module.exports = function(options) {
  var from, modulePath, to;
  if (isType(options, String)) {
    options = {
      modulePath: arguments[0],
      from: arguments[1],
      to: arguments[2]
    };
  }
  assertTypes(options, optionTypes);
  modulePath = options.modulePath, from = options.from, to = options.to;
  if (to == null) {
    to = "HEAD";
  }
  return exec("git diff --raw " + from + ".." + to, {
    cwd: modulePath
  }).then(function(stdout) {
    var lines, regex;
    lines = stdout.split("\n");
    regex = /^:[0-9]{6} [0-9]{6} [0-9a-z]{7}\.\.\. [0-9a-z]{7}\.\.\. (.)\t(.+)$/;
    return lines.map(function(line) {
      var path, status;
      status = find(regex, line, 1);
      path = find(regex, line, 2);
      return {
        status: status,
        path: path
      };
    });
  }).fail(function(error) {
    if (/unknown revision or path not in the working tree/.test(error.message)) {
      throw Error("Unknown revision (or path not in the working tree)!");
    }
    throw error;
  });
};

//# sourceMappingURL=../../map/src/diff.map
