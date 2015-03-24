package com.appdynamics.appdplugin;

import java.util.HashMap;


class SharedCache {
	private static HashMap cache = null;

	public static HashMap getInstance() {
		if(cache == null) {
			cache = new HashMap();
		}

		return cache;
	}
}