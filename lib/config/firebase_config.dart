import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => android;

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyBRjMKa0U2EBR5pIb7YaPTrtxa0d0hGkfw",
    authDomain: "vci64-668a8.firebaseapp.com",
    databaseURL: "https://vci64-668a8-default-rtdb.firebaseio.com",
    projectId: "vci64-668a8",
    storageBucket: "vci64-668a8.firebasestorage.app",
    messagingSenderId: "383903147059",
    appId: "1:383903147059:android:fe862c466c966338ab6f46",
  );
}
