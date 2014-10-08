var editor = require('./editor');

var initializeManyAction = function() {
  $('.forma-many-action').click(function() {
    // appending new editor
    var html = $(this).children('script').html();
    var $manyFields = $($(this).parents('.forma-many-fields')[0]);
    var $manyEditors = $($manyFields.children('.forma-many-editors')[0]);
    $manyEditors.append( html );

    // initialize fields
    $manyEditors = $($manyFields.children('.forma-many-editors')[0]);
    var $last = $manyEditors.find('.forma-many-field').last();
    editor.selectize2( $last.find('.forma-combo2-field') );
  });
};

module.exports = {
  startup: function(opts) {
    initializeManyAction();
  }
};
