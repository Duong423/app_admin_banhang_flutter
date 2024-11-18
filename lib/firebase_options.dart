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
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyA5Cc7u45xVOjIULQDPUxtufxX3JLIzcvc',
    appId: '1:260992200166:web:bbf126479eaff80bdd7a27',
    messagingSenderId: '260992200166',
    projectId: 'easyshopping-751d5',
    authDomain: 'easyshopping-751d5.firebaseapp.com',
    storageBucket: 'easyshopping-751d5.appspot.com',
    measurementId: 'G-CKB40FK9F1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDuA_pMY9ZeWT9wWB8wiOrJBXPqjq7LxyA',
    appId: '1:260992200166:android:7c36e332cbdb97d5dd7a27',
    messagingSenderId: '260992200166',
    projectId: 'easyshopping-751d5',
    storageBucket: 'easyshopping-751d5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDQreYEBZZV8KdMiKvSGEQ4ihSo5G3rCTo',
    appId: '1:260992200166:ios:5e78d8621dbcbf18dd7a27',
    messagingSenderId: '260992200166',
    projectId: 'easyshopping-751d5',
    storageBucket: 'easyshopping-751d5.appspot.com',
    androidClientId: '260992200166-v01743kgehfrv1vgcdhht0fpm94dqb1r.apps.googleusercontent.com',
    iosClientId: '260992200166-nuoec26jtfuacc6390db9drgdfoagk5t.apps.googleusercontent.com',
    iosBundleId: 'com.example.adminApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDQreYEBZZV8KdMiKvSGEQ4ihSo5G3rCTo',
    appId: '1:260992200166:ios:5e78d8621dbcbf18dd7a27',
    messagingSenderId: '260992200166',
    projectId: 'easyshopping-751d5',
    storageBucket: 'easyshopping-751d5.appspot.com',
    androidClientId: '260992200166-v01743kgehfrv1vgcdhht0fpm94dqb1r.apps.googleusercontent.com',
    iosClientId: '260992200166-nuoec26jtfuacc6390db9drgdfoagk5t.apps.googleusercontent.com',
    iosBundleId: 'com.example.adminApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA5Cc7u45xVOjIULQDPUxtufxX3JLIzcvc',
    appId: '1:260992200166:web:94cf2cea82c99441dd7a27',
    messagingSenderId: '260992200166',
    projectId: 'easyshopping-751d5',
    authDomain: 'easyshopping-751d5.firebaseapp.com',
    storageBucket: 'easyshopping-751d5.appspot.com',
    measurementId: 'G-BVWBP6TPRX',
  );
}