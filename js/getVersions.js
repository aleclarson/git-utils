var SortedArray, assertType, git, semver;

SortedArray = require("sorted-array");

assertType = require("assertType");

semver = require("node-semver");

require("./getTags");

git = require("./core");

module.exports = git.getVersions = function(modulePath) {
  assertType(modulePath, String);
  return git.getTags(modulePath).then(function(tagNames) {
    var i, len, tagName, versions;
    versions = SortedArray([], semver.compare);
    for (i = 0, len = tagNames.length; i < len; i++) {
      tagName = tagNames[i];
      if (!semver.valid(tagName)) {
        continue;
      }
      versions.insert(tagName);
    }
    return versions.array;
  });
};

//# sourceMappingURL=map/getVersions.map
