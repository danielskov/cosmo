// routing.js

// crete the module and name it cosmoApp, include ngRoute for routing needs
var cosmoApp = angular.module('cosmoApp', ['ngRoute']);

cosmoApp.config(function($routeProvider) {
    $routeProvider
        .when('/', {
            templateUrl : 'pages/front.html'
        })
        .when('/methods', {
            templateUrl : 'pages/methods.html'
        })
        .when('/about', {
            templateUrl : 'pages/about.html'
        })
        .when('/help', {
            templateUrl : 'pages/help.html'
        })
        .when('/history', {
            templateUrl : 'pages/history.html'
        })
        .when('/exposure-age', {
            templateUrl : 'pages/exposure-age.html'
        })
        .when('/erosion-rate', {
            templateUrl : 'pages/erosion-rate.html'
        });
});


// create the controller and inject Angular's $scope
cosmoApp.controller('mainController', function($scope) { });
