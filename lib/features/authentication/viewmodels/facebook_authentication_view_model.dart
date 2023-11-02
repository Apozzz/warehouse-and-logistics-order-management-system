import 'package:flutter/material.dart';
import 'package:inventory_system/features/authentication/services/facebook_authentaction.dart';
import 'package:inventory_system/features/authentication/viewmodels/auth_view_model.dart';

class FacebookAuthViewModel extends ChangeNotifier {
  final FacebookAuthentication _auth;
  final AuthViewModel _authViewModel;

  FacebookAuthViewModel(this._auth, this._authViewModel);

  Future<void> signIn() async {
    await _auth.signIn();
    _authViewModel.updateFacebookAuth(this);
    notifyListeners();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _authViewModel.updateFacebookAuth(null);
    notifyListeners();
  }
}
