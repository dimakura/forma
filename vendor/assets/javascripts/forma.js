(function() {
  var frm = {};

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

  /**
   * Opens tab by given ID (tabid).
   */
  var openTab = function(tabid) {
    var clickedTab = $('[data-tabid=' + tabid + ']');
    if (clickedTab && !clickedTab.hasClass('ff-selected')) {
      var tabId = clickedTab.attr('data-tabid');
      var tabsHeader = clickedTab.parents('.ff-tabs-header');
      var selectedTab = tabsHeader.find('.ff-selected');
      var selectedId = selectedTab.attr('data-tabid');
      $('#' + selectedId).hide();
      selectedTab.removeClass('ff-selected');
      $('#' + tabId).show();
      clickedTab.addClass('ff-selected');
    }
  };

  var initializeTabs = function() {
    $('.ff-tabs-header li').click(function(evt) {
      var element = $(evt.target);
      var tabid = element.attr('data-tabid');
      if (!tabid) { tabid = element.parent().attr('data-tabid'); }
      openTab(tabid);
    });
  };

  $(function() {
    initilizeCollapsibleElement();
    initializeTabs();
  });

  frm.openTab = openTab;
  window.Forma = frm;

})();
