import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EmailPasswordAuthentication {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      Fluttertoast.showToast(msg: "Signed in successfully!");
    } catch (error) {
      Fluttertoast.showToast(msg: "Failed to sign in: $error");
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      Fluttertoast.showToast(msg: "Signed up successfully!");
    } catch (error) {
      Fluttertoast.showToast(msg: "Failed to sign up: $error");
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
