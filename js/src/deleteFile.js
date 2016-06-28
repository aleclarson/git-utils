var assertType, exec, fs;

assertType = require("assertType");

exec = require("exec");

fs = require("io/sync");

module.exports = function(modulePath, filePath) {
  var args;
  assertType(modulePath, String);
  assertType(filePath, String);
  if (fs.isDir(filePath)) {
    args = ["-r", filePath];
  } else {
    args = [filePath];
  }
  return exec.async("git rm", args, {
    cwd: modulePath
  });
};

//# sourceMappingURL=../../map/src/deleteFile.map
