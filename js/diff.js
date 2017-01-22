var assertType, exec, find, os;

find = require("finder").find;

assertType = require("assertType");

exec = require("exec");

os = require("os");

module.exports = function(modulePath, firstCommit, lastCommit) {
  if (lastCommit == null) {
    lastCommit = "HEAD";
  }
  assertType(modulePath, String);
  assertType(firstCommit, String);
  assertType(lastCommit, String);
  return exec.async("git diff --raw " + firstCommit + ".." + lastCommit, {
    cwd: modulePath
  }).then(function(stdout) {
    var lines, regex;
    lines = stdout.split(os.EOL);
    regex = /^:[0-9]{6} [0-9]{6} [0-9a-z]{7}\.\.\. [0-9a-z]{7}\.\.\. (.)\t(.+)$/;
    return lines.map(function(line) {
      var path, status;
      status = find(regex, line, 1);
      path = find(regex, line, 2);
      return {
        status: status,
        path: path
      };
    });
  }).fail(function(error) {
    if (/unknown revision or path not in the working tree/.test(error.message)) {
      throw Error("Unknown revision (or path not in the working tree)!");
    }
    throw error;
  });
};

//# sourceMappingURL=map/diff.map
