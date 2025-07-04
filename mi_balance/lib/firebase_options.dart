// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCr4OsF51cDYe28XHpgoJ7Cd_hHRw59dx4',
    appId: '1:724040418983:web:178a4dc156df5357a2fd82',
    messagingSenderId: '724040418983',
    projectId: 'mibalance-6b03d',
    authDomain: 'mibalance-6b03d.firebaseapp.com',
    storageBucket: 'mibalance-6b03d.firebasestorage.app',
    measurementId: 'G-J5QDPQ6FP5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCjZ743iIAcQBc4v3imZY78Pm-IVGIECuw',
    appId: '1:724040418983:android:c694a82448bb46e2a2fd82',
    messagingSenderId: '724040418983',
    projectId: 'mibalance-6b03d',
    storageBucket: 'mibalance-6b03d.firebasestorage.app',
  );
}
