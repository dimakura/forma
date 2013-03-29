(function() {

  function initilizeCollapsibleElement() {
    $('.ff-collapsible').click(function(evt) {
      var formElement = $(evt.target).parents('.ff-form');
      var formId = formElement.attr('id');
      var collapseSelector = '#' + formId + ' .ff-collapse';
      var formBodySelector = '#' + formId + ' .ff-form-body';
      var collapsed = $(collapseSelector).hasClass('ff-collapsed');
      if (collapsed) {
        $(collapseSelector).removeClass('ff-collapsed');
        $(formBodySelector).show();
      } else {
        $(collapseSelector).addClass('ff-collapsed');
        $(formBodySelector).hide();
      }
    });
  };

  $(function() {
    initilizeCollapsibleElement();
  });

})();