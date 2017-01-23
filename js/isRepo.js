var assertType, fs, isRepo, path;

assertType = require("assertType");

path = require("path");

fs = require("io/sync");

isRepo = function(modulePath) {
  assertType(modulePath, String);
  if (modulePath[0] === ".") {
    modulePath = path.resolve(process.cwd(), modulePath);
  } else if (!path.isAbsolute(modulePath)) {
    modulePath = path.resolve(modulePath);
  }
  modulePath = path.join(modulePath, ".git");
  return fs.isDir(modulePath);
};

module.exports = isRepo;

//# sourceMappingURL=map/isRepo.map
