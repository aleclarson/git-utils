var assertTypes, exec, fs, isType, optionTypes;

assertTypes = require("assertTypes");

isType = require("isType");

exec = require("exec");

fs = require("io/sync");

optionTypes = {
  modulePath: String,
  file: String
};

module.exports = function(options) {
  var args, file, modulePath;
  if (isType(options, String)) {
    options = {
      modulePath: arguments[0],
      file: arguments[1]
    };
  }
  assertTypes(options, optionTypes);
  modulePath = options.modulePath, file = options.file;
  args = [file];
  if (fs.isDir(file)) {
    args.unshift("-r");
  }
  return exec("git rm", args, {
    cwd: modulePath
  });
};

//# sourceMappingURL=../../map/src/removeFile.map
