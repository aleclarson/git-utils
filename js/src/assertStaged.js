var isStaged;

isStaged = require("./isStaged");

module.exports = function(modulePath) {
  return isStaged(modulePath).then(function(staged) {
    if (staged) {
      return;
    }
    throw Error("No changes are staged!");
  });
};

//# sourceMappingURL=../../map/src/assertStaged.map
