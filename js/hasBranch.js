// Generated by CoffeeScript 1.12.4
var assertValid, git, inArray, optionTypes;

assertValid = require("assertValid");

inArray = require("in-array");

require("./getBranches");

git = require("./core");

optionTypes = {
  remote: "string?"
};

module.exports = git.hasBranch = function(modulePath, branchName, options) {
  if (options == null) {
    options = {};
  }
  assertValid(modulePath, "string");
  assertValid(branchName, "string");
  assertValid(options, optionTypes);
  return git.getBranches(modulePath, options.remote).then(function(branchNames) {
    return inArray(branchNames, branchName);
  });
};