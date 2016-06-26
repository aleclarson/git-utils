var define;

define = require("define");

define(exports, {
  addBranch: {
    lazy: function() {
      return require("./addBranch");
    }
  },
  addTag: {
    lazy: function() {
      return require("./addTag");
    }
  },
  assertClean: {
    lazy: function() {
      return require("./assertClean");
    }
  },
  assertRepo: {
    lazy: function() {
      return require("./assertRepo");
    }
  },
  assertStaged: {
    lazy: function() {
      return require("./assertStaged");
    }
  },
  blame: {
    lazy: function() {
      return require("./blame");
    }
  },
  diff: {
    lazy: function() {
      return require("./diff");
    }
  },
  findConflicts: {
    lazy: function() {
      return require("./findConflicts");
    }
  },
  findVersion: {
    lazy: function() {
      return require("./findVersion");
    }
  },
  getBranches: {
    lazy: function() {
      return require("./getBranches");
    }
  },
  getBranch: {
    lazy: function() {
      return require("./getBranch");
    }
  },
  getHead: {
    lazy: function() {
      return require("./getHead");
    }
  },
  getRemotes: {
    lazy: function() {
      return require("./getRemotes");
    }
  },
  getStatus: {
    lazy: function() {
      return require("./getStatus");
    }
  },
  getTags: {
    lazy: function() {
      return require("./getTags");
    }
  },
  getVersions: {
    lazy: function() {
      return require("./getVersions");
    }
  },
  hasBranch: {
    lazy: function() {
      return require("./hasBranch");
    }
  },
  isClean: {
    lazy: function() {
      return require("./isClean");
    }
  },
  isRepo: {
    lazy: function() {
      return require("./isRepo");
    }
  },
  isStaged: {
    lazy: function() {
      return require("./isStaged");
    }
  },
  mergeBranch: {
    lazy: function() {
      return require("./mergeBranch");
    }
  },
  mergeFiles: {
    lazy: function() {
      return require("./mergeFiles");
    }
  },
  pick: {
    lazy: function() {
      return require("./pick");
    }
  },
  popCommit: {
    lazy: function() {
      return require("./popCommit");
    }
  },
  popStash: {
    lazy: function() {
      return require("./popStash");
    }
  },
  pushCommit: {
    lazy: function() {
      return require("./pushCommit");
    }
  },
  pushHead: {
    lazy: function() {
      return require("./pushHead");
    }
  },
  pushStash: {
    lazy: function() {
      return require("./pushStash");
    }
  },
  pushTags: {
    lazy: function() {
      return require("./pushTags");
    }
  },
  pushVersion: {
    lazy: function() {
      return require("./pushVersion");
    }
  },
  removeBranch: {
    lazy: function() {
      return require("./removeBranch");
    }
  },
  removeFile: {
    lazy: function() {
      return require("./removeFile");
    }
  },
  removeTag: {
    lazy: function() {
      return require("./removeTag");
    }
  },
  renameFile: {
    lazy: function() {
      return require("./renameFile");
    }
  },
  resetFile: {
    lazy: function() {
      return require("./resetFile");
    }
  },
  setBranch: {
    lazy: function() {
      return require("./setBranch");
    }
  },
  setHead: {
    lazy: function() {
      return require("./setHead");
    }
  },
  stageAll: {
    lazy: function() {
      return require("./stageAll");
    }
  },
  unstageAll: {
    lazy: function() {
      return require("./unstageAll");
    }
  }
});

//# sourceMappingURL=../../map/src/index.map
