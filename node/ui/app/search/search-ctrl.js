(function () {
  'use strict';

  angular.module('geonames.search')
    .controller('SearchCtrl', ['$scope', 'MLRest', '$location', '$sce', function ($scope, mlRest, $location, $sce) {
      var model = {
        selected: [],
        text: '',
        code: '',
        countries: [],
        search: []
      };

      function updateSearchResults(data) {
        model.search = data;
      }

      (function init() {
        //mlRest.enrich(model.text, model.code).then(updateSearchResults);
        mlRest.countries("true").then(function(data) {
          model.countries = data.countries.country;
          model.countries.unshift({Country: "World", ISO: ""});
        });
      })();

      angular.extend($scope, {
        model: model,
        search: function() {
          mlRest.enrich(model.text, model.code).then(updateSearchResults);
          $location.path('/');
        },
        renderQuery: function() {
          return model.search.summary ? $sce.trustAsHtml(model.search.summary.query) : '';
        }
      });

    }]);
}());
