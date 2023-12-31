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
    apiKey: 'AIzaSyAtjmG1-8lQAvpT1QsFLtSOebACTMfeDX0',
    appId: '1:618818563925:web:985084199415b281c009dc',
    messagingSenderId: '618818563925',
    projectId: 'news-feed-f401e',
    authDomain: 'news-feed-f401e.firebaseapp.com',
    storageBucket: 'news-feed-f401e.appspot.com',
    measurementId: 'G-2VQGJ51BGL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDgEXhb2bKXFEIXb2n_QBNCbBE7wigCBqQ',
    appId: '1:618818563925:android:19658f3882886d2cc009dc',
    messagingSenderId: '618818563925',
    projectId: 'news-feed-f401e',
    storageBucket: 'news-feed-f401e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA602CTYlk1pk0gjnKyE8IRgw3q8BHGwrE',
    appId: '1:618818563925:ios:f62052f6753fa2f7c009dc',
    messagingSenderId: '618818563925',
    projectId: 'news-feed-f401e',
    storageBucket: 'news-feed-f401e.appspot.com',
    iosBundleId: 'com.example.newsFeed',
  );
}
