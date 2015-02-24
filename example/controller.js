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
    	
	// report custom metric value
        window.appdynamics.reportMetricWithName('foo', 42, function(data) {
        	console.log('appd callback ' + data);
        });

	// start of network request
        window.appdynamics.beginHttpRequest(requestURL, function(key) {
        	console.log('appd callback ' + key);
		// save key for later
        	appdkey = key;
        });
        // headers() returns headers object
	// NOTE ADRUM request headers must be set
        $http.get(requestURL, {headers: {'ADRUM':'isAjax:true', 'ADRUM_1':'isMobile:true'}}).success(function(data, status, headers) {
		// report the result of the network request
        	window.appdynamics.reportDone(appdkey, status, headers(), function(data) {
        		console.log('appd callback ' + data);
        	});
        	$scope.onScreenLogging = headers();
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
    	window.appdynamics.startTimerWithName(name, function(data) {
    		console.log('appd callback ' + data);
    	});
    };
    
	// stop a custom timer, name is the key
    $scope.stopTimer = function(name) {
    	$('#clock').hide();
    	window.appdynamics.stopTimerWithName(name, function(data) {
    		console.log('appd callback ' + data);
    	});
    };
    
	// report a custom method invocation, use key to report finish
    $scope.infopoint = function(name, method) {
    	window.appdynamics.beginCall(name, method, function(key) {
		// utility call to log to application output for debugging
    		window.appdynamics.consoleLog('infopoint callback ' + key, function(data){});
		// set timeout to call end after 200ms, use key.
    		window.setTimeout(window.appdynamics.endCall, 200, key, function(data){});
    	});
    	$scope.onScreenLogging = 'Logging';
    };
    
});

