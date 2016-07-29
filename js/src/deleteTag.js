var assertType, assertTypes, exec, optionTypes;

assertTypes = require("assertTypes");

assertType = require("assertType");

exec = require("exec");

optionTypes = {
  remote: String.Maybe
};

module.exports = function(modulePath, tagName, options) {
  if (options == null) {
    options = {};
  }
  assertType(modulePath, String);
  assertType(tagName, String);
  assertTypes(options, optionTypes);
  return exec.async("git tag -d " + tagName, {
    cwd: modulePath
  }).then(function() {
    if (!options.remote) {
      return;
    }
    return exec.async("git push " + options.remote + " :" + tagName, {
      cwd: modulePath
    });
  });
};

//# sourceMappingURL=../../map/src/deleteTag.map
