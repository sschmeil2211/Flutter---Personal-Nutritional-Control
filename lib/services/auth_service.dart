// ignore_for_file: curly_braces_in_flow_control_structures, avoid_print

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final auth.FirebaseAuth _authInstance = auth.FirebaseAuth.instance;

  // Obtener el estado de autenticación del usuario
  Stream<auth.User?> get authStateChanges => _authInstance.authStateChanges();

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

  Future<String?> signInWithCredential() async {
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

  Future<String?> recoveryPassword(String email) async {
    try{
      await _authInstance.sendPasswordResetEmail(email: email);
      return null;
    }on auth.FirebaseAuthException catch (e) {
      return e.message;
    } catch(e) {
      return e.toString();
    }
  }

  // Obtener el usuario actual
  auth.User? get currentUser => _authInstance.currentUser;

  bool isSignedIn() => _authInstance.currentUser != null;

  void authStateChange(auth.User? user){
    if (user == null)
      print('User is currently signed out!');
    else
      print('User is signed in!');
  }
}