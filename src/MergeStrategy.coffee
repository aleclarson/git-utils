
inArray = require "in-array"
valido = require "valido"

values = ["ours", "theirs"]
module.exports = valido
  test: (value) -> inArray values, value
  error: -> Error "Invalid merge strategy"
