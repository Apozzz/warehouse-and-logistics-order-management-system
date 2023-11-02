import 'package:flutter/material.dart';
import 'package:inventory_system/features/authentication/services/email_password_authentication.dart';
import 'package:inventory_system/features/authentication/viewmodels/auth_view_model.dart';

class EmailPasswordAuthViewModel extends ChangeNotifier {
  final EmailPasswordAuthentication _auth;
  String _email = '';
  String _password = '';
  final AuthViewModel _authViewModel;

  EmailPasswordAuthViewModel(this._auth, this._authViewModel);

  void updateEmail(String email) {
    _email = email;
  }

  void updatePassword(String password) {
    _password = password;
  }

  Future<void> signIn() async {
    await _auth.signIn(_email, _password);
    _authViewModel.updateEmailPasswordAuth(this);
    notifyListeners();
  }

  Future<void> signUp() async {
    await _auth.signUp(_email, _password);
    notifyListeners();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _authViewModel.updateEmailPasswordAuth(null);
    notifyListeners();
  }
}
