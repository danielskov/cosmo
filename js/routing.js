// routing.js

// crete the module and name it cosmoApp, include ngRoute for routing needs
var cosmoApp = angular.module('cosmoApp', ['ngRoute']);

cosmoApp.config(function($routeProvider) {
    $routeProvider
        .when('/', {
            templateUrl : 'pages/front.html'//,
            //controller  : 'mainController'
        })
        .when('/methods', {
            templateUrl : 'pages/methods.html'//,
            //controller  : 'methodsController'
        })
        .when('/about', {
            templateUrl : 'pages/about.html'//,
            //controller  : 'aboutController'
        })
        .when('/help', {
            templateUrl : 'pages/help.html'//,
            //controller  : 'helpController'
        });
});


// create the controller and inject Angular's $scope
cosmoApp.controller('mainController', function($scope) {

    // message to display in content div
    $scope.content = 'Hello, world';

});
