'use strict';
var $ = require('jquery'),
    angular = require('angular'),
    toastr = require('toastr');

require('angular-route');
require('angular-animate');

var app = angular.module('app', ['ngRoute', 'ngAnimate']);

app.config(['$routeProvider', '$locationProvider', function ($routeProvider) {

    //$locationProvider.html5Mode(true);			// html5 mode optional
    $routeProvider
        .when('/main', {
            templateUrl: '/partials/main.html',
            controller: 'MainCtrl'
        })
        .when('/edit', {
            templateUrl: '/partials/edit.html',
            controller: 'EditCtrl'
        })
        .otherwise({
            redirectTo: '/main'
        });

}]);

app.factory('Mongo', function ($http) {

    var logAndRethrow = function (error) {
        console.log('mongo', error);
        error = 'Mongo connection failed';
        throw error;
    };

    var query = function () {
        return $http({method: 'get', url: '/api?' + (new Date()).getTime()}).then(function (res) {
            return res.data;
        })
            .then(null, logAndRethrow);
    };

    var save = function (params) {
        return $http.post('/api', params).then(function (res) {
            return res.data;
        })
            .then(null, logAndRethrow);
    };

    var remove = function (id) {
        return $http.delete('/api/' + id).then(function (res) {
            return res.data;
        })
            .then(null, logAndRethrow);
    };

    var update = function (params) {
        return $http.put('/api/' + params.id, params).then(function (res) {
            return res.data;
        })
            .then(null, logAndRethrow);
    };

    return {
        query: query,
        save: save,
        remove: remove,
        update: update
    };
});

app.controller('MainCtrl', ['$scope', 'Mongo', function ($scope, Mongo) {

    $scope.myVar = 'angular is working!';
    Mongo.query().then(function (result) {
        $scope.items = (result !== 'null') ? result : {};
    }, function (reason) {
        toastr.error(reason);
    });

}]);

app.controller('EditCtrl', ['$scope', 'Mongo', function ($scope, Mongo) {

    $scope.$on('remove', function (e, index) {
        $scope.items.splice(index, 1);
    });

    $scope.query = function () {
        Mongo.query().then(function (result) {
            $scope.items = (result !== 'null') ? result : {};
        }, function (reason) {
            toastr.error(reason);
        });
    };

    $scope.save = function () {
        if ($scope.test) {
            var params = {message: $scope.test};
            $scope.test = '';
            Mongo.save(params).then(function (result) {
                toastr.success('ADDED: ' + result.message);
                $scope.items.push(result);
            }, function (reason) {
                toastr.error(reason);
            });
        }
    };

    $scope.query();
}]);

app.directive('editable', ['$timeout', function ($timeout) {
    var markup = '<div>' +
        '<label ng-click="editItem()" class="message" ng-if="!editMode">{% raw %}{{editable.message}}{% endraw %}</label>' +
        '<input class="editBox" type="text" ng-class="{\'active\':editMode}" ng-model="editable.message" ng-keydown="keypress($event)" ng-if="editMode"/>' +
        '<div class="pull-right">' +
        '<div ng-if="!editMode" class="btn btn-info" ng-click="editItem()"><i class="fa fa-pencil"></i></div>' +
        '<div ng-if="editMode" class="btn btn-info" ><i class="fa fa-save"></i></div>' +
        '<div class="btn btn-danger" ng-click="removeItem()"><i class="fa fa-times"></i></div>' +
        '</div></div>';
    return {
        scope: {
            editable: '=',
            index: '@'
        },
        transclude: true,
        template: markup,
        restrict: 'A',
        controller: ['$scope', 'Mongo', function ($scope, Mongo) {
            $scope.editMode = false;
            $scope.lastText = $scope.editable.message;

            $scope.updateItem = function (id, data) {
                var params = {message: data, id: id};
                Mongo.update(params).then(function (results) {
                    $scope.lastText = results.message;
                }, function (reason) {
                    toastr.error(reason);
                });
            };

            $scope.removeItem = function () {
                Mongo.remove($scope.editable._id).then(function () {
                    toastr.error('DELETED: ' + $scope.editable.message);
                    $scope.$emit('remove', $scope.index);
                }, function (reason) {
                    toastr.error(reason);
                });
            };

            $scope.editItem = function () {
                $scope.$broadcast('edit');
            };

            $scope.keypress = function (e) {
                if (e.keyCode !== 13) {
                    return;
                }
                $scope.$broadcast('blur');
            };

        }],
        link: function (scope, element) {
            var ele = element[0];
            scope.$on('edit', function () {
                scope.editMode = true;
                $timeout(function () {
                    $(ele).find('.editBox').focus();
                });
            });

            scope.$on('blur', function () {
                $timeout(function () {
                    $(ele).find('.editBox').blur();
                });
            });

            $(ele).on('focusout', function () {
                $timeout(function () {
                    scope.editMode = false;
                    if (scope.lastText !== scope.editable.message) {
                        scope.updateItem(scope.editable._id, scope.editable.message);
                    }
                });
            });
        }
    };
}]);

app.animation('.editBox', function ($window) {
    return {
        addClass: function (e, className, done) {
            if (className === 'active' && $window.innerWidth > 991) {
                $window.TweenMax.to(e, 0.2, {skewX: 360, onComplete: done});
            }
            else {
                done();
            }
        }
    };
});
