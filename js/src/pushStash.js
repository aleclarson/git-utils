var assertType, assertTypes, exec, optionTypes;

assertTypes = require("assertTypes");

assertType = require("assertType");

exec = require("exec");

optionTypes = {
  keepIndex: Boolean.Maybe
};

module.exports = function(modulePath, options) {
  var args;
  if (options == null) {
    options = {};
  }
  assertType(modulePath, String);
  assertTypes(options, optionTypes);
  args = [];
  if (options.keepIndex) {
    args.push("--keep-index");
  }
  return exec.async("git stash", args, {
    cwd: modulePath
  }).fail(function(error) {
    if (/bad revision 'HEAD'/.test(error.message)) {
      throw Error("Cannot stash unless an initial commit exists!");
    }
    throw error;
  });
};

//# sourceMappingURL=../../map/src/pushStash.map
