var assertType, exec, log;

assertType = require("assertType");

exec = require("exec");

log = require("log");

module.exports = function(keyPath) {
  var args;
  assertType(keyPath, String.Maybe);
  args = keyPath ? ["--get", keyPath] : ["--list"];
  return exec.async("git config", args).then(function(stdout) {
    var config;
    if (keyPath) {
      return stdout;
    }
    config = Object.create(null);
    stdout.split(log.ln).forEach(function(entry) {
      var key, ref, value;
      ref = entry.split("="), key = ref[0], value = ref[1];
      return config[key] = value;
    });
    return config;
  });
};

//# sourceMappingURL=map/getConfig.map
