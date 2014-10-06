require=(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){

var initKnownActions = function() {
  $('.forma-action').click(function(evt) {
    var js = $(this).attr('data-js')

    // returning back in history
    if ( js === 'back' ) {
      evt.preventDefault();
      window.history.back();
    }

    // XXX: any other actions?
  });
};

module.exports = {
  startup: function(opts) {
    initKnownActions();
  }
};

},{}],2:[function(require,module,exports){
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

var initSelect2ComboBoxes = function() {
  $('.forma-combo2-field').select2({
    allowClear: true
  });
};

module.exports = {
  startup: function(opts) {
    initFormWaitOnSubmit();
    initSelect2ComboBoxes();
    // add other initializations above this line
  }
};

},{}],"forma":[function(require,module,exports){
var editor = require('./editor');
var actions = require('./actions');

var startup = function(opts) {

  editor.startup( opts );
  actions.startup( opts );

};

module.exports = {
  startup: startup
};

},{"./actions":1,"./editor":2}]},{},[]);
