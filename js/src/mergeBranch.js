var Maybe, MergeStrategy, OneOf, assertClean, assertTypes, exec, optionTypes, setBranch;

assertTypes = require("assertTypes");

OneOf = require("OneOf");

Maybe = require("Maybe");

exec = require("exec");

MergeStrategy = require("./MergeStrategy");

setBranch = require("./setBranch");

assertClean = require("./assertClean");

optionTypes = {
  modulePath: String,
  ours: String.Maybe,
  theirs: String,
  strategy: Maybe(MergeStrategy)
};

module.exports = function(options) {
  var modulePath, ours, strategy, theirs;
  assertTypes(options, optionTypes);
  modulePath = options.modulePath, ours = options.ours, theirs = options.theirs, strategy = options.strategy;
  return assertClean(modulePath).then(function() {
    if (!ours) {
      return;
    }
    return setBranch(modulePath, ours);
  }).then(function() {
    var args;
    args = [theirs, "--no-commit"];
    if (strategy) {
      args.push("-X", strategy);
    }
    return exec("git merge", args, {
      cwd: modulePath
    });
  }).fail(function(error) {
    if (/Automatic merge went well/.test(error.message)) {
      return;
    }
    throw error;
  });
};

//# sourceMappingURL=../../map/src/mergeBranch.map
