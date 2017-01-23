var resetBranch, revertCommit;

resetBranch = require("./resetBranch");

revertCommit = function(modulePath) {
  return resetBranch(modulePath, "HEAD^").fail(function(error) {
    if (/^fatal: ambiguous argument/.test(error.message)) {
      return resetBranch(modulePath, null);
    }
    throw error;
  });
};

module.exports = revertCommit;

//# sourceMappingURL=map/revert.map
