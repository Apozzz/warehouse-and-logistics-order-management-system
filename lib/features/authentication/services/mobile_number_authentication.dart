import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MobileNumberAuthentication {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> verifyPhoneNumber(
      String phoneNumber,
      PhoneVerificationCompleted verificationCompleted,
      PhoneVerificationFailed verificationFailed,
      PhoneCodeSent codeSent,
      PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout) async {
    _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<UserCredential?> signInWithCredential(
      PhoneAuthCredential credential) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Failed to sign in with Phone Auth: ${e.message}');
      Fluttertoast.showToast(
          msg: "Failed to sign in with Google: ${e.message}");
      return null;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
