// Generated by CoffeeScript 1.12.4
var inArray, valido, values;

inArray = require("in-array");

valido = require("valido");

values = ["ours", "theirs"];

module.exports = valido({
  test: function(value) {
    return inArray(values, value);
  },
  error: function() {
    return Error("Invalid merge strategy");
  }
});
