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
