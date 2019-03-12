import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:yo/person.dart';

class SessionModel extends Model {
  /// Easy access to this model using [ScopedModel.of]
  static SessionModel of(BuildContext context) =>
      ScopedModel.of<SessionModel>(context);

  SessionModel() {
    _autoLogin();
  }

  FirebaseUser _user;

  bool get isUserLoggedIn => _user != null;

  bool get initialized => _initLoginDone;
  bool _initLoginDone = false;

  String get uid => _user?.uid;

  Future<void> googleLogin() async {
    GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await FirebaseAuth.instance.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print("User ${user.email} logged in");
    await _saveToDatabase(user);
    print("Saved to DB");
    _user = await FirebaseAuth.instance.currentUser();
    notifyListeners();
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    _user = null;
    notifyListeners();
  }

  Future<void> _autoLogin() async {
    _user = await FirebaseAuth.instance.currentUser();
    _initLoginDone = true;
    notifyListeners();
  }

  Future<void> _saveToDatabase(FirebaseUser user) {
    Person signedInUser = Person(user.uid, user.displayName, user.photoUrl);
    return Firestore.instance
        .collection(Person.REF)
        .document(user.uid)
        .setData(signedInUser.toJson());
  }
}
