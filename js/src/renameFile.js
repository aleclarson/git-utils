var assertTypes, exec, isType, optionTypes, path;

assertTypes = require("assertTypes");

isType = require("isType");

exec = require("exec");

path = require("path");

optionTypes = {
  modulePath: String,
  oldName: String,
  newName: String
};

module.exports = function(options) {
  var modulePath, newName, oldName, rootLength;
  if (isType(options, String)) {
    options = {
      modulePath: arguments[0],
      oldName: arguments[1],
      newName: arguments[2]
    };
  }
  assertTypes(options, optionTypes);
  modulePath = options.modulePath, oldName = options.oldName, newName = options.newName;
  rootLength = modulePath.length;
  if (oldName[0] === "/") {
    assert(oldName.slice(0, rootLength) === modulePath, "'oldName' must be a descendant of 'modulePath'!");
    oldName = oldName.slice(rootLength + 1);
  }
  if (newName[0] === "/") {
    assert(newName.slice(0, rootLength) === modulePath, "'newName' must be a descendant of 'modulePath'!");
    newName = newName.slice(rootLength + 1);
  }
  return exec("git mv", [oldName, newName], {
    cwd: modulePath
  });
};

//# sourceMappingURL=../../map/src/renameFile.map
