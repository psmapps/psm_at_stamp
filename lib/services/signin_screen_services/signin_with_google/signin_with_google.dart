import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:psm_at_stamp/components/notification_components/loading_box.dart';
import 'package:psm_at_stamp/screens/home_screens/home_screen.dart';
import 'package:psm_at_stamp/services/logger_services/logger_service.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/PsmAtStampUser_constructure.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/sign_user_in.dart';
import 'package:psm_at_stamp/services/psmatstamp_users_services/sign_user_in_error_handler.dart';
import 'package:psm_at_stamp/services/register_services/psmatstampregister_constructure.dart';
import 'package:psm_at_stamp/services/signin_screen_services/signin_platformexception_handler.dart';
import 'package:psm_at_stamp/services/signin_screen_services/signin_with_google/signin_with_google_services.dart';

Future<void> signInWithGoogle(BuildContext context) async {
  showLoadingBox(context, loadingMessage: "กำลังเข้าสู่ระบบด้วย Google");
  AuthResult _authResult;
  GoogleSignInAuthentication _googleSignInAuth;
  try {
    _googleSignInAuth = await startSignInWithGoogle();
    AuthCredential _authCredential = GoogleAuthProvider.getCredential(
        idToken: _googleSignInAuth.idToken,
        accessToken: _googleSignInAuth.accessToken);
    _authResult =
        await FirebaseAuth.instance.signInWithCredential(_authCredential);
  } on PlatformException catch (exception) {
    Navigator.pop(context);
    return signInPlatformExceptionHandler(context, exception);
  } on NoSuchMethodError catch (e) {
    Navigator.pop(context);
    return logger.d(e);
  }

  try {
    PsmAtStampUser psmAtStampUser = await signUserIn(
      userId: _authResult.user.uid,
      accessToken: _googleSignInAuth.accessToken,
      signInServices: SignInServices.google,
    );
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          psmAtStampUser: psmAtStampUser,
        ),
      ),
    );
  } on PlatformException catch (e) {
    GoogleSignIn().signOut();
    Navigator.pop(context);
    if (e.code == "ACCOUNT_NOT_FOUND") {
      PsmAtStampRegister psmAtStampRegister = new PsmAtStampRegister(
        email: _authResult.user.email,
        profileImage: _authResult.user.photoUrl ??
            "https://firebasestorage.googleapis.com/v0/b/satitprasarnmit-psm-at-stamp.appspot.com/o/user.png?alt=media&token=eb023a2a-0d9e-46f2-8301-ef4e0e20cfee",
        displayName: _authResult.user.displayName ?? "Stamp User",
        userId: _authResult.user.uid,
        signInServices: SignInServices.google,
      );
      return signUserInErrorHandler(
        context,
        exception: e,
        psmAtStampRegister: psmAtStampRegister,
      );
    }
    return signUserInErrorHandler(
      context,
      exception: e,
    );
  }
}
