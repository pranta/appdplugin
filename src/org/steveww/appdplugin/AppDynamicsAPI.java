package org.steveww.appdplugin;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaWebView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;

import android.util.Log;

import com.appdynamics.eumagent.runtime.Instrumentation;
import com.appdynamics.eumagent.runtime.CallTracker;

public class AppDynamicsAPI extends CordovaPlugin {
	private static final String TAG = "appdplugin";

	@Override
	public boolean execute(String action, JSONArray args, CallbackContext cbContext) throws JSONException {
		boolean status = false;
		
		Log.i(TAG, "action: " + action);
		Log.i(TAG, "args: " + args);
		
		if(action.equals("reportMetricWithName")){
			String name = args.getString(0);
			long value = args.getLong(1);
			Instrumentation.reportMetric(name, value);
			status = true;
		} else if(action.equals("startTimerWithName")) {
			String name = args.getString(0);
			Instrumentation.startTimer(name);
			status = true;
		} else if(action.equals("stopTimerWithName")) {
			String name = args.getString(0);
			Instrumentation.stopTimer(name);
			status = true;
		} else if(action.equals("beginCall")) {
			String name = args.getString(0);
			String method = args.getString(1);
			// make key from params
			String key = name + method;
			HashMap cache = SharedCache.getInstance();
			cache.put(key, Instrumentation.beginCall(name, method));
			cbContext.success(key);
			status = true;
		} else if(action.equals("endCall")) {
			String key = args.getString(0);
			HashMap cache = SharedCache.getInstance();
			CallTracker tracker = (CallTracker)cache.get(key);
			Instrumentation.endCall(tracker);
			cache.remove(key);
			status = true;
		} else if(action.equals("consoleLog")) {
			String msg = args.getString(0);
			Log.i(TAG, "Log >>> " + msg);
			status = true;
		}
		
		return status;
	}
	
	@Override
	public void initialize(CordovaInterface cordova, CordovaWebView webView) {
		super.initialize(cordova, webView);
		// local init code here
	}
}