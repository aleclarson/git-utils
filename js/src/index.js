var define;

define = require("define");

define(exports, {
  addBranch: {
    lazy: function() {
      return require("./addBranch");
    }
  },
  addCommit: {
    lazy: function() {
      return require("./addCommit");
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
  changeBranch: {
    lazy: function() {
      return require("./changeBranch");
    }
  },
  diff: {
    lazy: function() {
      return require("./diff");
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
  getCurrentBranch: {
    lazy: function() {
      return require("./getCurrentBranch");
    }
  },
  getLatestCommit: {
    lazy: function() {
      return require("./getLatestCommit");
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
  hasChanges: {
    lazy: function() {
      return require("./hasChanges");
    }
  },
  isRepo: {
    lazy: function() {
      return require("./isRepo");
    }
  },
  mergeBranch: {
    lazy: function() {
      return require("./mergeBranch");
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
  pushChanges: {
    lazy: function() {
      return require("./pushChanges");
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
  removeTag: {
    lazy: function() {
      return require("./removeTag");
    }
  },
  stageAll: {
    lazy: function() {
      return require("./stageAll");
    }
  },
  undoLatestCommit: {
    lazy: function() {
      return require("./undoLatestCommit");
    }
  },
  unstageAll: {
    lazy: function() {
      return require("./unstageAll");
    }
  }
});

//# sourceMappingURL=../../map/src/index.map
