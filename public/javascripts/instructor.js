angular.module('instructorApp', [])
  .filter('unsafe', function($sce) {
    return $sce.trustAsHtml;
  })
  .controller('LessonController', [
    '$http',
    function ($http) {
      var ctrl = this;

      ctrl.newLesson = {
        title: '',
        github_url: ''
      };

      ctrl.newPoll = {
        question: '',
        choices_attributes: [
          { content: '' },
          { content: '' },
          { content: '' },
          { content: '' }
        ]
      };

      ctrl.getLessons = function () {
        $http.get('/lessons.json')
          .then(function setLessons (res) {
            ctrl.lessons = res.data.lessons;
          }, function rejectLessons (res) {
            alert('fuck!');
          });
      };

      ctrl.togglePoll = function (poll) {
        $http.post('/polls/' + poll.id + '/toggle')
          .then(function (res) {
            poll.active = !poll.active;
          }, function (res) {
            alert('no good!');
          });
      };

      ctrl.showLessonForm = function () {
        ctrl.newLessonActive = true;
        ctrl.modalActive     = true;
      };

      ctrl.hideLessonForm = function () {
        document.querySelector('.lesson-modal').scrollTop = 0;
        ctrl.newLesson = {
          title: '',
          github_url: ''
        };
        ctrl.lessonError     = undefined;
        ctrl.newLessonActive = false;
        ctrl.modalActive     = false;
      };

      ctrl.showPollForm = function (lesson) {
        ctrl.currentLesson = lesson;
        ctrl.newPollActive = true;
        ctrl.modalActive   = true;
      };

      ctrl.hidePollForm = function () {
        document.querySelector('.poll-modal').scrollTop = 0;
        ctrl.newPoll = {
          question: '',
          choices_attributes: [
            { content: '' },
            { content: '' },
            { content: '' },
            { content: '' }
          ]
        };
        ctrl.pollError     = undefined;
        ctrl.currentLesson = undefined;
        ctrl.newPollActive = false;
        ctrl.modalActive   = false;
      };

      ctrl.createLesson = function () {
        $http.post('/lessons', {
          lesson: ctrl.newLesson
        }).then(function (res) {
          if (res.data.error) {
            ctrl.lessonError = res.data.message;
          } else {
            ctrl.lessonError = undefined;
            ctrl.getLessons();
            ctrl.hideLessonForm();
          }
        }, function (res) {
          console.log(res.data);
        });
      };

      ctrl.destroyLesson = function (lesson) {
        $http.delete('/lessons/' + lesson.id)
          .then(function (res) {
            var i = ctrl.lessons.indexOf(lesson);
            ctrl.lessons.splice(i, 1);
          }, function (res) {

          });
      };

      ctrl.createPoll = function () {
        $http.post('/lessons/' + ctrl.currentLesson.id + '/polls', {
          poll: ctrl.newPoll
        }).then(function (res) {
          if (res.data.error) {
            ctrl.pollError = res.data.message;
          } else {
            ctrl.getLessons();
            ctrl.hidePollForm();
          }
        }, function (res) {
          console.log(res);
        });
      };

      ctrl.destroyPoll = function (lesson, poll) {
        $http.delete('/polls/' + poll.id)
          .then(function (res) {
            var i = lesson.polls.indexOf(poll);
            lesson.polls.splice(i, 1);
          }, function (res) {

          });
      };

      ctrl.markCorrect = function (poll, choice) {
        $http.post('/choices/' + choice.id + '/mark_correct')
          .then(function (res) {
            poll.choices.forEach(function (c) {
              if (c == choice) {
                c.correct = true;
              } else {
                c.correct = false;
              }
            })
          }, function (res) {

          });
      };

      ctrl.toggleChoices = function (poll) {
        $http.get('/polls/' + poll.id + '.json')
          .then(function (res) {
            var update = res.data;

            poll.totalVotes = update.totalVotes;
            poll.choices    = update.choices;

            poll.viewActive = !poll.viewActive;
          });
      };

      ctrl.getLessons();
  }]);
