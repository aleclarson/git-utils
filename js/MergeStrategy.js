var Maybe, MergeStrategy, OneOf;

Maybe = require("Maybe");

OneOf = require("OneOf");

MergeStrategy = OneOf("MergeStrategy", ["ours", "theirs"]);

MergeStrategy.Maybe = Maybe(MergeStrategy);

module.exports = MergeStrategy;

//# sourceMappingURL=map/MergeStrategy.map
