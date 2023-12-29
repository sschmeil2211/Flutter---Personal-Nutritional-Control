import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:personal_nutrition_control/models/UserModel.dart';
import 'package:personal_nutrition_control/repositories/UserRepository.dart';
import 'package:personal_nutrition_control/services/AuthService.dart';

class UserProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserRepository _userRepository = UserRepository();
  UserModel? _user;

  UserProvider() {
    _loadUser();
  }

  UserModel? get user => _user;

  // Obtener el estado de autenticación del usuario
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  Future<String?> signIn(String email, String password) async {
    try{
      await _authService.signInWithEmailAndPassword(email, password);
      return null;
    }
    catch (e) {
      return e.toString(); // Devuelve un mensaje de error si hay un problema
    }
  }

  // Registro con correo electrónico y contraseña
  Future<void> signUp(String email, String password, String username) async {
    try {
      bool userSignedUp = await _authService.signUpWithEmailAndPassword(email, password);
      final User? currentUser = _authService.currentUser;
      if (currentUser != null && userSignedUp) {
        _user = UserModel(
          id: currentUser.uid,
          email: email,
          username: username,
          targetCalories: 0, // Aquí puedes poner valores predeterminados
          weight: 0,
          height: 0,
          birthdate: DateTime(1997, 4, 4).toString(),
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString(),
          waist: 0,
          wrist: 0,
          weeklyPhysicalActivity: 0,
          genreType: GenreType.male,
          onBoardingStatus: OnBoardingStatus.onboarding,
        );
        await _userRepository.createUser(_user!);
      }
    } catch (e) {
      return; // Devuelve un mensaje de error si hay un problema
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      if(AuthService().currentUser == null) return;
      await _userRepository.updateUser(_authService.currentUser!.uid, user);
      notifyListeners();
    } catch (e) {
      print('Error en updateUser: $e');
    }
  }

  // Obtener información completa del usuario por ID
  Future<void> _loadUser() async {
    if(AuthService().currentUser == null) return;
    _user = await _userRepository.getUser(_authService.currentUser!.uid);
    if(_user == null) return;
  }
}