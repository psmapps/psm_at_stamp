import 'package:google_sign_in/google_sign_in.dart';

Future<GoogleSignInAuthentication> startSignInWithGoogle() async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount signInAccount;
  try {
    signInAccount = await googleSignIn.signIn();
  } catch (e) {
    throw e;
  }
  final GoogleSignInAuthentication signInAuth =
      await signInAccount.authentication;
  return signInAuth;
}
