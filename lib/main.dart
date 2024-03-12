import 'package:admin_web_panel/dashboard/side_navigation_drawer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: FirebaseOptions(
  apiKey: "AIzaSyDtvRVetb6lZzxpIQQ8gqIGK1J2WOlBnok",
  authDomain: "passenger-signuplogin.firebaseapp.com",
  databaseURL: "https://passenger-signuplogin-default-rtdb.asia-southeast1.firebasedatabase.app",
  projectId: "passenger-signuplogin",
  storageBucket: "passenger-signuplogin.appspot.com",
  messagingSenderId: "755339267599",
  appId: "1:755339267599:web:b6fae1da7711fc97e01d7a",
  measurementId: "G-4H2JKHJB7F"
     ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Panel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SideNavigationDrawer(),
    );
  }
}


