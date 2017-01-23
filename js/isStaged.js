var assertType, git, hasKeys;

assertType = require("assertType");

hasKeys = require("hasKeys");

require("./getStatus");

git = require("./core");

module.exports = git.isStaged = function(modulePath) {
  assertType(modulePath, String);
  return git.getStatus(modulePath).then(function(status) {
    return hasKeys(status.staged);
  });
};

//# sourceMappingURL=map/isStaged.map
