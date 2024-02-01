// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC0KCI5-9ijNjxxpdMsq5Pr0bNMdgbO72E',
    appId: '1:982537333615:web:b4c4cbd84912c128e8969a',
    messagingSenderId: '982537333615',
    projectId: 'tpworld-21fcc',
    authDomain: 'tpworld-21fcc.firebaseapp.com',
    storageBucket: 'tpworld-21fcc.appspot.com',
    measurementId: 'G-DZM2166F90',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDsNlDBmvCtNv9jzeU17QGj1M-DdMlPB5k',
    appId: '1:982537333615:android:d1a636797c22d09be8969a',
    messagingSenderId: '982537333615',
    projectId: 'tpworld-21fcc',
    storageBucket: 'tpworld-21fcc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCw8XH0IyYRypzKcjb7FYtGfMkQ7DZJG6k',
    appId: '1:982537333615:ios:f66bed0352f17f35e8969a',
    messagingSenderId: '982537333615',
    projectId: 'tpworld-21fcc',
    storageBucket: 'tpworld-21fcc.appspot.com',
    iosBundleId: 'com.example.tpworldAdmin',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCw8XH0IyYRypzKcjb7FYtGfMkQ7DZJG6k',
    appId: '1:982537333615:ios:f66bed0352f17f35e8969a',
    messagingSenderId: '982537333615',
    projectId: 'tpworld-21fcc',
    storageBucket: 'tpworld-21fcc.appspot.com',
    iosBundleId: 'com.example.tpworldAdmin',
  );
}