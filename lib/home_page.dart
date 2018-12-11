import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:yo/person.dart';

class HomePage extends StatefulWidget {
  static const ROUTE_NAME = "/home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  DateTime _lastYoSent = DateTime(0);
  FirebaseUser _currentUser;

  AnimationController _controller;

  List<Color> colors = [
    Color(0xFFF8B195),
    Color(0xFFF67280),
    Color(0xFFC06C84),
    Color(0xFF6C5B7B),
    Color(0xFF355C7D),
    Color(0xFF34495D),
  ];

  Widget _buildListItem(Person person) {
    return Material(
      color: colors[person.name.codeUnitAt(0) % 6],
      child: InkWell(
        onTap: () => _sendYo(person),
        child: Container(
          height: 120,
          padding: EdgeInsets.all(24),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(person.photoUrl, width: 48, height: 48)),
              SizedBox(width: 24),
              Flexible(
                child: Text(
                  _extractFirstName(person.name),
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(fontSize: 32, letterSpacing: 2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return FutureBuilder(
        future: Firestore.instance
            .collection(Person.REF)
            .orderBy("name")
            .getDocuments(),
        builder: (context, data) {
          if (data.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          QuerySnapshot snapshot = data.data;
          List<Widget> items = snapshot.documents
              .map((data) => Person.fromJson(data.data))
              .map(_buildListItem)
              .toList();

          return ListView(children: items);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFF6C5B7B),
      body: _buildListView(),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFFF67280),
          child: Icon(Icons.share),
          onPressed: () => _showSnackbar(
              "Please tell your friends about this app in real life 💬")),
    );
  }

  @override
  void initState() {
    _registerPush();
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _extractFirstName(String displayName) {
    if (displayName.indexOf(" ") > 0) {
      return displayName.toUpperCase().substring(0, displayName.indexOf(" "));
    } else {
      return displayName.toUpperCase();
    }
  }

  void _sendYo(Person person) {
    if (_currentUser == null) return;
    if (DateTime.now().difference(_lastYoSent).inSeconds < 5) {
      _showSnackbar("Whoa! You can't play the yo-yo all the time 💥");
    } else {
      _lastYoSent = DateTime.now();
      // TODO: Replace with your own cloud function URL:
      get('https://<INSERT YOUR CLOUD FUNCTION URL HERE>/sendYo?'
          'fromUid=${_currentUser.uid}&toUid=${person.uid}');
      _showSnackbar("Yo sent to ${person.name} ✌");
    }
  }

  void _showSnackbar(String text) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(text),
      duration: Duration(milliseconds: 1500),
    ));
  }

  void _registerPush() {
    FirebaseAuth.instance.currentUser().then((user) {
      _currentUser = user;
      return FirebaseMessaging().getToken().then((token) {
        Firestore.instance
            .collection("tokens")
            .document(user.uid)
            .setData({'token': token});
      });
    });
  }
}
