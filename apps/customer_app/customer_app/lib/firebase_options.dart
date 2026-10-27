// File generated for FreshSave Firebase multiplatform configuration.
// Project: fresh-ceac0

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyChWbi7vspwxH9IBkf-x5dMkQTOKFRd3NM',
    appId: '1:356215287106:web:1ce8b3596c211008716cdb',
    messagingSenderId: '356215287106',
    projectId: 'fresh-ceac0',
    authDomain: 'fresh-ceac0.firebaseapp.com',
    storageBucket: 'fresh-ceac0.firebasestorage.app',
    measurementId: 'G-PHG1Y8Y33S',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA2BXBfOUM6s2en9wxnetNPTYbFNLZad1A',
    appId: '1:356215287106:android:9e87856f7f3948a8716cdb',
    messagingSenderId: '356215287106',
    projectId: 'fresh-ceac0',
    storageBucket: 'fresh-ceac0.firebasestorage.app',
  );
}
