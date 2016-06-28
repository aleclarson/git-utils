var assertType, getStatus, hasKeys;

assertType = require("assertType");

hasKeys = require("hasKeys");

getStatus = require("./getStatus");

module.exports = function(modulePath) {
  assertType(modulePath, String);
  return getStatus(modulePath).then(function(status) {
    return hasKeys(status.staged);
  });
};

//# sourceMappingURL=../../map/src/isStaged.map
