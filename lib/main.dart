import 'package:flutter/material.dart';

Future<void> main() async {
  runApp(YoApp());
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
        home: Scaffold(
          body: Splash(),
        ));
  }
}

class Splash extends StatefulWidget {
  const Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  var mastered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = <Widget>[
      FadeInImage.assetNetwork(
        placeholder: "assets/transparent.png",
        image: "https://flutter.school/assets/images/image01.png",
        width: 96,
        height: 96,
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "flutter.school",
          style: theme.textTheme.display1
              .copyWith(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
      ),
      Text(
        "Welcome student!",
        style: theme.textTheme.subtitle.copyWith(color: Colors.black45),
      ),
      Flexible(
        child: Padding(
          padding: const EdgeInsets.only(top: 48.0),
          child: mastered ? _finished(context) : _fab(context),
        ),
      )
    ];

    return Container(
      color: Color(0xFF6C5B7B),
      child: Center(
        child: Card(
          color: Colors.white,
          child: AnimatedContainer(
            height: mastered ? 450 : 400,
            curve: Curves.easeInOutCubic,
            duration: Duration(milliseconds: 200),
            child: Padding(
              padding: EdgeInsets.all(48),
              child: Column(mainAxisSize: MainAxisSize.min, children: content),
            ),
          ),
        ),
      ),
    );
  }

  Widget _fab(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.arrow_forward_ios),
      onPressed: () {
        setState(() {
          mastered = true;
        });
      },
    );
  }

  Widget _finished(BuildContext context) {
    final textStyle =
        Theme.of(context).textTheme.subhead.copyWith(color: Colors.black45);
    return WillPopScope(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Congrationaltions 🎉\n\n\nYou've finished Lesson 1 ",
          textAlign: TextAlign.center,
          style: textStyle,
        ),
      ),
      onWillPop: () {
        setState(() {
          mastered = false;
        });
      },
    );
  }
}
