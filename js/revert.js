var git;

require("./resetBranch");

git = require("./core");

module.exports = git.revert = function(modulePath) {
  return git.resetBranch(modulePath, "HEAD^").fail(function(error) {
    if (/^fatal: ambiguous argument/.test(error.message)) {
      return git.resetBranch(modulePath, null);
    }
    throw error;
  });
};

//# sourceMappingURL=map/revert.map
