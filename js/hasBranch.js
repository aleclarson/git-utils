var assertType, assertTypes, git, inArray, optionTypes;

assertTypes = require("assertTypes");

assertType = require("assertType");

inArray = require("in-array");

require("./getBranches");

git = require("./core");

optionTypes = {
  remote: String.Maybe
};

module.exports = git.hasBranch = function(modulePath, branchName, options) {
  if (options == null) {
    options = {};
  }
  assertType(modulePath, String);
  assertType(branchName, String);
  assertTypes(options, optionTypes);
  return git.getBranches(modulePath, options.remote).then(function(branchNames) {
    return inArray(branchNames, branchName);
  });
};

//# sourceMappingURL=map/hasBranch.map
