import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:yo/finished/finished_friends_page.dart';
import 'package:yo/finished/finished_login_page.dart';
import 'package:yo/finished/finished_session_model.dart';

Future<void> main() async {
  final FinishedSessionModel loginModel = FinishedSessionModel();
  runApp(ScopedModel<FinishedSessionModel>(
    model: loginModel,
    child: YoApp(),
  ));
}

class YoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yo!',
      theme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Color(0xFFF67280),
      ),
      home: ScopedModelDescendant<FinishedSessionModel>(
        builder:
            (BuildContext context, Widget child, FinishedSessionModel model) {
          if (!model.initialized) {
            // kind of splash screen, before we know if the user is signed in or not
            return Splash();
          }

          if (model.isUserLoggedIn) {
            // still signed in, show home
            return FriendsPage();
          }

          // new user, show login
          return LoginPage();
        },
      ),
    );
  }
}

class Splash extends StatelessWidget {
  const Splash({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF6C5B7B),
      child: Center(
        child: SizedBox(
          width: 48,
          height: 48,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
