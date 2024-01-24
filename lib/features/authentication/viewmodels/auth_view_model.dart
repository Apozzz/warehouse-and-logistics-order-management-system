import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inventory_system/constants/route_paths.dart';
import 'package:inventory_system/features/authentication/viewmodels/email_password_authentication_view_model.dart';
import 'package:inventory_system/features/authentication/viewmodels/facebook_authentication_view_model.dart';
import 'package:inventory_system/features/authentication/viewmodels/google_authentication_view_model.dart';
import 'package:inventory_system/features/authentication/viewmodels/mobile_number_authentication_view_model.dart';
import 'package:inventory_system/features/user/services/user_service.dart';
import 'package:inventory_system/shared/extensions/navigator_extension.dart';
import 'package:provider/provider.dart';

class AuthViewModel extends ChangeNotifier {
  GoogleAuthViewModel? _googleAuth;
  FacebookAuthViewModel? _facebookAuth;
  MobileNumberAuthViewModel? _mobileAuth;
  EmailPasswordAuthViewModel? _emailPasswordAuth;

  final FirebaseAuth _auth;
  AuthViewModel() : _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;

  Future<void> signInUser(BuildContext context) async {
    final userService = Provider.of<UserService>(context, listen: false);
    print('in sign in');
    print('${_auth.currentUser} -- CURRENT USER');
    if (_auth.currentUser != null) {
      print('ITS NOT NULL');
      final user = await userService
          .getUserModelByFirebaseUserId(_auth.currentUser!.uid);

      if (user == null) {
        await userService.createUser(_auth.currentUser!);
      }
    }
  }

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

    if (_auth.currentUser != null) {
      _auth.signOut();
    }

    notifyListeners();
  }

  Future<void> redirectToCompanyPageIfLoggedIn(BuildContext context) async {
    if (_auth.currentUser != null) {
      Navigator.of(context)
          .pushReplacementNamedNoTransition(RoutePaths.selectCompany);
    }
  }
}
