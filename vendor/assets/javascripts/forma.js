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

  var initializeSelectFields = function() {
    $('.ff-select-link').click(function() {
      var link = $(this);
      var url = link.attr('data-url');
      var height = link.attr('data-height');
      var width = link.attr('data-width');
      var screenLeft = window.screenLeft;
      var screenTop = window.screenTop;
      var browserHeight = window.outerHeight;
      var browserWidth = window.outerWidth;
      var left = parseInt((screenLeft + browserWidth - width) / 2);
      var top = parseInt((screenTop + browserHeight - height) / 2);
      var properties = ['height=', height, ',width=', width, ',left=', left, ',top=', top];
      window.open(url, link.attr('data-id'), properties.join(''));
    });
  };

  var initializeSelectActions = function() {
    $('.ff-select-action').click(function() {
      var valueId = window.name + '_value';
      var labelId = window.name + '_text';
      var valueElement = window.opener.$('#' + valueId);
      var labelElement = window.opener.$('#' + labelId);
      valueElement.val($(this).attr('data-value-id'));
      labelElement.text($(this).attr('data-value-text'));
      labelElement.removeClass('ff-empty');
      window.close();
      return false;
    });
    $('.ff-clear-selection-action').click(function() {
      var valueId = $(this).attr('data-id') + '_value';
      var labelId = $(this).attr('data-id') + '_text';
      var valueElement = $('#' + valueId);
      var labelElement = $('#' + labelId);
      valueElement.val(null);
      labelElement.text('(empty)');
      labelElement.addClass('ff-empty');
    });
  };

  // google map initialization

  var mapsData = {};

  var registerGoogleMap = function(id, zoom, center, coordinates, draggable) {
    mapsData[id] = { id: id, zoom: zoom, center: center, coordinates: coordinates, draggable: draggable }
  };

  var getGoogleMap = function(id) {
    return mapsData[id];
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
      var markers = [ ];
      for (var i = 0, l = data.coordinates.length; i < l; i++) {
        var markerData = data.coordinates[i];
        var markerPosition = new google.maps.LatLng(markerData.latitude, markerData.longitude);
        var marker = new google.maps.Marker({
          position: markerPosition,
          animation: google.maps.Animation.DROP,
          map: map,
          draggable: data.draggable,
        });
        markers.push(marker);
        google.maps.event.addListener(marker, 'dragend', function() {
          var pos = marker.getPosition();
          $('#' + id + '_latitude').val(pos.lat() + '');
          $('#' + id + '_longitude').val(pos.lng());
        });
      }
      data.map = map;
      data.markers = markers;
    }
  };

  var initGoogleMaps = function() {
    for (var id in mapsData) {
      var data = mapsData[id];
      if (data && !data.map) {
        googleMapInitialization(data);
      }
    }
  };

  var initPopovers = function() {
    $('.ff-popover').popover({ trigger: 'click' });
  };

  // prepare function

  var ready = function() {
    initilizeCollapsibleElement();
    initializeTabs();
    initializeFormSubmit();
    initializeTooltips();
    initGoogleMaps();
    initPopovers();
    // selectors
    initializeSelectFields();
    initializeSelectActions();
  };

  // turbolink initilization!
  // http://railscasts.com/episodes/390-turbolinks?view=asciicast
  $(document).ready(ready);
  $(document).on('page:load', ready);

  // external API

  window.forma = {
    registerGoogleMap: registerGoogleMap,
    getGoogleMap: getGoogleMap,
  };

})();
