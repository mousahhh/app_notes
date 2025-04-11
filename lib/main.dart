import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_12/auth/signin.dart';
import 'package:flutter_application_12/auth/signup.dart';
import 'package:flutter_application_12/catogery/add.dart';
import 'package:flutter_application_12/homepage.dart';
import 'package:flutter_application_12/message.dart';
import 'package:flutter_application_12/users.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TokenMessag(),
      // FirebaseAuth.instance.currentUser != null &&
      //         FirebaseAuth.instance.currentUser!.emailVerified
      //     ? HomePage()
      //     : login(),
      routes: {
        "SignUp": (context) => SignUp(),
        "login": (context) => login(),
        "HomePage": (context) => HomePage(),
        "addcatogery": (context) => addcatogery(),
        "UserData": (context) => UserData(),
        "TokenMessage": (context) => TokenMessag()
      },
    );
  }
}
