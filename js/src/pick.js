var assertTypes, exec, optionTypes;

assertTypes = require("assertTypes");

exec = require("exec");

optionTypes = {
  modulePath: String,
  commit: String,
  theirs: Boolean.Maybe,
  ours: Boolean.Maybe
};

module.exports = function(options) {
  var args, commit, modulePath, ours, theirs;
  assertTypes(options, optionTypes);
  modulePath = options.modulePath, commit = options.commit, theirs = options.theirs, ours = options.ours;
  args = [commit];
  if (ours) {
    args.push("-X", "ours");
  }
  if (theirs) {
    args.push("-X", "theirs");
  }
  return exec("git cherry-pick", args, {
    cwd: modulePath
  });
};

//# sourceMappingURL=../../map/src/pick.map
