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
  assertRepo: {
    lazy: function() {
      return require("./assertRepo");
    }
  },
  blame: {
    lazy: function() {
      return require("./blame");
    }
  },
  commit: {
    lazy: function() {
      return require("./commit");
    }
  },
  deleteBranch: {
    lazy: function() {
      return require("./deleteBranch");
    }
  },
  deleteFile: {
    lazy: function() {
      return require("./deleteFile");
    }
  },
  deleteTag: {
    lazy: function() {
      return require("./deleteTag");
    }
  },
  diff: {
    lazy: function() {
      return require("./diff");
    }
  },
  diffConflicts: {
    lazy: function() {
      return require("./diffConflicts");
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
  getBranch: {
    lazy: function() {
      return require("./getBranch");
    }
  },
  getBranches: {
    lazy: function() {
      return require("./getBranches");
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
  popStash: {
    lazy: function() {
      return require("./popStash");
    }
  },
  pushBranch: {
    lazy: function() {
      return require("./pushBranch");
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
  renameFile: {
    lazy: function() {
      return require("./renameFile");
    }
  },
  resetBranch: {
    lazy: function() {
      return require("./resetBranch");
    }
  },
  resetFiles: {
    lazy: function() {
      return require("./resetFiles");
    }
  },
  setBranch: {
    lazy: function() {
      return require("./setBranch");
    }
  },
  stageFiles: {
    lazy: function() {
      return require("./stageFiles");
    }
  },
  unstageFiles: {
    lazy: function() {
      return require("./unstageFiles");
    }
  }
});

//# sourceMappingURL=map/index.map
