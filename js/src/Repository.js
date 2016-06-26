var Type, assert, getArgProp, git, type;

getArgProp = require("getArgProp");

assert = require("assert");

Type = require("Type");

git = require(".");

type = Type("GitRepository");

type.argumentTypes = {
  modulePath: String
};

type.defineFrozenValues({
  modulePath: getArgProp("modulePath")
});

type.initInstance(function(modulePath) {
  return assert(git.isRepo(modulePath), "Invalid repository path!");
});

type.defineMethods({
  addBranch: function(branchName) {
    return git.addBranch({
      modulePath: this.modulePath,
      branchName: branchName
    });
  },
  pushCommit: function(message) {
    return git.pushCommit({
      modulePath: this.modulePath,
      message: message
    });
  },
  addTag: function(tagName, force) {
    return git.addTag({
      modulePath: this.modulePath,
      tagName: tagName,
      force: force
    });
  }
});

module.exports = type.build();

//# sourceMappingURL=../../map/src/Repository.map
