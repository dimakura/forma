(function() {

  var initilizeCollapsibleElement = function() {
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

  var initializeTabs = function() {
    $('.ff-tabs-header li').click(function(evt) {
      var clickedTab = $(evt.target);
      if (!clickedTab.hasClass('ff-selected')) {
        var tabId = clickedTab.attr('data-tabid');
        var tabsHeader = clickedTab.parents('.ff-tabs-header');
        var selectedTab = tabsHeader.find('.ff-selected');
        var selectedId = selectedTab.attr('data-tabid');
        $('#' + selectedId).hide();
        selectedTab.removeClass('ff-selected');
        $('#' + tabId).show();
        clickedTab.addClass('ff-selected');
      }
    });
  };

  $(function() {
    initilizeCollapsibleElement();
    initializeTabs();
  });

})();