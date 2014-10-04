
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
