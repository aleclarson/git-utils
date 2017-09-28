// Generated by CoffeeScript 1.12.4
var assertValid, exec, git, isValid, optionTypes, os;

assertValid = require("assertValid");

isValid = require("isValid");

exec = require("exec");

os = require("os");

require("./getBranch");

git = require("./core");

optionTypes = {
  force: "boolean?",
  remote: "string?",
  branch: "string?",
  upstream: "boolean?",
  listener: "function?"
};

module.exports = git.pushBranch = function(modulePath, options) {
  if (options == null) {
    options = {};
  }
  assertValid(modulePath, "string");
  assertValid(options, optionTypes);
  return git.getBranch(modulePath).then(function(branch) {
    var args;
    if (branch === null) {
      throw Error("An initial commit must exist!");
    }
    args = [];
    if (options.force) {
      args.push("-f");
    }
    if (options.upstream) {
      args.push("-u");
    }
    args.push(options.remote || "origin");
    if (options.branch && branch !== options.branch) {
      args.push(branch + ":" + options.branch);
    } else {
      args.push(branch);
    }
    return exec.async("git push", args, {
      cwd: modulePath,
      listener: options.listener
    }).fail(function(error) {
      var regex;
      if (!options.force) {
        if (/\(non-fast-forward\)/.test(error.message)) {
          throw Error("Must force push to overwrite remote commits!");
        }
      }
      regex = RegExp("(\\+|\\s)[\\s]+([a-z0-9]{7})[\\.]{2,3}([a-z0-9]{7})[\\s]+(HEAD|" + branch + ")[\\s]+->[\\s]+" + branch);
      if (regex.test(error.message)) {
        return;
      }
      regex = RegExp("\\*[\\s]+\\[new branch\\][\\s]+" + branch + "[\\s]+->[\\s]+" + branch);
      if (regex.test(error.message)) {
        return;
      }
      throw error;
    });
  });
};
