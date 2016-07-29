var assert, assertType, exec;

assertType = require("assertType");

assert = require("assert");

exec = require("exec");

module.exports = function(modulePath, oldName, newName) {
  var rootLength;
  assertType(modulePath, String);
  assertType(oldName, String);
  assertType(newName, String);
  rootLength = modulePath.length;
  if (oldName[0] === "/") {
    assert(oldName.slice(0, rootLength) === modulePath, "'oldName' must be a descendant of 'modulePath'!");
    oldName = oldName.slice(rootLength + 1);
  }
  if (newName[0] === "/") {
    assert(newName.slice(0, rootLength) === modulePath, "'newName' must be a descendant of 'modulePath'!");
    newName = newName.slice(rootLength + 1);
  }
  return exec.async("git mv", [oldName, newName], {
    cwd: modulePath
  });
};

//# sourceMappingURL=../../map/src/renameFile.map
