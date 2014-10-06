var editor = require('./editor');

var startup = function(opts) {
  editor.startup( opts );
};

module.exports = {
  startup: startup
};
