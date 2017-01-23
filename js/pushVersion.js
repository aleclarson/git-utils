var assertType, assertTypes, exec, git, optionTypes, os, semver;

assertTypes = require("assertTypes");

assertType = require("assertType");

semver = require("node-semver");

exec = require("exec");

os = require("os");

require("./addTag");

require("./commit");

require("./deleteTag");

require("./findVersion");

require("./isStaged");

require("./pushBranch");

require("./pushTags");

require("./revert");

git = require("./core");

optionTypes = {
  force: Boolean.Maybe,
  remote: String.Maybe,
  message: String.Maybe
};

module.exports = git.pushVersion = function(modulePath, version, options) {
  if (options == null) {
    options = {};
  }
  assertType(modulePath, String);
  assertType(version, String);
  assertTypes(options, optionTypes);
  if (!semver.valid(version)) {
    throw Error("Invalid version formatting!");
  }
  if (options.remote == null) {
    options.remote = "origin";
  }
  return git.isStaged(modulePath).assert("No changes were staged!").then(function() {
    return git.findVersion(modulePath, version);
  }).then(function(version, versions) {
    var index;
    if (version === null) {
      return;
    }
    index = versions.indexOf(version);
    if (index !== versions.length - 1) {
      throw Error("Can only overwrite the most recent version!");
    }
    if (!options.force) {
      throw Error("Version already exists!");
    }
    return git.revert(modulePath);
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
    return git.pushTags(modulePath, {
      force: options.force,
      remote: options.remote
    });
  }).fail(function(error) {
    if (/^fatal: The current branch [^\s]+ has no upstream branch/.test(error.message)) {
      return git.pushBranch(modulePath, options.remote, {
        force: options.force,
        upstream: true
      }).then(function() {
        return git.pushTags(modulePath, {
          force: options.force,
          remote: options.remote
        });
      });
    }
    throw error;
  }).fail(function(error) {
    return git.revertCommit(modulePath).then(function() {
      return git.deleteTag(modulePath, version);
    }).always(function() {
      throw error;
    });
  });
};

//# sourceMappingURL=map/pushVersion.map
