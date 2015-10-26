package com.appdynamics.appdplugin;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaWebView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Iterator;
import java.util.ArrayList;
import java.util.UUID;
import java.net.URL;
import java.net.MalformedURLException;

import android.util.Log;

import com.appdynamics.eumagent.runtime.Instrumentation;
import com.appdynamics.eumagent.runtime.CallTracker;
import com.appdynamics.eumagent.runtime.HttpRequestTracker;
import com.appdynamics.eumagent.runtime.ServerCorreleationHeaders;

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
			cbContext.success();
		} else if(action.equals("startTimerWithName")) {
			String name = args.getString(0);
			Instrumentation.startTimer(name);
			status = true;
			cbContext.success();
		} else if(action.equals("stopTimerWithName")) {
			String name = args.getString(0);
			Instrumentation.stopTimer(name);
			status = true;
			cbContext.success();
		} else if(action.equals("beginCall")) {
			String name = args.getString(0);
			String method = args.getString(1);
			// make key from UUID
			String key = UUID.randomUUID().toString();
			HashMap cache = SharedCache.getInstance();
			cache.put(key, Instrumentation.beginCall(name, method));
			cbContext.success(key);
			status = true;
		} else if(action.equals("endCall")) {
			String key = args.getString(0);
			HashMap cache = SharedCache.getInstance();
			CallTracker tracker = (CallTracker)cache.get(key);
			if(tracker != null) {
				Instrumentation.endCall(tracker);
				cache.remove(key);
				status = true;
				cbContext.success();
			}
		} else if(action.equals("leaveBreadcrumb")) {
			String crumb = args.getString(0);
			Instrumentation.leaveBreadcrumb(crumb);
			status = true;
			cbContext.success();
		} else if(action.equals("getCorrelationHeaders")) {
			Map<String, List<String>> headersMap = ServerCorreleationHeaders.generate();
			JSONObject headers = new JSONObject();
			for(Map<String, List<String>> entry : headersMap.entrySet()) {
				headers.put(entry.getKey(), entry.getValue().get(0));
			}
			cbContext.success(headers);
		} else if(action.equals("beginHttpRequest")) {
			String urlString = args.getString(0);
			try {
				URL url = new URL(urlString);
				HashMap cache = SharedCache.getInstance();
				HttpRequestTracker tracker = Instrumentation.beginHttpRequest(url);
				// make key out of UUID
				String key = UUID.randomUUID().toString();
				cache.put(key, tracker);
				cbContext.success(key);
				status = true;
			} catch(MalformedURLException e) {
				// Log it
				Log.e(TAG, "Exception: " + e.getMessage());
			}
		} else if(action.equals("reportDone")) {
			String tkey = args.getString(0);
			int responsecode = args.getInt(1);
			JSONObject headersObj = args.getJSONObject(2);

			// Loop through JSON Object
			HashMap headersMap = new HashMap();
			Iterator itor = headersObj.keys();
			while(itor.hasNext()) {
				String key = (String)itor.next();
				String val = headersObj.getString(key);
				ArrayList list = new ArrayList();
				list.add(val);
				// AppD magic headers must be uppercase CORE-39486
				if(key.startsWith("adrum")) {
					key = key.toUpperCase();
				}
				headersMap.put(key, list);
			}
			Log.i(TAG, ">>> ResponseHeaders " + headersMap);
			
			HashMap cache = SharedCache.getInstance();
			HttpRequestTracker tracker = (HttpRequestTracker)cache.get(tkey);
			if(tracker != null) {
				tracker.withResponseHeaderFields(headersMap).withResponseCode(responsecode).reportDone();
				cache.remove(tkey);
				status = true;
				cbContext.success();
			}
		} else if(action.equals("consoleLog")) {
			String msg = args.getString(0);
			Log.i(TAG, "Log >>> " + msg);
			status = true;
			cbContext.success();
		}
		// catch all
		else {
			Log.e(TAG, "Action not recognised");
			status = false;
			cbContext.error("Action not recognised");
		}
		
		return status;
	}
	
	@Override
	public void initialize(CordovaInterface cordova, CordovaWebView webView) {
		super.initialize(cordova, webView);
		// local init code here
	}
}
