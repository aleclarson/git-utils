var fs, path;

path = require("path");

fs = require("io/sync");

module.exports = function(modulePath) {
  if (modulePath[0] === ".") {
    modulePath = path.resolve(process.cwd(), modulePath);
  } else if (modulePath[0] !== "/") {
    modulePath = lotus.path + "/" + modulePath;
  }
  modulePath = path.join(modulePath, ".git");
  return fs.isDir(modulePath);
};

//# sourceMappingURL=../../map/src/isRepo.map
