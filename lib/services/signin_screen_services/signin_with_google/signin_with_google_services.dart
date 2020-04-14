import 'package:google_sign_in/google_sign_in.dart';

Future<GoogleSignInAuthentication> startSignInWithGoogle() async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GoogleSignInAccount signInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication signInAuth =
      await signInAccount.authentication;
  return signInAuth;
}
