import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for project `roomie-app-7e00f`.
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
    apiKey: 'AIzaSyCEDqzhxw63xI-mwXRKe5HDyam2GEKFAxA',
    appId: '1:846082766130:web:dce5f38be6def4698d532b',
    messagingSenderId: '846082766130',
    projectId: 'roomie-app-7e00f',
    authDomain: 'roomie-app-7e00f.firebaseapp.com',
    storageBucket: 'roomie-app-7e00f.firebasestorage.app',
    measurementId: 'G-YNL6FDVTLE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDZiBCCpUgwxgnO0N-IoQ8Z354emeVb7aI',
    appId: '1:846082766130:android:844ea748f51311328d532b',
    messagingSenderId: '846082766130',
    projectId: 'roomie-app-7e00f',
    storageBucket: 'roomie-app-7e00f.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBZOSvNLgRgbuXXe-1Rz76PuBsAzDErjYk',
    appId: '1:846082766130:ios:fd0546da618fe86d8d532b',
    messagingSenderId: '846082766130',
    projectId: 'roomie-app-7e00f',
    storageBucket: 'roomie-app-7e00f.firebasestorage.app',
    iosBundleId: 'com.uyumlu.app.uyumlu',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBZOSvNLgRgbuXXe-1Rz76PuBsAzDErjYk',
    appId: '1:846082766130:ios:fd0546da618fe86d8d532b',
    messagingSenderId: '846082766130',
    projectId: 'roomie-app-7e00f',
    storageBucket: 'roomie-app-7e00f.firebasestorage.app',
    iosBundleId: 'com.uyumlu.app.uyumlu',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCEDqzhxw63xI-mwXRKe5HDyam2GEKFAxA',
    appId: '1:846082766130:web:dce5f38be6def4698d532b',
    messagingSenderId: '846082766130',
    projectId: 'roomie-app-7e00f',
    authDomain: 'roomie-app-7e00f.firebaseapp.com',
    storageBucket: 'roomie-app-7e00f.firebasestorage.app',
    measurementId: 'G-YNL6FDVTLE',
  );
}
