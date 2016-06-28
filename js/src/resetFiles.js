var assertType, assertTypes, exec, optionTypes, path;

assertTypes = require("assertTypes");

assertType = require("assertType");

path = require("path");

exec = require("exec");

optionTypes = {
  commit: String.Maybe,
  dryRun: Boolean.Maybe
};

module.exports = function(modulePath, files, options) {
  var args;
  assertType(modulePath, String);
  assertType(files, [String, Array]);
  assertTypes(options, optionTypes);
  if (!Array.isArray(files)) {
    files = [files];
  } else if (!files.length) {
    return;
  }
  files = sync.map(files, function(filePath) {
    if (filePath[0] === path.sep) {
      filePath = path.relative(modulePath, filePath);
      assert(filePath[0] !== ".", "'filePath' must be a descendant of: '" + modulePath + "'");
    }
    return filePath;
  });
  args = [options.commit || "HEAD", "--"].concat(files);
  if (options.dryRun) {
    args.push("-p");
  }
  return exec.async("git checkout", args, {
    cwd: modulePath
  });
};

//# sourceMappingURL=../../map/src/resetFiles.map
