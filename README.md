# appdplugin
Phonegap plugin to access AppDynamics Mobile EUM SDK

As Phonegap uses HTML5, Javascript and CSS for its user interface it is not so obvious how to use AppDynamics Mobile EUM SDK to add monitoring. With a Phonegap plugin native code may be called from Javascript. This is an example plugin for iOS that allows the AppDynamics SDK to be called from Javascript.

At the moment the SDK does not automatically track the network requests. However using a plugin like this one some data may still be reported back.
