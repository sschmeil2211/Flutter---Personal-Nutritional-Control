// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:personal_nutrition_control/models/models.dart';
import 'package:personal_nutrition_control/repositories/repositories.dart';
import 'package:personal_nutrition_control/services/services.dart';

class UserProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService();
  final UserRepository _userRepository = UserRepository();
  UserModel? _user;
  bool? _permissionsGranted;

  UserProvider() {
    loadUser();
  }

  UserModel? get user => _user;
  bool get permissionsGranted => _permissionsGranted ?? false;

  Future<String?> signIn(String email, String password) async {
    String? message = await _authService.signInWithEmailAndPassword(email, password);
    if(message != null) return message;
    await loadUser();
    if(user == null) return "error";
    return null;
  }

  // Registro con correo electrónico y contraseña
  Future<String?> signUp(String email, String password, String username) async {
    String? signUpMessage = await _authService.signUpWithEmailAndPassword(email, password);
    if(signUpMessage != null) return signUpMessage;
    await createUser(email, username);
    return null;
  }

  Future<String?> signOut() async => await _authService.signOut();

  Future<String?> googleSign() async {
    String? message = await _authService.googleSign();
    if(message != null) return message;
    await loadUser();
    if(user == null)
      await createUser(_authService.currentUser?.email ?? '', _authService.currentUser?.email ?? '');
    return null;
  }

  Future<void> createUser(String email, String username) async {
    final User? currentUser = _authService.currentUser;
    if(currentUser == null) return;
    _user = UserModel.newUser(id: currentUser.uid, username: username, email: email);
    await grantPermissions();
    await _userRepository.createUser(_user!);
    notifyListeners();
  }

  Future<void> grantPermissions() async {
    PermissionStatus status = await Permission.activityRecognition.request();
    if(!status.isGranted) return;
    await _sharedPreferencesService.setHasPermission(true);
    _permissionsGranted = true;
    notifyListeners();
  }

  Future<void> revokePermissions() async {
    await _sharedPreferencesService.revokePermission();
    _permissionsGranted = false;
    notifyListeners();
  }

  Future<bool> checkGoogleSignIn() async => await _authService.checkGoogleSign();

  Future<String?> recoveryPassword(String email) async => await _authService.recoveryPassword(email);

  Future<bool> updateUser(UserModel? newUser) async {
    if(_authService.currentUser == null || newUser == null) return false;
    _user = newUser;
    bool successful = await _userRepository.updateUser(_authService.userID, _user!);
    notifyListeners();
    return successful;
  }

  // Obtener información completa del usuario por ID
  Future<void> loadUser() async {
    await checkPermissions();
    if(_authService.currentUser == null) return;
    _user = await _userRepository.getUser(_authService.userID);
    if(_user == null) return;
    notifyListeners();
  }

  Future<void> checkPermissions() async {
    _permissionsGranted = await _sharedPreferencesService.getHasPermission();
    notifyListeners();
  }
}