var assertType, assertTypes, exec, optionTypes;

assertTypes = require("assertTypes");

assertType = require("assertType");

exec = require("exec");

optionTypes = {
  lines: Array.Maybe
};

module.exports = function(modulePath, filePath, options) {
  var args, lines;
  if (options == null) {
    options = {};
  }
  assertType(modulePath, String, "modulePath");
  assertType(filePath, String, "filePath");
  assertTypes(options, optionTypes, "options");
  args = ["--porcelain"];
  lines = options.lines;
  if (lines && lines.length >= 2) {
    args.push("-L" + lines[0] + "," + lines[1]);
  }
  args.push("--", filePath);
  return exec.async("git blame", args, {
    cwd: modulePath
  });
};

//# sourceMappingURL=map/blame.map
