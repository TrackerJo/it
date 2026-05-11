import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> createAccount(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
          return "No user found with that email.";

        case "invalid-credential":
          return "Incorrect email or password";

        default:
          return e.message;
      }
    }
  }

  Future resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //Signout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  bool isUserLoggedIn() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  Future<void> deleteAccount() async {
    await FirebaseAuth.instance.currentUser!.delete();
  }

  Future<String?> reauthenticateUser(String email, String password) async {
    try {
      await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(
        EmailAuthProvider.credential(email: email, password: password),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == "wrong-password") {
        return "Incorrect password";
      }
      return e.message ?? "An error occurred";
    }
    return null;
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.

  String? getUserId() {
    User? user = FirebaseAuth.instance.currentUser;

    return user?.uid;
  }

  Future<String?> getOAuthToken() async {
    final user = FirebaseAuth.instance.currentUser;
    return await user?.getIdToken();
  }

  //listen to auth state changes
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }
}
