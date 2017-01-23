var assertType, assertTypes, exec, git, optionTypes;

assertTypes = require("assertTypes");

assertType = require("assertType");

exec = require("exec");

git = require("./core");

optionTypes = {
  keepIndex: Boolean.Maybe,
  includeUntracked: Boolean.Maybe
};

module.exports = git.pushStash = function(modulePath, options) {
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
  if (options.includeUntracked) {
    args.push("--include-untracked");
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

//# sourceMappingURL=map/pushStash.map
