var GenVM = function() {
  var self = this;
  var bell = $('<audio>').attr('src', 'bell.mp3').appendTo($('body'))[0];

  self.showCallin = ko.observable(false);
  self.numCallins = ko.observable($('#numcallins').text());
  self.teamName = ko.observable();
  self.teamID = ko.observable();
  self.puzzleName = ko.observable(); 
  self.correctAnswer = ko.observable();
  self.teamAnswered = ko.observable();
  self.phoneNum = ko.observable();
  self.questionNotes = ko.observable();
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
      self.teamID(d.team_id);
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
    }, function(d) {
      if (d == "error") alert("Something bad happened");
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
    }, function(d) {
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
    }, function(d) {
      if (d == "error") alert("Something bad happened");
      self.updateNumCallins(function(){
        self.showCallin(false);
        self.showProcessing(false);
      });
    });
  };
  self.respondDelegate = function() {
    self.showProcessing(true);
    $.post('/queue/delegate', {
      id: self.callinID(),
      phone: self.phoneNum(),
      tid: self.teamID(),
      help: 'wat going on',
      text: "Delegated call-in for puzzle: " + self.puzzleName() + ", correct answer is: " + self.correctAnswer() + ", team answered: " + self.teamAnswered(),
      notes: "This question was a delegation from the call-in queue, where someone found some bizarre circumstances that suggest it needs to be dealt with here. That person left the following helpful information: " + self.questionNotes()
    }, function(d) {
      if (d == "error") alert("Something bad happened");
      self.updateNumCallins(function(){
        self.showCallin(false);
        self.showProcessing(false);
      });
    });
  };
  ko.computed(function() {
    if (self.showCallin()) {
      $(window).bind('beforeunload', function() {
        return 'YOU CANNOT LEAVE, this will screw up the call-in queue FOREVER!!! DON\'T DO IT, DON\'T PRESS ENTER';
      });
    } else {
      $(window).unbind('beforeunload');
    }
  });
};

$(function() {
  vm = new GenVM();
  ko.applyBindings(vm);

  setInterval(vm.updateNumCallins, 8000);
});