valido = require "valido"

values = ["ours", "theirs"]
module.exports = valido
  test: (value) -> values.includes value
  error: -> Error "Invalid merge strategy"
