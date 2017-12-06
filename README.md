# SignalServiceKit has Moved

Per https://github.com/WhisperSystems/Signal-iOS/pull/2341 we've moved
the SignalServiceKit codebase into the primary Signal-iOS repository at
https://github.com/WhisperSystems/Signal-iOS. As such, this repository
will no longer be updated.

Don't worry - we will continue to make updates to SignalServiceKit, and
you can continue to use it in your projects as before. The only
difference is where the code lives.

If you are using Cocoapods, staying up to date is as simple as modifying
a line in your Podfile from this:

```
-  pod 'SignalServiceKit', git: 'https://github.com/WhisperSystems/SignalServiceKit.git'
```

To this:

```
+  pod 'SignalServiceKit', git: 'https://github.com/WhisperSystems/Signal-iOS.git'
```

# SignalServiceKit

SignalServiceKit is an Objective-C library for communicating with the Signal
messaging service for iOS & OS X
