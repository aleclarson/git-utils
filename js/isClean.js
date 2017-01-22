var assertType, getStatus;

assertType = require("assertType");

getStatus = require("./getStatus");

module.exports = function(modulePath) {
  assertType(modulePath, String);
  return getStatus(modulePath, {
    raw: true
  }).then(function(status) {
    return status.length === 0;
  });
};

//# sourceMappingURL=map/isClean.map
