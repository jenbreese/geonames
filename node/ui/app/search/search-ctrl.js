(function () {
  'use strict';

  angular.module('geonames.search')
    .controller('SearchCtrl', ['$scope', 'MLRest', '$location', function ($scope, mlRest, $location) {
      var model = {
        selected: [],
        text: 'Utah',
        code: 'US'
      };

      function updateSearchResults(data) {
        model.search = data;
      }

      (function init() {
        mlRest.enrich(model.text, model.code).then(updateSearchResults);
      })();

      angular.extend($scope, {
        model: model,
        search: function() {
          mlRest.enrich(model.text, model.code).then(updateSearchResults);
          $location.path('/');
        }
      });

    }]);
}());
