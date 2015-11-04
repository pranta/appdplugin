
// home lab
// 'http://192.168.56.101:8080/Angular/DateServlet';
// mobile champions
// 'http://54.186.110.33:8080/Angular/DateServlet';

// Lab stuff
var appdynamics = {
	counter: 0,
	requestURL: 'http://54.186.110.33:8080/Angular/DateServlet',
	headers: {},
	parseResponseHeaders: function(headerStr) {
		var headers = {};
		if (!headerStr) {
			return headers;
		}
		var headerPairs = headerStr.split('\u000d\u000a');
		for (var i = 0; i < headerPairs.length; i++) {
			var headerPair = headerPairs[i];
			// Can't use split() here because it does the wrong thing
			// if the header value has the string ": " in it.
			var index = headerPair.indexOf('\u003a\u0020');
			if (index > 0) {
				var key = headerPair.substring(0, index);
				var val = headerPair.substring(index + 2);
				headers[key] = val;
			}
		}
		return headers;
	}
};

// Phonegap stuff
var app = {
    // Application Constructor
    initialise: function() {
        this.bindEvents();
    },
    // Bind Event Listeners
    //
    // Bind any events that are required on startup. Common events are:
    // 'load', 'deviceready', 'offline', and 'online'.
    bindEvents: function() {
        document.addEventListener('deviceready', this.onDeviceReady, false);
    },
    // deviceready Event Handler
    //
    // The scope of 'this' is the event. In order to call the 'receivedEvent'
    // function, we must explicitly call 'app.receivedEvent(...);'
    onDeviceReady: function() {
        app.receivedEvent('deviceready');
        
        // bind buttons
        document.getElementById('metricValBtn').onclick = app.setValue;
        document.getElementById('testingBtn').onclick = app.doTest;
        document.getElementById('userDataBtn').onclick = app.setUserData;
        document.getElementById('timerBtn').onclick = app.timerStartStop;
        document.getElementById('timeStampBtn').onclick = app.updateTimeStamp;
        document.getElementById('crashMe').onclick = app.crashme;
        
        // get the AppD headers
    	var headerscb = function(d) {
    		console.log('got headers ' + d);
    		console.log(d);
    		appdynamics.headers = d;
    	}
    	cordova.exec(headerscb, app.fail, 'AppDynamics', 'getCorrelationHeaders', []);
    },
    // Update DOM on a Received Event
    receivedEvent: function(id) {
        var parentElement = document.getElementById(id);
        var listeningElement = parentElement.querySelector('.listening');
        var receivedElement = parentElement.querySelector('.received');

        listeningElement.setAttribute('style', 'display:none;');
        receivedElement.setAttribute('style', 'display:block;');

        console.log('Received Event: ' + id);
    },
    doTest: function() {
    	console.log('Testing');
    	document.getElementById('testing').innerHTML = 'Update ' + appdynamics.counter;
    	appdynamics.counter++;
    },
    // GP callbacks
    win: function(d) {
    	console.log('Success ' + d);
    },
    fail: function(e) {
    	console.log('Error ' + e);
    },
    // button callbacks
    setValue: function() {
    	console.log('setValue');
    	var valuefield = document.getElementById('metricVal');
    	var theValue = valuefield.value;
    	if(isNaN(theValue)) {
    		alert('Numeric values only');
    	} else {
    		cordova.exec(app.win, app.fail, 'AppDynamics', 'reportMetricWithName', ['counter', theValue]);
    	}
    	valuefield.value = '';
    },
    setUserData: function() {
    	console.log('User data');
    	var keyField = document.getElementById('userKey');
    	var valueField = document.getElementById('userValue');
    	if(keyField.value == '' || valueField.value == '') {
    		alert('Empty values not allowed');
    	} else {
    		cordova.exec(app.win, app.fail, 'AppDynamics', 'setUserData', [keyField.value, valueField.value, false]);
    	}
    	keyField.value = valueField.value = '';
    },
    timerStartStop: function() {
    	console.log('Timer start/stop');
    	var timerBtn = document.getElementById('timerBtn');
    	if(timerBtn.innerHTML == 'Start') {
    		cordova.exec(app.win, app.fail, 'AppDynamics', 'startTimerWithName', ['ticktoc']);
    		timerBtn.innerHTML = 'Stop';
    	} else {
    		cordova.exec(app.win, app.fail, 'AppDynamics', 'stopTimerWithName', ['ticktoc']);
    		timerBtn.innerHTML = 'Start';
    	}
    },
    updateTimeStamp: function() {
    	console.log('AJAX call');
    	
    	var timestamp = document.getElementById('timestamp');
    	
    	// mark the start of the network request
    	var begincb = function(d) {
    		console.log('Got request id ' + d);
    		var appdkey = d;
    		
    		var successcb = function(data, status, xhr) {
				console.log('Success ' + status);
				console.log(data);
				timestamp.innerHTML = data.date;
				var respHeaders = appdynamics.parseResponseHeaders(xhr.getAllResponseHeaders());
				console.log(respHeaders);
				cordova.exec(app.win, app.fail, 'AppDynamics', 'reportDone', [appdkey, xhr.status, respHeaders]);
    		};
			var errorcb = function(xhr, status, error) {
				console.log('Error ' + error + ' status ' + status);
				var respHeaders = appdynamics.parseResponseHeaders(xhr.getAllResponseHeaders());
				cordova.exec(app.win, app.fail, 'AppDynamics', 'reportDone', [appdkey, xhr.status, respHeaders]);
			};
			var settings = {
				cache: false,
				headers: appdynamics.headers,
				success: successcb,
				error: errorcb
			};
			jQuery.ajax(appdynamics.requestURL, settings);
    	};
    	
    	cordova.exec(begincb, app.fail, 'AppDynamics', 'beginHttpRequest', [appdynamics.requestURL]);
    },
    crashme: function() {
    	console.log("CRASH");
    	var steps = [ 'hop', 'skip', 'jump'];
        for(s in steps) {
            cordova.exec(app.win, app.fail, 'AppDynamics', 'leaveBreadcrumb', [steps[s]]);
        }
        cordova.exec(app.win, app.fail, 'MobileLab', 'crashMe', [0]);
    }
};

// fire it up
app.initialise();
