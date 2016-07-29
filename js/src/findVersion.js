var assertType, getVersions, semver;

assertType = require("assertType");

semver = require("node-semver");

getVersions = require("./getVersions");

module.exports = function(modulePath, version) {
  assertType(modulePath, String);
  assertType(version, String);
  return getVersions(modulePath).then(function(versions) {
    var existingVersion, i, index, len;
    for (index = i = 0, len = versions.length; i < len; index = ++i) {
      existingVersion = versions[index];
      if (semver.eq(version, existingVersion)) {
        return {
          index: index,
          versions: versions
        };
      }
    }
    return {
      index: -1,
      versions: versions
    };
  });
};

//# sourceMappingURL=../../map/src/findVersion.map
