var assertType, assertTypes, exec, git, optionTypes, path, sync;

assertTypes = require("assertTypes");

assertType = require("assertType");

path = require("path");

exec = require("exec");

sync = require("sync");

git = require("./core");

optionTypes = {
  commit: String.Maybe,
  dryRun: Boolean.Maybe
};

module.exports = git.resetFiles = function(modulePath, files, options) {
  var args;
  if (options == null) {
    options = {};
  }
  assertType(modulePath, String);
  assertType(files, String.or(Array));
  assertTypes(options, optionTypes);
  if (!Array.isArray(files)) {
    files = [files];
  } else if (!files.length) {
    return;
  }
  files = sync.map(files, function(filePath) {
    if (filePath[0] === path.sep) {
      filePath = path.relative(modulePath, filePath);
      if (filePath[0] === ".") {
        throw Error("'filePath' must be a descendant of: '" + modulePath + "'");
      }
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

//# sourceMappingURL=map/resetFiles.map
