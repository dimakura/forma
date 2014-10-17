require=(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
/**
 * Makes this element apear like in waiting state.
 */
var setWaiting = function(el) {
  if ( el.jquery ) { el = el[0]; }
  if ( ! el['forma-waiting'] ) {
    el['forma-waiting'] = true;
    el.innerHTML = el.innerHTML + '...';
    el.disabled = true;
  }
};

var initFormWaitOnSubmit = function() {
  $('form').submit(function() {
    setWaiting( $(this).find('[type=submit]') );
  });
};

var selectize2 = function(el) {
  el.select2({ allowClear: true, minimumInputLength: 2 });
};

/**
 * Initialize Select2.
 */
var initSelect2ComboBoxes = function() {
  selectize2( $('.forma-combo2-field') );
};

/**
 * Initialize Floara editor.
 */
var initFloaraEditor = function() {
  //var fields = $('.forma-floara-field');
  //fields.editable({ inlineMode: false });
};

module.exports = {
  startup: function(opts) {
    initFormWaitOnSubmit();
    initSelect2ComboBoxes();
    initFloaraEditor();
    // add other initializations above this line
  },

  selectize2: selectize2,
};

},{}],2:[function(require,module,exports){
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

},{"./editor":1}],"forma":[function(require,module,exports){
var editor = require('./editor');
var many = require('./many');

var startup = function(opts) {
  editor.startup( opts );
  many.startup( opts );
};

module.exports = {
  startup: startup
};

},{"./editor":1,"./many":2}]},{},[]);
