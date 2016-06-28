var diffLines, findConflicts, fs, os;

diffLines = require("diff").diffLines;

fs = require("io/sync");

os = require("os");

findConflicts = require("./findConflicts");

module.exports = function(filePath, options) {
  var after, code, conflicts, merged, offset;
  if (options == null) {
    options = {};
  }
  code = fs.read(filePath);
  conflicts = findConflicts({
    code: code
  });
  if (!conflicts.length) {
    return null;
  }
  offset = 0;
  merged = conflicts.map(function(arg) {
    var before, chunk, conflict, i, len, ours, range, ref, resolveConflict, results, theirs;
    ours = arg.ours, theirs = arg.theirs, range = arg.range;
    results = [];
    before = code.slice(offset, range.start);
    if (before.trim().length) {
      results.push(before);
      offset = range.end;
    }
    conflict = [];
    resolveConflict = function() {
      if (!conflict.length) {
        return;
      }
      if (!conflict[0]) {
        conflict[0] = ["<<<<<<< ", ours.origin, os.EOL].join("");
      } else if (!conflict[1]) {
        conflict[1] = ["=======", os.EOL, ">>>>>>> ", theirs.origin, os.EOL].join("");
      }
      results.push(conflict.join(""));
      conflict.length = 0;
    };
    ref = diffLines(theirs.code, ours.code);
    for (i = 0, len = ref.length; i < len; i++) {
      chunk = ref[i];
      if (chunk.removed) {
        conflict[1] = ["=======", os.EOL, chunk.value, ">>>>>>> ", theirs.origin, os.EOL].join("");
      } else if (chunk.added) {
        conflict[0] = ["<<<<<<< ", ours.origin, os.EOL, chunk.value].join("");
        resolveConflict();
      } else {
        resolveConflict();
        results.push(chunk.value);
      }
    }
    return results.join("");
  });
  after = code.slice(offset);
  if (after.length) {
    merged.push(after);
  }
  code = merged.join("");
  if (options.overwrite !== false) {
    fs.write(filePath, code);
  }
  return code;
};

//# sourceMappingURL=../../map/src/diffConflicts.map
