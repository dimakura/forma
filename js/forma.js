var editor = require('./editor');
var many = require('./many');

var startup = function(opts) {
  editor.startup( opts );
  many.startup( opts );
};

module.exports = {
  startup: startup
};
