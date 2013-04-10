var randomHexChar = function() {
  var i = Math.floor(Math.random() * 16);
  var chars = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'];
  return chars[i];
};

var setCharAt = function(str,index,chr) {
    if(index > str.length-1) return str;
    return str.substr(0,index) + chr + str.substr(index+1);
};

var shuffle = function(o) { //v1.0
  for(var j, x, i = o.length; i; j = parseInt(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
  return o;
};

var zeroToN = function(n) {
  var arr = [];
  for (var i = 0; i < n; i++) {
    arr.push(i);
  }
  return arr;
}

var doFadeIn = function() {
  $('input, button, submit').css('visibility', 'hidden');
  $('.hacker').each(function(i, elem) {
    var $elem = $(elem);
    var origText = $elem.text();
    $elem.html('&nbsp;');
    var letters = 0;
    setTimeout(function() {
      var interval = setInterval(function() {
        if (letters != 0) {
          var str = origText.slice(0, letters);
          for (var j = Math.max(0, letters - 30); j < letters; j++) {
            if (!str[j].match(/[ \.,;:]/) && Math.random() < 0.4) {
              str = setCharAt(str, j, randomHexChar());
            }
          }
          $elem.text(str);
        }
        if (Math.random() < 0.02 * origText.length + 0.08) {
          letters += 1;
        }
        if (letters >= origText.length - 1) {
          $elem.text(origText);
          clearInterval(interval);
          if ($elem.attr('shows') != undefined) {
            var showGroup = $elem.attr('shows');
            $('.' + showGroup).css('visibility', 'visible');
          }
        }
      }, 25);
    }, Math.random() * 200);
  });
  $('.garbage').each(function(i, elem){
    var $elem = $(elem);
    $elem.html('&nbsp;');
    var numBytes = 40;
    var bytesOn = [];
    var numOn = 0;
    for (var j = 0; j < numBytes; j++) {
      bytesOn.push(false);
    }
    var order = shuffle(zeroToN(numBytes));
    var switchOnInterval = setInterval(function() {
      bytesOn[order[numOn]] = true;
      numOn += 1;
      if (numOn == numBytes) {
        clearInterval(switchOnInterval);
      }
    }, 50);
    setInterval(function() {
      $elem.html($.map(bytesOn, function(e) {
        if (e == true) {
          return randomHexChar() + randomHexChar();
        } else {
          return '&nbsp;&nbsp;';
        }
      }).join('&nbsp;'));
    }, 80);
  });
};