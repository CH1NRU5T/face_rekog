import 'dart:developer';

import 'package:face_rekog/constants/utils.dart';
import 'package:face_rekog/features/face/services/face_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FaceService faceService = FaceService();
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // sign in with email & password
  void signInWithEmailAndPassword(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      faceService.createCollection();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackBar(context, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showSnackBar(context, 'Wrong password provided for that user.');
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    // register with email & password
    // Future registerWithEmailAndPassword(String email, String password) async {
    //   try {
    //     AuthResult result = await _auth.createUserWithEmailAndPassword(
    //         email: email, password: password);
    //     FirebaseUser user = result.user;

    //     // create a new document for the user with the uid
    //     await DatabaseService(uid: user.uid)
    //         .updateUserData('0', 'new crew member', 100);

    //     return _userFromFirebaseUser(user);
    //   } catch (e) {
    //     print(e.toString());
    //     return null;
    //   }
    // }
  }
}
