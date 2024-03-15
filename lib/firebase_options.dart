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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyD3JiC-zuWy22f0pbc5U_39Qaj5eLc7lps',
    appId: '1:562077421923:web:fc5704f08055e45f490356',
    messagingSenderId: '562077421923',
    projectId: 'africamedapp',
    authDomain: 'africamedapp.firebaseapp.com',
    storageBucket: 'africamedapp.appspot.com',
    measurementId: 'G-YNMTFHJ7K7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAIpexzkgW9w24wIMk14GdGWKa13yAe9uE',
    appId: '1:562077421923:android:0e67b462616da3b4490356',
    messagingSenderId: '562077421923',
    projectId: 'africamedapp',
    storageBucket: 'africamedapp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCkL_-0CJ5l8wW3gbHJJkyDGGk6pmk-GQ0',
    appId: '1:562077421923:ios:146e068587e655fe490356',
    messagingSenderId: '562077421923',
    projectId: 'africamedapp',
    storageBucket: 'africamedapp.appspot.com',
    iosBundleId: 'com.example.africaMedApp',
  );
}
