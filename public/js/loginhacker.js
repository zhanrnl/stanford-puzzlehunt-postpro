var message1 = 'Constructing crypto-encoded tunnelling proxy';
var message2 = 'Establishing ultrasecure transmission channel';

$(function() {
  var $all = $('.allContentContainer');
  var $main = $('.mainContentContainer');
  var $status = $('.status');
  var $bar = $('.loadingBar');
  $main.hide();

  var loadingBarSize = 30;
  var loadingProgress = 0;

  var makeLoadingStr = function(barSize, progress) {
    var str = '[';
    for (var i = 0; i < barSize; i++) {
      // if (i == progress - 1) {
      //   str += '>';
      // } else if (i < progress - 1) {
      //   str += '=';
      // } else {
      //   str += '&nbsp;';
      // }
      if (i <= progress) {
        str += '|';
      } else {
        str += '&nbsp;';
      }
    }
    str += ']';
    return str;  
  }

  var fadeIn = function() {
    doFadeIn();
    $main.show();
    $('.loginLoading').hide();
  };

  var doneLoading = function() {
    $status.text('CONNECTION SUCCESSFUL, CHANNEL ESTABLISHED');
    setTimeout(function() {
      fadeIn();
    }, Math.random() * 1000 + 1000);
  };

  var doLoading2 = function() {
    loadingProgress = 0;
    $status.text(message2);
    var loading2 = setInterval(function() {
      $bar.html(makeLoadingStr(loadingBarSize, loadingProgress));
      if (Math.random() < 0.2) {
        loadingProgress += 1;
        if (loadingProgress > loadingBarSize) {
          // next loading
          clearInterval(loading2);
          doneLoading();
        }
      }
    }, 10); 
  };

  var doLoading1 = function() {
    $status.text(message1);
    var loading1 = setInterval(function() {
      $bar.html(makeLoadingStr(loadingBarSize, loadingProgress));
      if (Math.random() < 0.2) {
        loadingProgress += 1;
        if (loadingProgress > loadingBarSize) {
          // next loading
          clearInterval(loading1);
          doLoading2();
        }
      }
    }, 10); 
  };

  if ($('.loginLoading').length == 0) {
    fadeIn();
  } else {
    doLoading1();
  }
});