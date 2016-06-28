var assert, assertType, assertTypes, exec, git, optionTypes, os, semver;

assertTypes = require("assertTypes");

assertType = require("assertType");

semver = require("node-semver");

assert = require("assert");

exec = require("exec");

os = require("os");

git = {
  addTag: require("./addTag"),
  commit: require("./commit"),
  deleteTag: require("./deleteTag"),
  findVersion: require("./findVersion"),
  isStaged: require("./isStaged"),
  pushBranch: require("./pushBranch"),
  pushTags: require("./pushTags"),
  resetBranch: require("./resetBranch")
};

optionTypes = {
  force: Boolean.Maybe,
  remote: String.Maybe,
  message: String.Maybe
};

module.exports = function(modulePath, version, options) {
  assertType(modulePath, String);
  assertType(version, String);
  assertTypes(options, optionTypes);
  assert(semver.valid(version), "Invalid version formatting!");
  if (options.remote == null) {
    options.remote = "origin";
  }
  return Promise.assert("No changes were staged!", function() {
    return git.isStaged(modulePath);
  }).then(function() {
    return git.findVersion(modulePath, version);
  }).then(function(arg) {
    var index, versions;
    index = arg.index, versions = arg.versions;
    if (index < 0) {
      return;
    }
    if (!options.force) {
      throw Error("Version already exists!");
    }
    if (index !== versions.length - 1) {
      throw Error("Can only overwrite the most recent version!");
    }
    return git.resetBranch(modulePath, "HEAD^");
  }).then(function() {
    var message;
    message = version;
    if (options.message) {
      message += os.EOL + options.message;
    }
    return git.commit(modulePath, message);
  }).then(function() {
    return git.addTag(modulePath, version, {
      force: options.force
    });
  }).then(function() {
    return git.pushBranch(modulePath, options.remote, {
      force: options.force
    });
  }).then(function() {
    return git.pushTags(modulePath, options.remote, {
      force: options.force
    });
  }).fail(function(error) {
    if (/^fatal: The current branch [^\s]+ has no upstream branch/.test(error.message)) {
      return git.pushBranch(modulePath, options.remote, {
        force: options.force,
        upstream: true
      }).then(function() {
        return git.pushTags(modulePath, options.remote, {
          force: options.force
        });
      });
    }
    throw error;
  }).fail(function(error) {
    return git.resetBranch(modulePath, "HEAD^").then(function() {
      return git.deleteTag(modulePath, version);
    }).then(function() {
      throw error;
    });
  });
};

//# sourceMappingURL=../../map/src/pushVersion.map
