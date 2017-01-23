var assertType, assertTypes, exec, git, optionTypes, os;

assertTypes = require("assertTypes");

assertType = require("assertType");

exec = require("exec");

os = require("os");

git = require("./core");

optionTypes = {
  remote: String.Maybe
};

module.exports = git.deleteBranch = function(modulePath, branchName, options) {
  if (options == null) {
    options = {};
  }
  assertType(modulePath, String);
  assertType(branchName, String);
  assertTypes(options, optionTypes);
  return exec.async("git branch -D " + branchName, {
    cwd: modulePath
  }).then(function() {
    if (!options.remote) {
      return;
    }
    return exec.async("git push " + options.remote + " --delete " + branchName, {
      cwd: modulePath
    });
  }).fail(function(error) {
    var expected, lines;
    expected = "error: branch '" + branchName + "' not found.";
    if (error.message === expected) {
      throw Error("The given branch does not exist!");
    }
    expected = "error: Cannot delete the branch '" + branchName + "' which you are currently on.";
    if (error.message === expected) {
      throw Error("Cannot delete the current branch!");
    }
    lines = error.message.split(os.EOL);
    expected = "fatal: '" + branchName + "' does not appear to be a git repository";
    if (lines[0] === expected) {
      throw Error("The given remote repository does not exist!");
    }
    throw error;
  });
};

//# sourceMappingURL=map/deleteBranch.map
