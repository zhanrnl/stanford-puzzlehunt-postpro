var GenVM = function() {
  var self = this;
  var bell = $('<audio>').attr('src', 'bell.mp3').appendTo($('body'))[0];

  self.showCallin = ko.observable(false);
  self.numCallins = ko.observable($('#numcallins').text());
  self.teamName = ko.observable();
  self.puzzleName = ko.observable();
  self.correctAnswer = ko.observable();
  self.teamAnswered = ko.observable();
  self.phoneNum = ko.observable();
  self.callinID = ko.observable();
  self.showProcessing = ko.observable(false);
  self.updateNumCallins = function(callback) {
    if (!self.showCallin() || self.showProcessing()) {
      $.get('/queue/numcallins', function(d) {
        self.numCallins(d);
        if (d != "0" && self.showCallin() == false) {
          bell.play();
        }
        if (callback != undefined) callback();
      });
    }
  };
  self.dequeue = function() {
    self.showProcessing(true);
    $.get('/queue/dequeue', function(d) {
      self.showProcessing(false);
      if (d == "none") {
        alert('No call-ins to process. Relax!')
        return;
      }
      self.showCallin(true);
      self.teamName(d.team.team_name);
      self.puzzleName(d.puzzle.puzzle_name);
      self.correctAnswer(d.puzzle.answer);
      self.teamAnswered(d.answer);
      self.phoneNum(d.phone_num);
      self.callinID(d.id);
      $('#callInCont').show();
    });
  };
  self.respondCorrect = function() {
    self.showProcessing(true);
    $.post('/queue/correct', {
      id: self.callinID()
    }, function() {
      self.updateNumCallins(function(){
        self.showCallin(false);
        self.showProcessing(false);
      });
    });
  };
  self.respondIncorrect = function() {
    self.showProcessing(true);
    $.post('/queue/incorrect', {
      id: self.callinID()
    }, function() {
      self.updateNumCallins(function(){
        self.showCallin(false);
        self.showProcessing(false);
      });
    });
  };
  self.respondRequeue = function() {
    self.showProcessing(true);
    $.post('/queue/requeue', {
      id: self.callinID()
    }, function() {
      self.updateNumCallins(function(){
        self.showCallin(false);
        self.showProcessing(false);
      });
    });
  };
};

$(function() {
  vm = new GenVM();
  ko.applyBindings(vm);

  setInterval(vm.updateNumCallins, 8000);
});