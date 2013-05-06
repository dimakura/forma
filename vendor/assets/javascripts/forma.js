(function() {

  var initilizeCollapsibleElement = function() {
    $('.ff-collapsible').click(function(evt) {
      var activeTitle = $(this);
      var formBody = $(activeTitle.parent().siblings('.ff-form-body')[0]);
      var collapseElement = $(activeTitle.children('.ff-collapse')[0]);
      var isCollapsed = collapseElement.hasClass('ff-collapsed');
      if (isCollapsed) {
        formBody.show();
        collapseElement.removeClass('ff-collapsed');
      } else {
        formBody.hide();
        collapseElement.addClass('ff-collapsed');
      }
    });
  };

  var initializeTabs = function() {
    $('.ff-tabs-header li').click(function(evnt) {
      var newTab = $(this);
      var oldTab = newTab.siblings('.ff-selected');
      if (oldTab) {
        var newIndex = newTab.parent().children().index(newTab);
        var oldIndex = oldTab.parent().children().index(oldTab);
        var newBody = $($(newTab.parent().parent().children()[1]).children()[newIndex]);
        var oldBody = $($(newTab.parent().parent().children()[1]).children()[oldIndex]);
        oldTab.removeClass("ff-selected");
        oldBody.hide();
        newTab.addClass("ff-selected");
        newBody.show();
      }
    });
  };

  var initializeFormSubmit = function() {
    $('form.ff-wait-on-submit').submit(function(evnt) {
      var btn = $($(this).find('button[type=submit]')[0]);
      btn.html(btn.html() + '...');
      btn.attr('disabled', true);
      return true;
    });
  };

  var ready = function() {
    initilizeCollapsibleElement();
    initializeTabs();
    initializeFormSubmit();
  };

  // turbolink initilization!
  // http://railscasts.com/episodes/390-turbolinks?view=asciicast
  $(document).ready(ready);
  $(document).on('page:load', ready);

})();
