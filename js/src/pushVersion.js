var Path, addCommit, addTag, assert, assertStaged, assertTypes, exec, findVersion, log, optionTypes, popCommit, pushHead, pushTags, removeTag, semver, stageAll;

assertTypes = require("assertTypes");

semver = require("node-semver");

assert = require("assert");

Path = require("path");

exec = require("exec");

log = require("log");

assertStaged = require("./assertStaged");

findVersion = require("./findVersion");

removeTag = require("./removeTag");

addCommit = require("./addCommit");

popCommit = require("./popCommit");

stageAll = require("./stageAll");

pushHead = require("./pushHead");

pushTags = require("./pushTags");

addTag = require("./addTag");

optionTypes = {
  modulePath: String,
  remoteName: String,
  version: String,
  message: String.Maybe,
  force: Boolean.Maybe
};

module.exports = function(options) {
  var force, message, modulePath, remoteName, version;
  assertTypes(options, optionTypes);
  modulePath = options.modulePath, remoteName = options.remoteName, version = options.version, message = options.message, force = options.force;
  assert(semver.valid(version), "Invalid version formatting!");
  return assertStaged(modulePath).then(function() {
    return findVersion(modulePath, version);
  }).then(function(arg) {
    var index, versions;
    index = arg.index, versions = arg.versions;
    if (index < 0) {
      return;
    }
    if (!force) {
      throw Error("Version already exists!");
    }
    if (index !== versions.length - 1) {
      throw Error("Can only overwrite the most recent version!");
    }
    return popCommit(modulePath);
  }).then(function() {
    message = version + (message ? log.ln + message : "");
    return addCommit(modulePath, message);
  }).then(function() {
    return addTag({
      modulePath: modulePath,
      tagName: version,
      force: force
    });
  }).then(function() {
    return pushHead({
      modulePath: modulePath,
      remoteName: remoteName,
      force: force
    });
  }).then(function() {
    return pushTags({
      modulePath: modulePath,
      remoteName: remoteName,
      force: force
    });
  }).fail(function(error) {
    if (/^fatal: The current branch [^\s]+ has no upstream branch/.test(error.message)) {
      return pushHead({
        modulePath: modulePath,
        remoteName: remoteName,
        force: force,
        upstream: true
      }).then(function() {
        return pushTags({
          modulePath: modulePath,
          remoteName: remoteName,
          force: force
        });
      });
    }
    throw error;
  }).fail(function(error) {
    return popCommit(modulePath).then(function() {
      return removeTag(modulePath, version);
    }).then(function() {
      throw error;
    });
  });
};

//# sourceMappingURL=../../map/src/pushVersion.map
