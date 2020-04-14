import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:psm_at_stamp/services/firebase_auth_services/signin_with_credential.dart';
import 'package:psm_at_stamp/services/signin_screen_services/signin_with_google/signin_with_google_services.dart';

Future<void> signInWithGoogle() async {
  try {
    final GoogleSignInAuthentication googleSignInAuth =
        await startSignInWithGoogle();
    final AuthCredential authCredential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuth.idToken,
        accessToken: googleSignInAuth.accessToken);
    final AuthResult authResult =
        await firebaseAuthSignInWithCredential(credential: authCredential);
  } on PlatformException catch (e) {
    print(e);
  } catch (e) {
    print(e);
  }
}
