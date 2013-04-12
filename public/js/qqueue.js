var GenVM = function() {
  var self = this;
  var bell = $('<audio>').attr('src', 'bell.mp3').appendTo($('body'))[0];

  self.showQuestion = ko.observable(false);
  self.numQuestions = ko.observable($('#numquestions').text());
  self.teamName = ko.observable();
  self.questionText = ko.observable();
  self.questionNotes = ko.observable();
  self.phoneNum = ko.observable();
  self.questionID = ko.observable();
  self.showProcessing = ko.observable(false);
  self.updateNumQuestions = function(callback) {
    if (!self.showQuestion() || self.showProcessing()) {
      $.get('/queue/numquestions', function(d) {
        self.numQuestions(d);
        if (d != "0" && self.showQuestion() == false) {
          bell.play();
        }
        if (callback != undefined) callback();
      });
    }
  };
  self.dequeue = function() {
    self.showProcessing(true);
    $.get('/qqueue/dequeue', function(d) {
      self.showProcessing(false);
      if (d == "none") {
        alert('No call-ins to process. Relax!')
        return;
      }
      self.showQuestion(true);
      self.teamName(d.team.team_name);
      self.questionText(d.question);
      self.questionNotes(d.notes);
      self.phoneNum(d.phone_num);
      self.questionID(d.id);
      $('#callInCont').show();
    });
  };
  self.respondAnswered = function() {
    self.showProcessing(true);
    $.post('/qqueue/answered', {
      id: self.questionID()
    }, function(d) {
      if (d == "error") alert("Something bad happened");
      self.updateNumQuestions(function(){
        self.showQuestion(false);
        self.showProcessing(false);
      });
    });
  };
  self.respondNeedsAttention = function() {
    self.showProcessing(true);
    $.post('/qqueue/attention', {
      id: self.questionID(),
      notes: self.questionNotes()
    }, function(d) {
      if (d == "error") alert("Something bad happened");
      self.updateNumQuestions(function(){
        self.showQuestion(false);
        self.showProcessing(false);
      });
    });
  };
  ko.computed(function() {
    if (self.showQuestion()) {
      $(window).bind('beforeunload', function() {
        return 'YOU CANNOT LEAVE, this will screw up the question queue FOREVER!!! DON\'T DO IT, DON\'T PRESS ENTER';
      });
    } else {
      $(window).unbind('beforeunload');
    }
  });
};

$(function() {
  vm = new GenVM();
  ko.applyBindings(vm);

  setInterval(vm.updateNumQuestions, 8000);
});