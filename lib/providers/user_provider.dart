// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:personal_nutrition_control/models/models.dart';
import 'package:personal_nutrition_control/repositories/repositories.dart';
import 'package:personal_nutrition_control/services/auth_service.dart';

class UserProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserRepository _userRepository = UserRepository();
  UserModel? _user;

  UserProvider() {
    loadUser();
  }

  UserModel? get user => _user;

  // Obtener el estado de autenticación del usuario
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  Future<String?> signIn(String email, String password) async {
    String? message = await _authService.signInWithEmailAndPassword(email, password);
    if(message != null) return message;
    await loadUser();
    if(user == null) return "error";
    return null;
  }

  Future<String?> signInWithCredential() async {
    String? message = await _authService.signInWithCredential();
    if(message != null) return message;
    await loadUser();
    if(user == null)
      await createUser(_authService.currentUser?.email ?? '', _authService.currentUser?.email ?? '');
    return null;
  }

  // Registro con correo electrónico y contraseña
  Future<String?> signUp(String email, String password, String username) async {
    String? signUpMessage = await _authService.signUpWithEmailAndPassword(email, password);
    if(signUpMessage != null) return signUpMessage;
    await createUser(email, username);
    return null;
  }

  Future<void> createUser(String email, String username) async {
    final User? currentUser = _authService.currentUser;
    if (currentUser != null) {
      _user = UserModel.newUser( id: currentUser.uid, username: username, email: email);
      await _userRepository.createUser(_user!);
      notifyListeners();
    }
  }

  Future<String?> signOut() async => await _authService.signOut();

  Future<String?> recoveryPassword(String email) async => await _authService.recoveryPassword(email);

  Future<bool> updateUser(UserModel? newUser) async {
    if(AuthService().currentUser == null || newUser == null) return false;
    _user = newUser;
    bool successful = await _userRepository.updateUser(_authService.currentUser!.uid, _user!);
    notifyListeners();
    return successful;
  }

  // Obtener información completa del usuario por ID
  Future<void> loadUser() async {
    if(AuthService().currentUser == null) return;
    _user = await _userRepository.getUser(_authService.currentUser!.uid);
    if(_user == null) return;
    notifyListeners();
  }
}