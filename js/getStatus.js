var Finder, assertType, assertTypes, escapeStringRegExp, exec, findNewPath, findPath, findStagingStatus, findWorkingStatus, getLocalStatus, getRemoteStatus, git, isType, optionTypes, ref, statusMap;

escapeStringRegExp = require("escape-string-regexp");

assertTypes = require("assertTypes");

assertType = require("assertType");

Finder = require("finder");

isType = require("isType");

exec = require("exec");

git = require("./core");

optionTypes = {
  raw: Boolean.Maybe,
  remote: Boolean.Maybe
};

module.exports = git.getStatus = function(modulePath, options) {
  if (options == null) {
    options = {};
  }
  assertType(modulePath, String);
  assertTypes(options, optionTypes);
  if (options.remote) {
    return getRemoteStatus(modulePath);
  } else {
    return getLocalStatus(modulePath, options);
  }
};

getRemoteStatus = function(modulePath) {
  return exec.async("git status --short --branch", {
    cwd: modulePath
  }).then(function(stdout) {
    var findAhead, findBehind, findRemoteBranch;
    stdout = stdout.split("\n")[0];
    findRemoteBranch = Finder(/\.\.\.([^\s]+)/);
    findAhead = Finder("ahead ([0-9]+)");
    findBehind = Finder("behind ([0-9]+)");
    return {
      branch: findRemoteBranch(stdout),
      ahead: Number(findAhead(stdout)),
      behind: Number(findBehind(stdout))
    };
  });
};

getLocalStatus = function(modulePath, options) {
  return exec.async("git status --porcelain", {
    cwd: modulePath
  }).then(function(stdout) {
    var base, base1, file, files, i, len, line, ref, results, stagingStatus, status, workingStatus;
    if (options.raw) {
      return stdout;
    }
    results = {
      staged: {},
      tracked: {},
      untracked: [],
      unmerged: []
    };
    if (stdout.length === 0) {
      return results;
    }
    ref = stdout.split("\n");
    for (i = 0, len = ref.length; i < len; i++) {
      line = ref[i];
      file = {
        path: findPath(line)
      };
      stagingStatus = findStagingStatus(line);
      workingStatus = findWorkingStatus(line);
      if (stagingStatus === "C") {
        stagingStatus = "A";
        file.path = findNewPath(line);
      }
      if ((stagingStatus === "?") && (workingStatus === "?")) {
        results.untracked.push(file);
        continue;
      }
      if ((stagingStatus === "U") && (workingStatus === "U")) {
        results.unmerged.push(file);
        continue;
      }
      if ((stagingStatus === "R") || (workingStatus === "R")) {
        file.newPath = findNewPath(line);
        file.oldPath = file.path;
        delete file.path;
      }
      if ((stagingStatus !== " ") && (stagingStatus !== "?")) {
        status = statusMap[stagingStatus];
        if (!status) {
          throw Error("Unrecognized status!");
        }
        files = (base = results.staged)[status] != null ? base[status] : base[status] = [];
        files.push(file);
      }
      if ((workingStatus !== " ") && (workingStatus !== "?")) {
        status = statusMap[workingStatus];
        if (!status) {
          throw Error("Unrecognized status!");
        }
        files = (base1 = results.tracked)[status] != null ? base1[status] : base1[status] = [];
        files.push(file);
      }
    }
    return results;
  });
};

statusMap = {
  "A": "added",
  "C": "copied",
  "R": "renamed",
  "M": "modified",
  "D": "deleted",
  "U": "unmerged",
  "?": "untracked"
};

ref = (function() {
  var charRegex, chars, regex;
  chars = Object.keys(statusMap);
  charRegex = "([" + escapeStringRegExp(chars.join("")) + "\\s]{1})";
  regex = RegExp(["^[\\s]*", charRegex, charRegex, " ", "([^\\s]+)", "( -> ([^\\s]+))?"].join(""));
  return {
    findStagingStatus: Finder({
      regex: regex,
      group: 1
    }),
    findWorkingStatus: Finder({
      regex: regex,
      group: 2
    }),
    findPath: Finder({
      regex: regex,
      group: 3
    }),
    findNewPath: Finder({
      regex: regex,
      group: 5
    })
  };
})(), findStagingStatus = ref.findStagingStatus, findWorkingStatus = ref.findWorkingStatus, findPath = ref.findPath, findNewPath = ref.findNewPath;

//# sourceMappingURL=map/getStatus.map
