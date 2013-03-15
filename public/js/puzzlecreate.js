$(function() {
  var makeInternal = function(name) {
    var toLower = function(c) {
      return c.toLowerCase();
    };
    return name.replace(/[-\s]/g, '_').replace(/[A-Z]/g, toLower).replace(/[^\w]/g, '').substring(0,20);
  };
  var f = function() {
    var enteredName = $('#puzzle_puzzle_name').val();
    $('.internalNameField').val(makeInternal(enteredName));
  };
  $('#puzzle_puzzle_name').keyup(f).change(f);
  $('.internalNameField').text('');
}); 