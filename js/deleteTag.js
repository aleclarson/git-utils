var assertType, assertTypes, exec, git, optionTypes;

assertTypes = require("assertTypes");

assertType = require("assertType");

exec = require("exec");

git = require("./core");

optionTypes = {
  remote: String.Maybe
};

module.exports = git.deleteTag = function(modulePath, tagName, options) {
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

//# sourceMappingURL=map/deleteTag.map
