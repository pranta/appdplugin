window.appdynamics = new Object();

// Call by feature name in plugin.xml

window.appdynamics.reportMetricWithName = function(name, value, callback) {
	cordova.exec(callback, function(err) {
		callback('Error');
		}, "AppDynamics", "reportMetricWithName", [name, value]);
};

window.appdynamics.startTimerWithName = function(name, callback) {
	cordova.exec(callback, function(err) {
		callback('Error');
	}, "AppDynamics", "startTimerWithName", [name]);
};

window.appdynamics.stopTimerWithName = function(name, callback) {
	cordova.exec(callback, function(err) {
		callback('Error');
	}, "AppDynamics", "stopTimerWithName", [name]);
};

window.appdynamics.beginCall = function(name, sel, callback) {
	cordova.exec(callback, function(err) {
		callback('Error');
	}, "AppDynamics", "beginCall", [name, sel]);
};

window.appdynamics.endCall = function(sel, callback) {
	cordova.exec(callback, function(err) {
		callback('Error');
	}, "AppDynamics", "endCall", [sel]);
};

window.appdynamics.consoleLog = function(msg, callback) {
	cordova.exec(callback, function(err) {
		callback('Error');
	}, "AppDynamics", "consoleLog", [msg]);
};