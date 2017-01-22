var MergeStrategy, Promise, Random, assertType, assertTypes, fs, git, isType, log, optionTypes, path, sync;

assertTypes = require("assertTypes");

assertType = require("assertType");

Promise = require("Promise");

Random = require("random");

isType = require("isType");

path = require("path");

sync = require("sync");

log = require("log");

fs = require("io/sync");

MergeStrategy = require("./MergeStrategy");

git = {
  addBranch: require("./addBranch"),
  commit: require("./commit"),
  deleteBranch: require("./deleteBranch"),
  deleteFile: require("./deleteFile"),
  getBranch: require("./getBranch"),
  isClean: require("./isClean"),
  pick: require("./pick"),
  mergeBranch: require("./mergeBranch"),
  renameFile: require("./renameFile"),
  resetBranch: require("./resetBranch"),
  setBranch: require("./setBranch"),
  stageFiles: require("./stageFiles")
};

optionTypes = {
  ours: String.Maybe,
  theirs: String,
  rename: Object,
  unlink: Array,
  merge: Object,
  strategy: MergeStrategy.Maybe,
  verbose: Boolean.Maybe
};

module.exports = function(modulePath, options) {
  var mergedCount, mergedPaths, renamedCount, renamedPaths, state, unlinkedCount, unlinkedPaths;
  assertType(modulePath, String);
  assertTypes(options, optionTypes);
  if (options.ours == null) {
    options.ours = modulePath;
  }
  renamedPaths = options.rename;
  renamedCount = Object.keys(renamedPaths).length;
  unlinkedPaths = options.unlink;
  unlinkedCount = unlinkedPaths.length;
  mergedPaths = options.merge;
  mergedCount = Object.keys(mergedPaths).length;
  if (!(renamedCount + unlinkedCount + mergedCount)) {
    return Promise();
  }
  state = {
    startBranch: null,
    tmpBranch: Random.id(),
    renameCommit: null,
    mergeCommit: null
  };
  return git.isClean(modulePath).assert("The current branch cannot have any uncommitted changes!").then(function() {
    return git.getBranch(modulePath).then(function(currentBranch) {
      return state.startBranch = currentBranch;
    });
  }).then(function() {
    return git.addBranch(modulePath, state.tmpBranch);
  }).then(function() {
    return git.resetBranch(modulePath, null).then(function() {
      return git.stageFiles(modulePath, "*");
    }).then(function() {
      return git.commit(modulePath, "squash commit");
    });
  }).then(function() {
    return Promise.chain(renamedPaths, function(newPath, oldPath) {
      var newFile, oldFile;
      assertType(newPath, String);
      newFile = path.resolve(options.ours, newPath);
      if (fs.exists(newFile)) {
        throw Error("Cannot rename because another file is already named: '" + newFile + "'");
      }
      oldFile = path.resolve(options.ours, oldPath);
      if (options.verbose) {
        log.moat(1);
        log.green("rename ");
        log.white(oldFile);
        log.moat(0);
        log.green("    to ");
        log.white(newFile);
        log.moat(1);
      }
      return git.renameFile(modulePath, oldFile, newFile);
    }).then(function() {
      return Promise.chain(unlinkedPaths, function(filePath) {
        var ourFile;
        assertType(filePath, String);
        ourFile = path.resolve(options.ours, filePath);
        if (!fs.exists(ourFile)) {
          throw Error("Cannot unlink a file that does not exist: '" + ourFile + "'");
        }
        if (options.verbose) {
          log.moat(1);
          log.red("unlink ");
          log.white(ourFile);
          log.moat(1);
        }
        return git.deleteFile(modulePath, ourFile);
      });
    }).then(function() {
      return git.commit(modulePath, "rename commit");
    }).then(function(commit) {
      return state.renameCommit = commit;
    });
  }).then(function() {
    sync.each(mergedPaths, function(ourPath, theirPath) {
      var i, len, ourChild, ourFile, ref, theirChild, theirFile;
      if (ourPath === true) {
        ourPath = theirPath;
      }
      ourFile = path.resolve(options.ours, ourPath);
      if (!fs.exists(ourFile)) {
        return;
      }
      theirFile = path.resolve(options.theirs, theirPath);
      if (fs.isFile(ourFile)) {
        if (!fs.isFile(theirFile)) {
          throw Error("Expected a file: '" + theirFile + "'");
        }
        return fs.write(ourFile, "");
      }
      if (!fs.isDir(theirFile)) {
        throw Error("Expected a directory: '" + theirFile + "'");
      }
      ref = fs.match(path.join(theirFile, "**/*"));
      for (i = 0, len = ref.length; i < len; i++) {
        theirChild = ref[i];
        if (fs.isDir(theirChild)) {
          continue;
        }
        ourChild = path.resolve(ourFile, path.relative(theirFile, theirChild));
        if (!fs.exists(ourChild)) {
          continue;
        }
        if (fs.isDir(ourChild)) {
          throw Error("Cannot use file to overwrite directory: '" + ourChild + "'");
        }
        fs.write(ourChild, "");
      }
    });
    return git.stageFiles(modulePath, "*").then(function() {
      return git.commit(modulePath, "clear files that will be merged into");
    });
  }).then(function() {
    sync.each(mergedPaths, function(ourPath, theirPath) {
      var ourFile, theirFile;
      if (ourPath === true) {
        ourPath = theirPath;
      }
      theirFile = path.resolve(options.theirs, theirPath);
      if (!fs.exists(theirFile)) {
        throw Error("Cannot merge a file that does not exist: '" + theirFile + "'");
      }
      ourFile = path.resolve(options.ours, ourPath);
      if (options.verbose) {
        log.moat(1);
        log.yellow("merge ");
        log.white(theirFile);
        log.moat(0);
        log.yellow(" into ");
        log.white(ourFile);
        log.moat(1);
      }
      return fs.copy(theirFile, ourFile, {
        recursive: true,
        force: true
      });
    });
    return git.stageFiles(modulePath, "*").then(function() {
      return git.commit(modulePath, "merge commit");
    }).then(function(commit) {
      return state.mergeCommit = commit;
    });
  }).always(function() {
    return git.setBranch(modulePath, state.startBranch, {
      force: true
    });
  }).then(function() {
    return git.pick(modulePath, state.renameCommit);
  }).then(function() {
    return git.pick(modulePath, {
      from: state.mergeCommit + "^",
      to: state.mergeCommit
    });
  }).always(function() {
    return git.deleteBranch(modulePath, state.tmpBranch);
  });
};

//# sourceMappingURL=map/mergeFiles.map
