var Promise, assertType, git, semver;

assertType = require("assertType");

Promise = require("Promise");

semver = require("node-semver");

require("./getVersions");

git = require("./core");

module.exports = git.findVersion = function(modulePath, versionPattern) {
  assertType(modulePath, String);
  assertType(versionPattern, String);
  return git.getVersions(modulePath).then(function(versions) {
    var version;
    version = semver.maxSatisfying(versions, versionPattern);
    return Promise(version, versions);
  });
};

//# sourceMappingURL=map/findVersion.map
