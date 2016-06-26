var ArrayOf, MergeStrategy, Promise, Random, Shape, assert, assertType, assertTypes, exec, fs, git, isType, log, optionTypes, path, sync;

assertTypes = require("assertTypes");

assertType = require("assertType");

ArrayOf = require("ArrayOf");

Promise = require("Promise");

Random = require("random");

isType = require("isType");

assert = require("assert");

Shape = require("Shape");

exec = require("exec");

path = require("path");

sync = require("sync");

log = require("log");

fs = require("io/sync");

MergeStrategy = require("./MergeStrategy");

git = {
  getBranch: require("./getBranch"),
  setBranch: require("./setBranch"),
  removeBranch: require("./removeBranch"),
  assertClean: require("./assertClean"),
  mergeBranch: require("./mergeBranch"),
  removeFile: require("./removeFile"),
  renameFile: require("./renameFile"),
  addBranch: require("./addBranch"),
  pushCommit: require("./pushCommit"),
  stageAll: require("./stageAll")
};

optionTypes = {
  modulePath: String,
  ours: String.Maybe,
  theirs: String,
  files: Array,
  strategy: MergeStrategy.Maybe,
  verbose: Boolean.Maybe
};

module.exports = function(options) {
  var files, modulePath, ours, strategy, theirs, verbose;
  assertTypes(options, optionTypes);
  modulePath = options.modulePath, ours = options.ours, theirs = options.theirs, files = options.files, strategy = options.strategy, verbose = options.verbose;
  if (!files.length) {
    return Promise();
  }
  if (ours == null) {
    ours = modulePath;
  }
  return git.assertClean(modulePath).then(function() {
    return git.getBranch(modulePath);
  }).then(function(currentBranch) {
    var tmpBranch;
    tmpBranch = Random.id();
    return git.addBranch(modulePath, tmpBranch).then(function() {
      if (verbose) {
        log.moat(1);
        log.cyan("Merging files...");
        log.moat(1);
      }
      return Promise.chain(files, function(file, index) {
        var ourFile, renamedFile, theirFile;
        if (isType(file, String)) {
          file = {
            merge: file
          };
        } else if (file.unlink) {
          ourFile = path.resolve(ours, file.unlink);
          assert(fs.isFile(ourFile), "Cannot unlink a file that does not exist: '" + ourFile + "'");
          if (verbose) {
            log.moat(1);
            log.red("unlink ");
            log.white(ourFile);
            log.moat(1);
          }
          return git.removeFile(modulePath, ourFile);
        }
        if (file.rename) {
          ourFile = path.resolve(ours, file.to);
          assert(!fs.isFile(ourFile), "Cannot rename because another file is already named: '" + ourFile + "'");
          renamedFile = path.resolve(ours, file.rename);
          if (verbose) {
            log.moat(1);
            log.green("rename ");
            log.white(renamedFile);
            log.moat(0);
            log.green("    to ");
            log.white(ourFile);
            log.moat(1);
          }
          return git.renameFile(modulePath, renamedFile, ourFile);
        }
        if (file.merge) {
          theirFile = path.resolve(theirs, file.merge);
          assert(fs.isFile(theirFile), "Cannot merge a file that does not exist: '" + theirFile + "'");
          ourFile = path.resolve(ours, file.merge);
          if (verbose) {
            log.moat(1);
            log.yellow("merge ");
            log.white(theirFile);
            log.moat(0);
            log.yellow(" into ");
            log.white(ourFile);
            log.moat(1);
          }
          fs.copy(theirFile, ourFile);
        }
      });
    }).then(function() {
      if (verbose) {
        log.moat(1);
        log.cyan("Staging changes...");
        log.moat(1);
      }
      return git.stageAll(modulePath).then(function() {
        return git.pushCommit(modulePath, Random.id());
      });
    }).always(function() {
      return git.setBranch(modulePath, currentBranch);
    }).then(function() {
      return git.mergeBranch({
        modulePath: modulePath,
        theirs: tmpBranch,
        strategy: strategy
      }).then(function() {
        if (!verbose) {
          return;
        }
        log.moat(1);
        log.cyan("Files merged successfully!");
        return log.moat(1);
      });
    }).always(function() {
      return git.removeBranch(modulePath, tmpBranch);
    });
  });
};

//# sourceMappingURL=../../map/src/mergeFiles.map
