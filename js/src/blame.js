var assertTypes, exec, isType, optionTypes;

assertTypes = require("assertTypes");

isType = require("isType");

exec = require("exec");

optionTypes = {
  modulePath: String,
  filePath: String,
  lines: Array.Maybe
};

module.exports = function(options) {
  var args, filePath, lines, modulePath;
  if (isType(options, String)) {
    options = {
      modulePath: arguments[0],
      filePath: arguments[1],
      lines: arguments[2]
    };
  }
  assertTypes(options, optionTypes);
  modulePath = options.modulePath, filePath = options.filePath, lines = options.lines;
  args = ["--porcelain"];
  if (lines.length >= 2) {
    args.push("-L" + lines[0] + "," + lines[1]);
  }
  args.push("--", filePath);
  return exec("git blame", args, {
    cwd: modulePath
  });
};

//# sourceMappingURL=../../map/src/blame.map
