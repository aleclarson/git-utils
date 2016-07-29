var conflict, diffLines, findConflicts, fs, os;

diffLines = require("diff").diffLines;

fs = require("io/sync");

os = require("os");

findConflicts = require("./findConflicts");

module.exports = function(filePath, options) {
  var after, code, offset, results;
  if (options == null) {
    options = {};
  }
  code = fs.read(filePath);
  offset = 0;
  results = [];
  findConflicts({
    code: code
  }).forEach(function(arg) {
    var before, chunk, conflicted, i, len, ours, range, ref, theirs;
    ours = arg.ours, theirs = arg.theirs, range = arg.range;
    before = code.slice(offset, range.start);
    if (before.trim().length) {
      results.push(before);
      offset = range.end;
    }
    ref = diffLines(theirs.code, ours.code);
    for (i = 0, len = ref.length; i < len; i++) {
      chunk = ref[i];
      if (chunk.removed) {
        conflict[1] = ["=======", os.EOL, chunk.value, ">>>>>>> ", theirs.origin, os.EOL].join("");
        continue;
      }
      if (chunk.added) {
        conflict[0] = ["<<<<<<< ", ours.origin, os.EOL, chunk.value].join("");
        conflicted = conflict.resolve(ours, theirs);
        if (conflicted) {
          results.push(conflicted);
        }
        continue;
      }
      conflicted = conflict.resolve(ours, theirs);
      if (conflicted) {
        results.push(conflicted);
      }
      results.push(chunk.value);
    }
    conflicted = conflict.resolve(ours, theirs);
    if (conflicted) {
      return results.push(conflicted);
    }
  });
  after = code.slice(offset);
  if (after.length) {
    results.push(after);
  }
  if (options.overwrite !== false) {
    fs.write(filePath, results.join(""));
  }
  return results;
};

conflict = [];

conflict.resolve = function(ours, theirs) {
  var conflicted;
  if (!conflict.length) {
    return;
  }
  if (!conflict[0]) {
    conflict[0] = ["<<<<<<< ", ours.origin, os.EOL].join("");
  } else if (!conflict[1]) {
    conflict[1] = ["=======", os.EOL, ">>>>>>> ", theirs.origin, os.EOL].join("");
  }
  conflicted = conflict.join("");
  conflict.length = 0;
  return conflicted;
};

//# sourceMappingURL=../../map/src/diffConflicts.map
