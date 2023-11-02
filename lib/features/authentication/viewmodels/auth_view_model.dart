import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inventory_system/features/authentication/viewmodels/email_password_authentication_view_model.dart';
import 'package:inventory_system/features/authentication/viewmodels/facebook_authentication_view_model.dart';
import 'package:inventory_system/features/authentication/viewmodels/google_authentication_view_model.dart';
import 'package:inventory_system/features/authentication/viewmodels/mobile_number_authentication_view_model.dart';

class AuthViewModel extends ChangeNotifier {
  GoogleAuthViewModel? _googleAuth;
  FacebookAuthViewModel? _facebookAuth;
  MobileNumberAuthViewModel? _mobileAuth;
  EmailPasswordAuthViewModel? _emailPasswordAuth;

  final FirebaseAuth _auth;
  AuthViewModel() : _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;

  void updateGoogleAuth(GoogleAuthViewModel? googleAuth) {
    _googleAuth = googleAuth;
    notifyListeners();
  }

  void updateFacebookAuth(FacebookAuthViewModel? facebookAuth) {
    _facebookAuth = facebookAuth;
    notifyListeners();
  }

  void updateMobileAuth(MobileNumberAuthViewModel? mobileAuth) {
    _mobileAuth = mobileAuth;
    notifyListeners();
  }

  void updateEmailPasswordAuth(EmailPasswordAuthViewModel? emailPasswordAuth) {
    _emailPasswordAuth = emailPasswordAuth;
    notifyListeners();
  }

  void signOut() {
    _googleAuth?.signOut();
    _facebookAuth?.signOut();
    _mobileAuth?.signOut();
    _emailPasswordAuth?.signOut();
    notifyListeners();
  }
}
