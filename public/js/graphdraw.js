$(function() {
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
  })

  var elem = $('#puzzleGraphContainer')[0];
  var paper = Raphael(elem, 1100, maxY);

  $.map(links, function(link) {
    var p = paper.path('M' + coordsToStr(link.center1) + 'L' + coordsToStr(link.center2))
    .attr('stroke-width', '4');
    if (link.unlocked) {
      p.attr('stroke', '#fff');
    } else {
      p.attr('stroke', '#555').attr('stroke-dasharray', '.');
    }
  }); 
});