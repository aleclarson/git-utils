var Finder, assertTypes, findConflict, findMiddle, findOurs, findTheirs, fs, mergeFiles, optionTypes;

assertTypes = require("assertTypes");

Finder = require("finder");

fs = require("io/sync");

mergeFiles = require("./mergeFiles");

optionTypes = {
  code: String.Maybe,
  filePath: String.Maybe
};

module.exports = function(options) {
  var conflict, conflicts, offset;
  assertTypes(options, optionTypes);
  if (options.code == null) {
    options.code = fs.read(options.filePath);
  }
  conflicts = [];
  offset = 0;
  while (true) {
    conflict = findConflict(options.code, offset);
    if (!conflict) {
      break;
    }
    conflicts.push(conflict);
    offset = conflict.range.end;
  }
  return conflicts;
};

findOurs = Finder(/<<<<<<< ([^\n]*)\n/);

findMiddle = Finder(/=======\n/);

findTheirs = Finder(/>>>>>>> ([^\n]*)\n/);

findConflict = function(contents, startOffset) {
  var endOffset, middle, middleOffset, ours, theirs;
  ours = {};
  theirs = {};
  findOurs.target = contents;
  findOurs.offset = startOffset;
  ours.origin = findOurs.next();
  startOffset = findOurs.offset;
  findOurs.target = null;
  if (ours.origin == null) {
    return null;
  }
  findMiddle.target = contents;
  findMiddle.offset = startOffset;
  middle = findMiddle.next();
  middleOffset = findMiddle.offset;
  findMiddle.target = null;
  if (!middle) {
    return null;
  }
  findTheirs.target = contents;
  findTheirs.offset = middleOffset;
  theirs.origin = findTheirs.next();
  endOffset = findTheirs.offset;
  findTheirs.target = null;
  if (theirs.origin == null) {
    return null;
  }
  ours.code = contents.slice(startOffset, middleOffset - 8);
  theirs.code = contents.slice(middleOffset, endOffset - theirs.origin.length - 9);
  return {
    ours: ours,
    theirs: theirs,
    range: {
      start: startOffset - ours.origin.length - 9,
      end: endOffset
    }
  };
};

//# sourceMappingURL=map/findConflicts.map
