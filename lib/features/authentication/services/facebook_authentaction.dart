import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'base_authentication.dart';

class FacebookAuthentication extends BaseAuthentication {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<void> signIn() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final OAuthCredential credential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        await _firebaseAuth.signInWithCredential(credential);
      }
    } catch (error) {
      print("Failed to sign in with Facebook: $error");
      Fluttertoast.showToast(msg: "Failed to sign in with Facebook: $error");
    }
  }

  @override
  Future<void> signOut() async {
    await FacebookAuth.instance.logOut();
    await _firebaseAuth.signOut();
  }
}
