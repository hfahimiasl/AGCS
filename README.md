# AGCS

Cross platform ground control station for UAVs.

## Qt Android kit on Windows
* Download below links
  * [NDK r19c](https://dl.google.com/android/repository/android-ndk-r19c-windows-x86_64.zip)
  * [JDK 8](https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html)
  * [Android Studio](https://developer.android.com/studio)

* Extract android-ndk-r19c-windows-x86_64.zip to C:\

* Install Java SE Development Kit 8

* Install Android Studio
> Open .exe file & click "Next"<br>
> Select "Android Virtual Device"<br>
> Click "next" to the rest of the section<br>
> Open Android Studio<br>
> Update libraries from Configure -> Check for Updates<br>
> Go to Configure -> SDK Manager -> Appearance & Behavior -> System Settings -> Android SDK<br>
> Make sure the "Hide Obsolete Packages" option is not selected<br>
> From "SDK Platforms", select from the first to "Android 5.0 (Lolipop)"<br>
> From "SDK Tools", select all items<br>
> From "SDK Update Sites", select all items<br>
> Click "Apply" & "OK"<br>
> From "Licenses", accept all of them and click "Next"
    
* Configure Qt Creator
> Go to Tools -> Options -> Devices -> Android<br>
> Set "JDK location : C:\Program Files\Java\jdk1.8.0_x"<br>
> Set "Android SDK location: C:\Users\<user>\AppData\Local\Android\Sdk"<br>
> Set "Android NDK location: C:\android-ndk-r19c"

* Simulation
> Open Android Studio<br>
> Go to Configure -> AVD Manager<br>
> Run desired virtual device<br>
> Select android kit in Qt<br>
> Click "Run" or Press "Ctrl + R"