import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
/// Run `flutterfire configure` to replace these placeholders with your actual project keys.
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
    apiKey: 'AIzaSyCpRPuJB_-Nmdo7SRXs0SC-ZMQjvk3Fs9U',
    appId: '1:214743968157:web:b04b166818af1705e16774',
    messagingSenderId: '214743968157',
    projectId: 'roomie-app-db134',
    authDomain: 'roomie-app-db134.firebaseapp.com',
    storageBucket: 'roomie-app-db134.firebasestorage.app',
    measurementId: 'G-4JQDK7BSQY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAc-B_p1SxRWFPsI-D718B8NyLplFvQQ7E',
    appId: '1:214743968157:android:77387989d0160cebe16774',
    messagingSenderId: '214743968157',
    projectId: 'roomie-app-db134',
    storageBucket: 'roomie-app-db134.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA7V7zOFE_gQCgF8s8zixGQdF8vkOaxhE4',
    appId: '1:214743968157:ios:81f7e656e9a4b9dfe16774',
    messagingSenderId: '214743968157',
    projectId: 'roomie-app-db134',
    storageBucket: 'roomie-app-db134.firebasestorage.app',
    iosBundleId: 'com.uyumlu.app.uyumlu',
  );
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA7V7zOFE_gQCgF8s8zixGQdF8vkOaxhE4',
    appId: '1:214743968157:ios:81f7e656e9a4b9dfe16774',
    messagingSenderId: '214743968157',
    projectId: 'roomie-app-db134',
    storageBucket: 'roomie-app-db134.firebasestorage.app',
    iosBundleId: 'com.uyumlu.app.uyumlu',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCpRPuJB_-Nmdo7SRXs0SC-ZMQjvk3Fs9U',
    appId: '1:214743968157:web:0099d986c5cf26a6e16774',
    messagingSenderId: '214743968157',
    projectId: 'roomie-app-db134',
    authDomain: 'roomie-app-db134.firebaseapp.com',
    storageBucket: 'roomie-app-db134.firebasestorage.app',
    measurementId: 'G-4PELYHW4J9',
  );
}
