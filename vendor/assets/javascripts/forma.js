(function() {

  var initilizeCollapsibleElement = function() {
    $('.ff-collapsible').click(function(evt) {
      var activeTitle = $(this);
      var formBody = $(activeTitle.parent().siblings('.ff-collapsible-body')[0]);
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
        // we need to initialize a map
        // if it was not visible and became
        // visible when the tab was open
        initGoogleMaps();
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

  var initializeTooltips = function() {
    $('.ff-field-hint').tooltip({ placement: 'right', trigger: 'click' });
    $('.ff-action').tooltip({ placement: 'top' });
    // TODO: any other tooltips?
  };

  // google map initialization

  var mapsData = {};

  var registerGoogleMap = function(id, zoom, center, markers) {
    mapsData[id] = { id: id, initialized: false, zoom: zoom, center: center, markers: markers }
  };

  var googleMapInitialization = function(data) {
    var id = data['id'];
    if ($('#' + id).is(':visible')) {
      var mapOptions = {
        center: new google.maps.LatLng(data.center.latitude, data.center.longitude),
        zoom: data.zoom,
        mapTypeId: google.maps.MapTypeId.HYBRID //ROADMAP
      };
      var map = new google.maps.Map(document.getElementById(id), mapOptions);
      for (var i = 0, l = data.markers.length; i < l; i++) {
        var markerData = data.markers[i];
        var markerPosition = new google.maps.LatLng(markerData.latitude, markerData.longitude);
        var marker = new google.maps.Marker({
          position: markerPosition,
          animation: google.maps.Animation.DROP,
          map: map
        });
      }
      data.initialized = true;
    }
  };

  var initGoogleMaps = function() {
    for (var id in mapsData) {
      var data = mapsData[id];
      if (data && !data.initialized) {
        googleMapInitialization(data);
      }
    }
  };

  // prepare function

  var ready = function() {
    initilizeCollapsibleElement();
    initializeTabs();
    initializeFormSubmit();
    initializeTooltips();
    initGoogleMaps();
  };

  // turbolink initilization!
  // http://railscasts.com/episodes/390-turbolinks?view=asciicast
  $(document).ready(ready);
  $(document).on('page:load', ready);

  // external API

  window.forma = {
    registerGoogleMap: registerGoogleMap,
  };

})();
