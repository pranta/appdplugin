#!/usr/bin/env sh

classpath="'com.appdynamics:appdynamics-gradle-plugin:4.+'"
gradle=platforms/android/build.gradle

# exit if it is already there
grep -q "$classpath" "$gradle" && exit

# copy original
cp "$gradle" "${gradle}.orig"

# append plugin class path
sed -e '/com.android.tools.build:gradle:/a\
        classpath '${classpath} "${gradle}.orig" > "${gradle}"
