const GlobalIndexable = require("./global_indexable.js");
const CustomColItem = require("./expression_items/custom_col.js");
const CustomCol = require("./definition_items/custom_col.js");
module.exports = class CustomCols extends GlobalIndexable {
    constructor () {
        super('customcol', CustomCol, CustomColItem);
    }
    getEmptyValue(id, options) {
        let _options = options ?? {};
        return new CustomCol(id, _options.commit ?? false, _options.stage ?? 0);
    }
    getCommitNames() {
        return this.getCommits().map(x => x.name);
    }
    getCommits() {
        return this.getValues().map(x => x.commit).filter((commit, index, commits) => commits.indexOf(commit) === index);
    }
    getColsByCommit(commit) {
        return this.getValues().filter(x => x.commit === commit);
    }
}
