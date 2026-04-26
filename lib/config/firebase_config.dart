import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return android;
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyAWpW5YIDbN96z2pUBRbMHT7X3fpJXMxs0",
    authDomain: "vci64-668a8.firebaseapp.com",
    databaseURL: "https://vci64-668a8-default-rtdb.firebaseio.com",
    projectId: "vci64-668a8",
    storageBucket: "vci64-668a8.firebasestorage.app",
    messagingSenderId: "383903147059",
    appId: "1:383903147059:web:ff380f037f8514f4ab6f46",
  );
}
