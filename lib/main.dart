import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yo/home_page.dart';
import 'package:yo/login_page.dart';

Future<void> main() async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  runApp(MyApp(user == null));
}

class MyApp extends StatelessWidget {
  final bool showLoginScreen;

  MyApp(this.showLoginScreen);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yo!',
      theme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Color(0xFFF67280),
      ),
      routes: {
        HomePage.ROUTE_NAME: (context) => HomePage(),
      },
      home: showLoginScreen ? LoginPage() : HomePage(),
    );
  }
}
