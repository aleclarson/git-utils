var assertType, fs, git, path;

assertType = require("assertType");

path = require("path");

fs = require("io/sync");

git = require("./core");

module.exports = git.isRepo = function(modulePath) {
  assertType(modulePath, String);
  if (modulePath[0] === ".") {
    modulePath = path.resolve(process.cwd(), modulePath);
  } else if (!path.isAbsolute(modulePath)) {
    modulePath = path.resolve(modulePath);
  }
  modulePath = path.join(modulePath, ".git");
  return fs.isDir(modulePath);
};

//# sourceMappingURL=map/isRepo.map
