import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyDzfkbr-RY15gS8vuegsGre1Luj0U3JMXI',
    appId: '1:346392919126:web:4b7e1c215d906386148ff7',
    messagingSenderId: '346392919126',
    projectId: 'examenflutterlogin',
    authDomain: 'examenflutterlogin.firebaseapp.com',
    storageBucket: 'examenflutterlogin.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCLDpwejyOSsyAcngPuvIu8ZrBN_foCmu0',
    appId: '1:346392919126:android:611ea43cac9ac79a148ff7',
    messagingSenderId: '346392919126',
    projectId: 'examenflutterlogin',
    storageBucket: 'examenflutterlogin.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDKEwDzGPSXWmBm9cvcvQgtPaRhOGojDZM',
    appId: '1:346392919126:ios:cb08f499a128f30e148ff7',
    messagingSenderId: '346392919126',
    projectId: 'examenflutterlogin',
    storageBucket: 'examenflutterlogin.firebasestorage.app',
    iosBundleId: 'com.example.td3',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDKEwDzGPSXWmBm9cvcvQgtPaRhOGojDZM',
    appId: '1:346392919126:ios:cb08f499a128f30e148ff7',
    messagingSenderId: '346392919126',
    projectId: 'examenflutterlogin',
    storageBucket: 'examenflutterlogin.firebasestorage.app',
    iosBundleId: 'com.example.td3',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDzfkbr-RY15gS8vuegsGre1Luj0U3JMXI',
    appId: '1:346392919126:web:5481a11589b740fb148ff7',
    messagingSenderId: '346392919126',
    projectId: 'examenflutterlogin',
    authDomain: 'examenflutterlogin.firebaseapp.com',
    storageBucket: 'examenflutterlogin.firebasestorage.app',
  );
}
