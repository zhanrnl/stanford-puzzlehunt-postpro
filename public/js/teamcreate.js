$(function() {
  var makeInternal = function(name) {
    var toLower = function(c) {
      return c.toLowerCase();
    };
    return name.replace(/[-\s]/g, '_').replace(/[A-Z]/g, toLower).replace(/[^\w]/g, '').substring(0,20);
  };
  var f = function() {
    var enteredName = $('#team_team_name').val();
    $('.internalNameField').val(makeInternal(enteredName));
  };
  $('#team_team_name').keyup(f).change(f);
  $('.internalNameField').text('');
  var setDoHash = function() {
    $('#do_hash').attr('checked', 'checked');
  };
  $('#team_pass_hash').keyup(setDoHash).change(setDoHash);
  $('#genpassword').click(function() {
    $.get('/teams/genpassword', function(data) {
      $('#team_pass_hash').val(data);
      setDoHash();
    });
  });
}); 