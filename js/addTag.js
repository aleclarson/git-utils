var assertType, assertTypes, exec, git, optionTypes;

assertTypes = require("assertTypes");

assertType = require("assertType");

exec = require("exec");

git = require("./core");

optionTypes = {
  force: Boolean.Maybe
};

module.exports = git.addTag = function(modulePath, tagName, options) {
  var args;
  if (options == null) {
    options = {};
  }
  assertType(modulePath, String);
  assertType(tagName, String);
  assertTypes(options, optionTypes);
  args = [tagName];
  if (options.force) {
    args.unshift("-f");
  }
  return exec.async("git tag", args, {
    cwd: modulePath
  }).fail(function(error) {
    var expected;
    if (!options.force) {
      expected = "fatal: tag '" + tagName + "' already exists";
      if (error.message === expected) {
        throw Error("Tag already exists!");
      }
    }
    throw error;
  });
};

//# sourceMappingURL=map/addTag.map
