var assertType, assertTypes, exec, git, optionTypes, os;

assertTypes = require("assertTypes");

assertType = require("assertType");

exec = require("exec");

os = require("os");

git = require("./core");

optionTypes = {
  force: Boolean.Maybe,
  remote: String.Maybe
};

module.exports = git.pushTags = function(modulePath, options) {
  var args;
  if (options == null) {
    options = {};
  }
  assertType(modulePath, String);
  assertTypes(options, optionTypes);
  args = [options.remote || "origin", "--tags"];
  if (options.force) {
    args.push("-f");
  }
  return exec.async("git push", args, {
    cwd: modulePath
  }).fail(function(error) {
    var lines;
    lines = error.message.split(os.EOL);
    if (/\(already exists\)$/.test(lines[1])) {
      throw Error("Tag already exists!");
    }
    if (/\(forced update\)$/.test(lines[1])) {
      return;
    }
    if (/\* \[new tag\]/.test(lines[1])) {
      return;
    }
    throw error;
  });
};

//# sourceMappingURL=map/pushTags.map
