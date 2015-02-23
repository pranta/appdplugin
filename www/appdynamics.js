window.appdynamics = new Object();

// Call by feature name in plugin.xml

window.appdynamics.reportMetricWithName = function(name, value, callback) {
	cordova.exec(callback, function(err) {
		callback('Error');
		}, "AppDynamics", "reportMetricWithName", [name, value]);
};

window.appdynamics.leaveBreadcrumb = function(name, callback) {
	cordova.exec(callback, function(err) {
		callback('Error');
	}, "AppDynamics", "leaveBreadcrumb", [name]);
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

window.appdynamics.endCall = function(key, callback) {
	cordova.exec(callback, function(err) {
		callback('Error');
	}, "AppDynamics", "endCall", [key]);
};

window.appdynamics.beginHttpRequest = function(url, callback) {
	cordova.exec(callback, function(err) {
		callback('Error');
	}, "AppDynamics", "beginHttpRequest", [url]);
};

window.appdynamics.reportDone = function(key, status, headers, callback) {
	cordova.exec(callback, function(err) {
		callback('Error');
	}, "AppDynamics", "reportDone", [key, status, headers]);
};

window.appdynamics.consoleLog = function(msg, callback) {
	cordova.exec(callback, function(err) {
		callback('Error');
	}, "AppDynamics", "consoleLog", [msg]);
};