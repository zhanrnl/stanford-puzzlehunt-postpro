$(function() {
  $('.puzzleGraphBox').css('visibility','hidden');

  var centerCoords = function($elem) {
    var offset = $elem.position();
    var width = $elem.width();
    var height = $elem.height();

    var centerX = offset.left + width / 2 + 6;
    var centerY = offset.top + 18;
    return [centerX, centerY];
  };
  var coordsToStr = function(coords) {
    return coords[0] + ',' + coords[1];
  }

  var maxY = 0;
  $.map(links, function(link) {
    link.center1 = centerCoords($('#p' + link.ids[0]));
    link.center2 = centerCoords($('#p' + link.ids[1]));
    if (link.center1[1] > maxY) {
      maxY = link.center1[1];
    }
    if (link.center2[1] > maxY) {
      maxY = link.center2[1];
    }
    link.extOffset = Math.random();
  })

  var elem = $('#puzzleGraphContainer')[0];
  var paper = Raphael(elem, 1100, maxY);

  var paths = new Array(links.length);
  var extensionAmount = -1;

  $('.puzzleGraphBox').each(function(i, elem) {
    setTimeout(function() {
      $(elem).css('visibility','visible');
    }, Math.random() * 1000);
  });

  setTimeout(function() {
    var extending = setInterval(function() {
      if (extensionAmount > 2) {
        clearInterval(extending);
      }
      $.map(links, function(link, i) {
        var locExt = extensionAmount + link.extOffset;
        if (locExt > 1) locExt = 1;
        else if (locExt < 0) locExt = 0;
        var px = link.center1[0] + locExt * (link.center2[0] - link.center1[0]);
        var py = link.center1[1] + locExt * (link.center2[1] - link.center1[1]);
        if (paths[i] != null) {
          paths[i].remove();
        }
        paths[i] = paper.path('M' + coordsToStr(link.center1) + 'L' + coordsToStr([px, py]))
        .attr('stroke-width', '4');
        if (link.unlocked) {
          paths[i].attr('stroke', '#fff');
        } else {
          paths[i].attr('stroke', '#555').attr('stroke-dasharray', '.');
        }
      }); 
      extensionAmount += 0.04;
    }, 50);
  }, 600);
});