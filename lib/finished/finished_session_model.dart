import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:yo/person.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FinishedSessionModel extends Model {
  /// Easy access to this model using [ScopedModel.of]
  static FinishedSessionModel of(BuildContext context) =>
      ScopedModel.of<FinishedSessionModel>(context);

  FinishedSessionModel() {
    _autoLogin();
  }

  /// the user model when a user is singed in. Otherwise `null`
  FirebaseUser _user;

  /// `true` when the user is signed in
  bool get isUserLoggedIn => _user != null;

  /// `true` after the sign in initialization is done and this model actually
  /// known whether the user is signed in or not.
  bool get initialized => _initLoginDone;
  bool _initLoginDone = false;

  /// the unique id of the signed in user or `null` when signed out
  String get uid => _user?.uid;

  /// starts the Google login flow, completes without error when sign in was
  /// successful.
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
    _registerPush();
  }

  /// signs the user out of the app
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    _user = null;
    notifyListeners();
  }

  Future<void> _autoLogin() async {
    _user = await FirebaseAuth.instance.currentUser();
    if (_user != null) {
      _registerPush();
    }
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

  Future<void> _registerPush() async {
    if (_user == null) {
      throw "Not implemented";
    }
    final fmToken = await FirebaseMessaging().getToken();
    Firestore.instance
        .collection("tokens")
        .document(_user.uid)
        .setData({'token': fmToken});
    print("registered firebase messaging for ${_user.email}");
  }
}
