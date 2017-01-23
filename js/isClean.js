var assertType, git;

assertType = require("assertType");

require("./getStatus");

git = require("./core");

module.exports = git.isClean = function(modulePath) {
  assertType(modulePath, String);
  return git.getStatus(modulePath, {
    raw: true
  }).then(function(status) {
    return status.length === 0;
  });
};

//# sourceMappingURL=map/isClean.map
