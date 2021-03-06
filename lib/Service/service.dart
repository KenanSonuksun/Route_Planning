import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FirebaseService extends ChangeNotifier {
  String _uid;
  String _email;

  String get getUid => _uid;
  String get getEmail => _email;

  FirebaseAuth _auth = FirebaseAuth.instance;

  //A function to check that user logged out or logged in
  Future<String> onStartUp() async {
    String retVal = "loggedOut";
    try {
      User firebaseUser = _auth.currentUser;
      _uid = firebaseUser.uid;
      _email = firebaseUser.email;
      retVal = "loggedIn";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  //A function to sign out
  Future<String> signOut() async {
    String retVal = "loggedIn";
    try {
      await _auth.signOut();
      _uid = null;
      _email = null;
      retVal = "loggedOut";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  //A function to sign up
  Future<bool> signUp(String email, String password) async {
    bool retVal = false;
    try {
      UserCredential _authResult = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      if (_authResult.user != null) {
        //await _authResult.user.sendEmailVerification();
        retVal = true;
      }
    } catch (e) {
      print(e);
    }

    return true;
  }

  //A function to login
  Future<bool> logIn(String email, String password) async {
    bool retVal = false;
    try {
      UserCredential _authResult = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      if (_authResult.user != null) {
        if (_authResult.user.emailVerified) {
          _uid = _authResult.user.uid;
          _email = _authResult.user.email;
          retVal = true;
        } else {
          print("verifying is wrong");
        }
      }
    } catch (e) {
      print(e);
    }

    return true;
  }
}
