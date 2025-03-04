import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;


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
    apiKey: 'AIzaSyDBEM-nXTOQkN31Uq2aMLvyuHc6U_UOXnM',
    appId: '1:452759377542:web:c0a3b2c791998b1c686307',
    messagingSenderId: '452759377542',
    projectId: 'styleai-cd746',
    authDomain: 'styleai-cd746.firebaseapp.com',
    storageBucket: 'styleai-cd746.firebasestorage.app',
    measurementId: 'G-7VV5KYVK4L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA5x9O2f9Yp6P-X4s-8JYcUeLpDfMxIuos',
    appId: '1:452759377542:android:d2ab0d0c9031e8ee686307',
    messagingSenderId: '452759377542',
    projectId: 'styleai-cd746',
    storageBucket: 'styleai-cd746.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAlcYmpkbyMr578PKL7SdcOpnqF1dEbgWY',
    appId: '1:452759377542:ios:5c829d283df3516f686307',
    messagingSenderId: '452759377542',
    projectId: 'styleai-cd746',
    storageBucket: 'styleai-cd746.firebasestorage.app',
    iosBundleId: 'com.example.myapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAlcYmpkbyMr578PKL7SdcOpnqF1dEbgWY',
    appId: '1:452759377542:ios:5c829d283df3516f686307',
    messagingSenderId: '452759377542',
    projectId: 'styleai-cd746',
    storageBucket: 'styleai-cd746.firebasestorage.app',
    iosBundleId: 'com.example.myapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDBEM-nXTOQkN31Uq2aMLvyuHc6U_UOXnM',
    appId: '1:452759377542:web:29e41ab69b56fe32686307',
    messagingSenderId: '452759377542',
    projectId: 'styleai-cd746',
    authDomain: 'styleai-cd746.firebaseapp.com',
    storageBucket: 'styleai-cd746.firebasestorage.app',
    measurementId: 'G-QE3KLZPSQQ',
  );
}