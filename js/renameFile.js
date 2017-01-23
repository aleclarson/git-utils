var assertType, exec, git;

assertType = require("assertType");

exec = require("exec");

git = require("./core");

module.exports = git.renameFile = function(modulePath, oldName, newName) {
  var rootLength;
  assertType(modulePath, String);
  assertType(oldName, String);
  assertType(newName, String);
  rootLength = modulePath.length;
  if (oldName[0] === "/") {
    if (modulePath !== oldName.slice(0, rootLength)) {
      throw Error("'oldName' must be a descendant of 'modulePath'!");
    }
    oldName = oldName.slice(rootLength + 1);
  }
  if (newName[0] === "/") {
    if (modulePath !== newName.slice(0, rootLength)) {
      throw Error("'newName' must be a descendant of 'modulePath'!");
    }
    newName = newName.slice(rootLength + 1);
  }
  return exec.async("git mv", [oldName, newName], {
    cwd: modulePath
  });
};

//# sourceMappingURL=map/renameFile.map
