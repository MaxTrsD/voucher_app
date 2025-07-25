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
    apiKey: 'AIzaSyAr9bXjjne0bbIavnUI-cvgeKhDZU5VSa4',
    appId: '1:128359113676:web:915bfcc71d880d34e2b369',
    messagingSenderId: '128359113676',
    projectId: 'paraty-trips-app',
    authDomain: 'paraty-trips-app.firebaseapp.com',
    databaseURL: 'https://paraty-trips-app-default-rtdb.firebaseio.com',
    storageBucket: 'paraty-trips-app.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBkMv_SebB1T0tmOaAScZMgGfbA4vKgM8A',
    appId: '1:128359113676:android:2869932e8d9bd2bce2b369',
    messagingSenderId: '128359113676',
    projectId: 'paraty-trips-app',
    databaseURL: 'https://paraty-trips-app-default-rtdb.firebaseio.com',
    storageBucket: 'paraty-trips-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBNwq1eaA-8-w8mvyX0DAtIzjAdMVu4f-M',
    appId: '1:128359113676:ios:a2dc5fe39d9376d8e2b369',
    messagingSenderId: '128359113676',
    projectId: 'paraty-trips-app',
    databaseURL: 'https://paraty-trips-app-default-rtdb.firebaseio.com',
    storageBucket: 'paraty-trips-app.appspot.com',
    iosBundleId: 'com.example.voucherApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBNwq1eaA-8-w8mvyX0DAtIzjAdMVu4f-M',
    appId: '1:128359113676:ios:65bfeca76b41f84fe2b369',
    messagingSenderId: '128359113676',
    projectId: 'paraty-trips-app',
    databaseURL: 'https://paraty-trips-app-default-rtdb.firebaseio.com',
    storageBucket: 'paraty-trips-app.appspot.com',
    iosBundleId: 'com.example.voucherApp.RunnerTests',
  );
}
