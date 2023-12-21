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
    apiKey: 'AIzaSyA2NILbY5tEMBvk3F-4tkvrzeCkQCpcras',
    appId: '1:808592512626:web:41aaf2d1e3e4d3d8b994eb',
    messagingSenderId: '808592512626',
    projectId: 'shopsie-43546',
    authDomain: 'shopsie-43546.firebaseapp.com',
    databaseURL: 'https://shopsie-43546-default-rtdb.firebaseio.com',
    storageBucket: 'shopsie-43546.appspot.com',
    measurementId: 'G-57RRLHEPLK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAttxcgZSIhTvoUACacEetQiH0ATelKtDg',
    appId: '1:808592512626:android:ae0d9b5a80269cefb994eb',
    messagingSenderId: '808592512626',
    projectId: 'shopsie-43546',
    databaseURL: 'https://shopsie-43546-default-rtdb.firebaseio.com',
    storageBucket: 'shopsie-43546.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDhNdftuQOuzRDWl6BZP7hb8h1--h16N3c',
    appId: '1:808592512626:ios:0e1506e7db147428b994eb',
    messagingSenderId: '808592512626',
    projectId: 'shopsie-43546',
    databaseURL: 'https://shopsie-43546-default-rtdb.firebaseio.com',
    storageBucket: 'shopsie-43546.appspot.com',
    androidClientId: '808592512626-n305uibte7nkrlup63958pj8ag0jtunk.apps.googleusercontent.com',
    iosClientId: '808592512626-6i6up2su5lqm1kcb920p2833pg70pis9.apps.googleusercontent.com',
    iosBundleId: 'com.example.shopsie',
  );
}