// ignore_for_file: curly_braces_in_flow_control_structures, avoid_print

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final auth.FirebaseAuth _authInstance = auth.FirebaseAuth.instance;

  // Registro con correo electrónico y contraseña
  Future<String?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      await _authInstance.createUserWithEmailAndPassword(email: email, password: password);
      return null;
    } on auth.FirebaseAuthException catch (e) {
      return e.message;
    } catch(e){
      return e.toString();
    }
  }

  // Inicio de sesión con correo electrónico y contraseña
  Future<String?> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _authInstance.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on auth.FirebaseAuthException catch (e) {
      return e.message;
    } catch(e) {
      return e.toString();
    }
  }

  // Cerrar sesión
  Future<String?> signOut() async {
    try{
      await _authInstance.signOut();
      return null;
    } on auth.FirebaseAuthException catch (e) {
      return e.message;
    } catch(e) {
      return e.toString();
    }
  }

  Future<String?> googleSign() async {
    try {
      GoogleSignInAccount? googleAccount = await GoogleSignIn(scopes: [
        'email',
        'https://www.googleapis.com/auth/fitness.activity.read',
      ]).signIn();
      GoogleSignInAuthentication? googleAuth = await googleAccount?.authentication;
      auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken
      );
      await _authInstance.signInWithCredential(credential);
      return null;
    } on auth.FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<bool> checkGoogleSign() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signInSilently();
      return googleSignInAccount != null; //if var == null, not signed in with google
    } catch (error) {
      return false;
    }
  }

  Future<String?> recoveryPassword(String email) async {
    try{
      await _authInstance.sendPasswordResetEmail(email: email);
      return null;
    } on auth.FirebaseAuthException catch (e) {
      return e.message;
    } catch(e) {
      return e.toString();
    }
  }

  // Obtener el usuario actual
  auth.User? get currentUser => _authInstance.currentUser;
  String get userID => _authInstance.currentUser?.uid ?? '';
}