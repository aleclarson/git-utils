// Generated by CoffeeScript 1.12.4
var assertValid, git;

assertValid = require("assertValid");

require("./getStatus");

git = require("./core");

module.exports = git.isClean = function(modulePath) {
  assertValid(modulePath, "string");
  return git.getStatus(modulePath, {
    raw: true
  }).then(function(status) {
    return status.length === 0;
  });
};