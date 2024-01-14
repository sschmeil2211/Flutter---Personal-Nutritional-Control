// ignore_for_file: curly_braces_in_flow_control_structures, avoid_print

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:personal_nutrition_control/exceptions/auth_exceptions.dart';

class AuthService {
  final auth.FirebaseAuth _authInstance = auth.FirebaseAuth.instance;

  // Obtener el estado de autenticación del usuario
  /*StreamSubscription<User?> get authStateChanges => _auth
      .authStateChanges()
      .listen((User? user) => authStateChange(user));*/
  Stream<auth.User?> get authStateChanges => _authInstance.authStateChanges();

  // Registro con correo electrónico y contraseña
  Future<String?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      await _authInstance.createUserWithEmailAndPassword(email: email, password: password);
      return null;
    } on auth.FirebaseAuthException catch (e) {
      return e.message.toString();
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

/*
class AuthService extends GetxController{
  static AuthService get instance => Get.find();

  final f_auth.FirebaseAuth _firebaseAuth = f_auth.FirebaseAuth.instance;

  String? get currentID => _firebaseAuth.currentUser?.uid;
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on f_auth.FirebaseAuthException catch (e) {
      throw Exception('Error de firebase al cerrar sesion: $e');
    } catch(e){
      throw Exception('Error al cerrar sesion: $e');
    }
  }
}
 */