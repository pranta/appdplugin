# appdplugin
Phonegap plugin to access AppDynamics Mobile EUM SDK

As Phonegap uses HTML5, Javascript and CSS for its user interface it is not so obvious how to use AppDynamics Mobile EUM SDK to add monitoring. With a Phonegap plugin native code may be called from Javascript. This is an example plugin for iOS and Android that allows the AppDynamics SDK to be called from Javascript.

The latest version of the AppDynamics SDK allows for custom correlation of network requests to backend services. Ensure you are using the lastest version of the SDK if you want correlation.

This plugin has support for automatically adding its native dependencies to the Cordova build configuration.For Android, this requires at least `cordova-android@4.0.0`, and for iOS it requires both `cordova-ios 4.3.0` and `cordova-cli 6.4.0`.

In any case, review the options for [instrumenting mobile apps](https://docs.appdynamics.com/display/PRO42/Instrument+a+Mobile+Application).
