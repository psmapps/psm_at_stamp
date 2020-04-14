import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<AuthResult> firebaseAuthSignInWithCredential(
    {@required AuthCredential credential}) async {
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
