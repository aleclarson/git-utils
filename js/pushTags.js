var assertType, assertTypes, exec, optionTypes, os;

assertTypes = require("assertTypes");

assertType = require("assertType");

exec = require("exec");

os = require("os");

optionTypes = {
  force: Boolean.Maybe,
  remote: String.Maybe
};

module.exports = function(modulePath, options) {
  var args;
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
