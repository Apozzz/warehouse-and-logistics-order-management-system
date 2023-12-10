import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class AuthGuard {
  final FirebaseAuth _auth;

  AuthGuard(this._auth);

  bool isAuthenticated() {
    return _auth.currentUser != null;
  }
}
