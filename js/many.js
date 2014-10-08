var editor = require('./editor');

var afterEditorAdded = function() {
  var $manyFields = $($(this).parents('.forma-many-fields')[0]);
  var $manyEditors = $($manyFields.children('.forma-many-editors')[0]);
  var $last = $manyEditors.find('.forma-many-field').last();
  editor.selectize2( $last.find('.forma-combo2-field') );
};

var initManyAddItemAction = function() {
  $('.forma-many-action').click(function() {
    // appending new editor
    var html = $(this).children('script').html();
    var $manyFields = $($(this).parents('.forma-many-fields')[0]);
    var $manyEditors = $($manyFields.children('.forma-many-editors')[0]);
    $manyEditors.append( html );

    // reinitialize listeners
    afterEditorAdded.call(this);
  });
};

// remove action initialization
var initManyRemoveItemAction = function(selector) {
  $('.forma-many-fields').delegate('.forma-many-field-remove', 'click', function() {
    $field = $(this).parents('.forma-many-field');
    var id = $field.find('.forma-id').val();
    if ( id ) {
      $field.find('.forma-destroy').val('true');
      $field.hide();
    } else {
      $field.remove();
    }
  });
};

module.exports = {
  startup: function(opts) {
    initManyAddItemAction();
    initManyRemoveItemAction();
  }
};
