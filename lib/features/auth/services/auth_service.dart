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
      } else {
        showSnackBar(context, e.message.toString());
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // register with email & password
  void registerWithEmailAndPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      showSnackBar(context, 'Registered successfully, please login');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showSnackBar(context, 'Email already in use.');
      } else if (e.code == 'weak-password') {
        showSnackBar(context, 'Password is too weak.');
      } else {
        showSnackBar(context, e.message.toString());
      }
    } catch (e) {
      return null;
    }
  }
}
