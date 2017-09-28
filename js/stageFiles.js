// Generated by CoffeeScript 1.12.4
var assertValid, exec, git, isValid;

assertValid = require("assertValid");

isValid = require("isValid");

exec = require("exec");

git = require("./core");

module.exports = git.stageFiles = function(modulePath, files) {
  assertValid(modulePath, "string");
  assertValid(files, "string|array");
  if (isValid(files, "string")) {
    files = [files];
  }
  return exec.async("git add", files, {
    cwd: modulePath
  }).fail(function(error) {
    if (/The following paths are ignored/.test(error.message)) {
      return;
    }
    throw error;
  });
};
