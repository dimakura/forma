var editor = require('./editor');

var afterEditorAdded = function() {
  var $manyFields = $($(this).parents('.forma-many-fields')[0]);
  var $manyEditors = $($manyFields.children('.forma-many-editors')[0]);
  var $last = $manyEditors.find('.forma-many-field').last();
  editor.selectize2( $last.find('.forma-combo2-field') );
};

var initManyAddItemAction = function() {
  var lastId = 1000;
  $('.forma-many-action').click(function(evt) {
    evt.preventDefault();

    // appending new editor
    var html = $(this).children('script').html();
    html = html.toString().replace(/\[0\]/g, '[' + (lastId++) + ']');
    var $manyFields = $($(this).parents('.forma-many-fields')[0]);
    var $manyEditors = $($manyFields.children('.forma-many-editors')[0]);
    $manyEditors.append( html );

    // reinitialize listeners -- TODO: REMOVE THIS!!!
    afterEditorAdded.call(this);
  });
};

// remove action initialization
var initManyRemoveItemAction = function(selector) {
  $('.forma-many-fields').delegate('.forma-many-field-remove', 'click', function(evt) {
    evt.preventDefault();

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
