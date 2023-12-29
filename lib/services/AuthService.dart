// ignore_for_file: curly_braces_in_flow_control_structures, avoid_print

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obtener el estado de autenticación del usuario
  /*StreamSubscription<User?> get authStateChanges => _auth
      .authStateChanges()
      .listen((User? user) => authStateChange(user));*/
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Registro con correo electrónico y contraseña
  Future<bool> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user != null;
    } catch (e) {
      return false;
    }
  }

  // Inicio de sesión con correo electrónico y contraseña
  Future<String?> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // El inicio de sesión fue exitoso, devuelve null
    } catch (e) {
      return e.toString(); // Devuelve un mensaje de error si hay un problema
    }
  }

  // Cerrar sesión
  Future<void> signOut() async => await _auth.signOut();

  // Obtener el usuario actual
  User? get currentUser => _auth.currentUser;

  bool isSignedIn() => _auth.currentUser != null;

  void authStateChange(User? user){
    if (user == null)
      print('User is currently signed out!');
    else
      print('User is signed in!');
  }
}