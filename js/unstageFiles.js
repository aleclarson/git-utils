// Generated by CoffeeScript 1.12.4
var assertType, exec, git;

assertType = require("assertType");

exec = require("exec");

git = require("./core");

module.exports = git.unstageFiles = function(modulePath, files) {
  assertType(modulePath, String);
  assertType(files, String.or(Array));
  if (!Array.isArray(files)) {
    files = [files];
  }
  return exec.async("git reset --", files, {
    cwd: modulePath
  });
};
