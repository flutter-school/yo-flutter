import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:yo/friends_page.dart';
import 'package:yo/person.dart';
import 'package:yo/user_model.dart';

class LoginPage extends StatefulWidget {
  static const ROUTE_NAME = "/login";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  Widget _buildSignInButton() {
    return MaterialButton(
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.person),
              SizedBox(width: 8),
              Text("Login with Google"),
            ],
          ),
        ),
        onPressed: _onSignInClicked);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF6C5B7B),
        body: Container(
          child: Center(
            child: Text("Yo!", style: Theme.of(context).textTheme.display4.copyWith(fontWeight: FontWeight.bold)),
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: 64,
          child: Center(
            child: _isLoading ? CircularProgressIndicator() : _buildSignInButton(),
          ),
        ),
      ),
    );
  }

  void _onSignInClicked() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ScopedModel.of<UserModel>(context).googleLogin();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
