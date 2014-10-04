var editor = require('./editor');
var actions = require('./actions');

var startup = function(opts) {

  editor.startup( opts );
  actions.startup( opts );

};

module.exports = {
  startup: startup
};
