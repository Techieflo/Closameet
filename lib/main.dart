import 'package:closameet/screens/login.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBoR8yeD4nFsK0TeHGbJQosSKhIUjq1sf0", // Your apiKey
      appId: "1:453972592466:android:939bfe8a8a0c761d029c8b", // Your appId
      messagingSenderId: "XXX", // Your messagingSenderId
      projectId: "test-project-f1a83", // Your projectId
      storageBucket: "test-project-f1a83.appspot.com",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Login(),
    );
  }
}
