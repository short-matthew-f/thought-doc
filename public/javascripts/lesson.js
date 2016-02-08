angular.module('lessonApp', [])
  .filter('unsafe', function($sce) {
    return $sce.trustAsHtml;
  })
  .controller('LessonController', [
    '$http',
    function ($http) {
      var ctrl = this,
          lessonID = location.pathname.split('/students/')[1];

      this.getPending = function () {
        $http.get('/students/' + lessonID + '/pending.json')
          .then(function setPending (res) {
            ctrl.lesson       = res.data.lesson;
            ctrl.pendingPolls = res.data.polls;
            console.log(res.data.polls);
          }, function setPendingErr (res) {
            console.log(res);
          });
      };

      this.assert = function (poll, choice) {
        $http.post('/students/' + choice.id + '/vote')
          .then(function (res) {
            ctrl.getPending();
          }, function (res) {
            alert('fuck');
          });
      };

      ctrl.getPending();
  }]);
