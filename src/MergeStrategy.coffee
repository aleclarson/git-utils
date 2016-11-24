
Maybe = require "Maybe"
OneOf = require "OneOf"

MergeStrategy = OneOf "MergeStrategy", [ "ours", "theirs" ]

module.exports = MergeStrategy
