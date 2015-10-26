/*
* Controller for simple AngularJS single page web application
*/

var requestURL = 'http://192.168.56.101:8080/Angular/DateServlet';

// initialise
var simpleApp = angular.module('simpleApp', []);

// on load
simpleApp.controller('simpleDate', function($scope, $http) {
    $http.get(requestURL).success(function(data) {
        $scope.simpleDate = data;
        $scope.onScreenLogging = 'Logging';
    });
    
    // Event handlers
    $scope.getDate = function() {
    	var appdkey;

	// default callbacks
	var wincb = function() {
		console.log('Success');
	};
	var failcb = function(e) {
		console.log('Error ' + e);
	};
    	
	// report custom metric value
	cordova.exec(wincb, failcb, 'AppDynamics', 'reportMetricWithName', ['foo', 42]);

	// start of network request
	var requestcb = function(d) {
		console.log('Success');
		appdkey = d;
	};
	cordova.exec(wincb, failcb, 'AppDynamics', 'beginHttpRequest', [requestURL]);
	// get headers to pass with request
	var = adHeaders;
	var headerscb = function(d) {
		console.log('Got headers');
		adHeaders = d;
	};
	cordova.exec(headerscb, failcb, 'AppDynamics', 'getCorrelationHeaders', []);

	// NOTE ADRUM request headers must be set
        $http.get(requestURL, {headers: adHeaders}).success(function(data, status, headers) {
		// report the result of the network request
		// headers() returns headers object
        	window.appdynamics.reportDone(appdkey, status, headers(), function(data) {
        		console.log('appd callback ' + data);
        	});
        	$scope.simpleDate = data;
    	}).error(function(data, status, headers) {
		// report the result of the network request
		window.appdynamics.reportDone(appdkey, status, headers(), function(data) {
			console.log('appd callback ' + data);
		});
	});
    };
    
	// start a custom timer, name is the key
    $scope.startTimer = function(name) {
    	$('#clock').show();
	cordova.exec(wincb, failcb, 'AppDynamics', 'startTimerWithName', [name]);
    };
    
	// stop a custom timer, name is the key
    $scope.stopTimer = function(name) {
    	$('#clock').hide();
	cordova.exec(wincb, failcb, 'AppDynamics', 'stopTimerWithName', [name]);
    };
    
    
});

