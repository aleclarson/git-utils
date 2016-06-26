var assertTypes, exec, isType, optionTypes;

assertTypes = require("assertTypes");

isType = require("isType");

exec = require("exec");

optionTypes = {
  modulePath: String,
  branchName: String,
  remoteName: String.Maybe
};

module.exports = function(options) {
  var branchName, modulePath, remoteName;
  if (isType(options, String)) {
    options = {
      modulePath: arguments[0],
      branchName: arguments[1],
      remoteName: arguments[2]
    };
  }
  assertTypes(options, optionTypes);
  modulePath = options.modulePath, branchName = options.branchName, remoteName = options.remoteName;
  return exec("git branch -D " + branchName, {
    cwd: modulePath
  }).then(function() {
    if (!remoteName) {
      return;
    }
    return exec("git push " + remoteName + " --delete " + branchName, {
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
    lines = error.message.split(log.ln);
    expected = "fatal: '" + branchName + "' does not appear to be a git repository";
    if (lines[0] === expected) {
      throw Error("The given remote repository does not exist!");
    }
    throw error;
  });
};

//# sourceMappingURL=../../map/src/removeBranch.map
