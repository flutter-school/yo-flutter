import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yo/home_page.dart';
import 'package:yo/person.dart';

class LoginPage extends StatefulWidget {
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
            child: Text("Yo!",
                style: Theme.of(context)
                    .textTheme
                    .display4
                    .copyWith(fontWeight: FontWeight.bold)),
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: 64,
          child: Center(
            child:
                _isLoading ? CircularProgressIndicator() : _buildSignInButton(),
          ),
        ),
      ),
    );
  }

  void _onSignInClicked() {
    setState(() {
      _isLoading = true;
    });

    _handleSignIn().then(_saveUserToDatabase).then((_) {
      Navigator.of(context).pushReplacementNamed(HomePage.ROUTE_NAME);
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<FirebaseUser> _handleSignIn() async {
    GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await FirebaseAuth.instance.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return user;
  }

  Future<void> _saveUserToDatabase(FirebaseUser user) {
    Person signedInUser = Person(user.uid, user.displayName, user.photoUrl);
    return Firestore.instance
        .collection(Person.REF)
        .document(user.uid)
        .setData(signedInUser.toJson());
  }
}
