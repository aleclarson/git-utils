// Generated by CoffeeScript 1.12.4
var assertType, exec, git;

assertType = require("assertType");

exec = require("exec");

git = require("./core");

module.exports = git.popStash = function(modulePath) {
  assertType(modulePath, String);
  return exec.async("git stash pop", {
    cwd: modulePath
  });
};
