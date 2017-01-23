var assertType, assertTypes, exec, getBranch, isType, optionTypes, os;

assertTypes = require("assertTypes");

assertType = require("assertType");

isType = require("isType");

exec = require("exec");

os = require("os");

getBranch = require("./getBranch");

optionTypes = {
  upstream: Boolean.Maybe,
  force: Boolean.Maybe
};

module.exports = function(modulePath, remoteName, options) {
  var args;
  if (options == null) {
    options = {};
  }
  if (isType(remoteName, Object)) {
    options = remoteName;
    remoteName = "origin";
  } else {
    if (remoteName == null) {
      remoteName = "origin";
    }
  }
  assertType(modulePath, String);
  assertType(remoteName, String);
  assertTypes(options, optionTypes);
  args = [remoteName];
  return getBranch(modulePath).then(function(currentBranch) {
    if (currentBranch === null) {
      throw Error("An initial commit must exist!");
    }
    if (options.upstream) {
      args.push("-u", currentBranch);
    }
    if (options.force) {
      args.push("-f");
    }
    return exec.async("git push", args, {
      cwd: modulePath
    }).fail(function(error) {
      var regex;
      if (!options.force) {
        if (/\(non-fast-forward\)/.test(error.message)) {
          throw Error("Must force push to overwrite remote commits!");
        }
      }
      regex = RegExp("(\\+|\\s)[\\s]+([a-z0-9]{7})[\\.]{2,3}([a-z0-9]{7})[\\s]+(HEAD|" + currentBranch + ")[\\s]+->[\\s]+" + currentBranch);
      if (regex.test(error.message)) {
        return;
      }
      regex = RegExp("\\*[\\s]+\\[new branch\\][\\s]+" + currentBranch + "[\\s]+->[\\s]+" + currentBranch);
      if (regex.test(error.message)) {
        return;
      }
      throw error;
    });
  });
};

//# sourceMappingURL=map/pushBranch.map
