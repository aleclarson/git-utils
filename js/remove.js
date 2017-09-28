var assertValid, exec, git, optionTypes;

assertValid = require("assertValid");

exec = require("exec");

git = require("./core");

optionTypes = {
  cached: "boolean?",
  recursive: "boolean?"
};

module.exports = git.remove = function(modulePath, files, options) {
  var args;
  if (options == null) {
    options = {};
  }
  assertValid(modulePath, "string");
  assertValid(files, "string|array");
  assertValid(options, optionTypes);
  args = [];
  if (options.recursive) {
    args.push("-r");
  }
  if (options.cached) {
    args.push("--cached");
  }
  return exec.async("git rm", args.concat(files), {
    cwd: modulePath
  });
};
