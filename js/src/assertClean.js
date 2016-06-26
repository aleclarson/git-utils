var assertType, exec, git, log, prompt;

assertType = require("assertType");

prompt = require("prompt");

exec = require("exec");

log = require("log");

git = {
  getBranch: require("./getBranch"),
  isClean: require("./isClean"),
  pushStash: require("./pushStash")
};

module.exports = function(modulePath) {
  assertType(modulePath, String);
  return git.isClean(modulePath).then(function(clean) {
    if (clean) {
      return;
    }
    return git.getBranch(modulePath).then(function(branchName) {
      var moduleName, shouldStash;
      if (branchName === null) {
        throw Error("An initial commit must exist!");
      }
      moduleName = lotus.relative(modulePath);
      log.moat(1);
      log.red(moduleName + "/" + branchName);
      log.white(" has uncommitted changes!");
      log.moat(1);
      log.gray.dim("Want to call ");
      log.yellow("git stash");
      log.gray.dim("?");
      shouldStash = prompt.sync({
        parseBool: true
      });
      log.moat(1);
      if (!shouldStash) {
        throw Error("The current branch has uncommitted changes!");
      }
      return git.pushStash(modulePath);
    });
  });
};

//# sourceMappingURL=../../map/src/assertClean.map
