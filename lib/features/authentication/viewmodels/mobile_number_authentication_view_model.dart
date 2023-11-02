import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventory_system/features/authentication/services/mobile_number_authentication.dart';
import 'package:inventory_system/features/authentication/viewmodels/auth_view_model.dart';

class MobileNumberAuthViewModel extends ChangeNotifier {
  final MobileNumberAuthentication _auth;
  String? _verificationId;
  final AuthViewModel _authViewModel;
  late PhoneVerificationCompleted verificationCompleted;
  late PhoneVerificationFailed verificationFailed;
  late PhoneCodeSent codeSent;
  late PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout;

  MobileNumberAuthViewModel(this._auth, this._authViewModel) {
    verificationCompleted = (PhoneAuthCredential credential) async {
      await _auth.signInWithCredential(credential);
      _authViewModel.updateMobileAuth(this);
      notifyListeners();
    };

    verificationFailed = (FirebaseAuthException e) {
      print("Failed to sign in with Google: $e");
      Fluttertoast.showToast(
          msg: "Failed to sign in with Google: ${e.message}");
    };

    codeSent = (String verificationId, int? resendToken) {
      _verificationId = verificationId;
      notifyListeners();
    };

    codeAutoRetrievalTimeout = (String verificationId) {
      _verificationId = verificationId;
      notifyListeners();
    };
  }

  Future<void> verifyPhoneNumber(
      String phoneNumber, BuildContext context) async {
    await _auth.verifyPhoneNumber(
      phoneNumber,
      verificationCompleted,
      verificationFailed,
      codeSent,
      codeAutoRetrievalTimeout,
    );
  }

  Future<void> verifyCode(String smsCode) async {
    if (_verificationId != null) {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );
      UserCredential? userCredential =
          await _auth.signInWithCredential(credential);
      if (userCredential != null) {
        // Sign in successful, update UI
        notifyListeners();
      } else {
        // Sign in failed, update UI
        notifyListeners();
      }
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _authViewModel.updateMobileAuth(null);
    notifyListeners();
  }
}
