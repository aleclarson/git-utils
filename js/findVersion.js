var Promise, assertType, getVersions, semver;

assertType = require("assertType");

Promise = require("Promise");

semver = require("node-semver");

getVersions = require("./getVersions");

module.exports = function(modulePath, versionPattern) {
  assertType(modulePath, String);
  assertType(versionPattern, String);
  return getVersions(modulePath).then(function(versions) {
    var version;
    version = semver.maxSatisfying(versions, versionPattern);
    return Promise(version, versions);
  });
};

//# sourceMappingURL=map/findVersion.map
