import 'package:flutter/material.dart';
import 'package:inventory_system/features/authentication/services/google_authentication.dart';
import 'package:inventory_system/features/authentication/viewmodels/auth_view_model.dart';

class GoogleAuthViewModel extends ChangeNotifier {
  final GoogleAuthentication _auth;
  final AuthViewModel _authViewModel;

  GoogleAuthViewModel(this._auth, this._authViewModel);

  Future<void> signIn() async {
    await _auth.signIn();
    _authViewModel.updateGoogleAuth(this);
    notifyListeners();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _authViewModel.updateGoogleAuth(null);
    notifyListeners();
  }
}
