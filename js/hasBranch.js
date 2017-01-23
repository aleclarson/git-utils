var assertType, assertTypes, getBranches, inArray, optionTypes;

assertTypes = require("assertTypes");

assertType = require("assertType");

inArray = require("in-array");

getBranches = require("./getBranches");

optionTypes = {
  remote: String.Maybe
};

module.exports = function(modulePath, branchName, options) {
  if (options == null) {
    options = {};
  }
  assertType(modulePath, String);
  assertType(branchName, String);
  assertTypes(options, optionTypes);
  return getBranches(modulePath, options.remote).then(function(branchNames) {
    return inArray(branchNames, branchName);
  });
};

//# sourceMappingURL=map/hasBranch.map
