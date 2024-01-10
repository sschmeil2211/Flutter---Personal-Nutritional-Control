// ignore_for_file: unnecessary_this
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_nutrition_control/utils/enum_utils.dart';

class UserModel {
  final String id;
  final String username;
  final String email;
  final GenreType genreType;
  final OnBoardingStatus onBoardingStatus;
  final int targetCalories;
  final String birthdate;
  final String createdAt;
  final String updatedAt;
  final double weight;
  final int height;
  final int waist;
  final int wrist;
  final int weeklyPhysicalActivity;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.genreType,
    required this.onBoardingStatus,
    required this.birthdate,
    required this.targetCalories,
    required this.createdAt,
    required this.updatedAt,
    required this.weight,
    required this.height,
    required this.waist,
    required this.wrist,
    required this.weeklyPhysicalActivity,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': this.username,
    'email': this.email,
    'genreType': this.genreType.toString(),
    'onBoardingStatus': this.onBoardingStatus.toString(),
    'birthdate': this.birthdate,
    'targetCalories': this.targetCalories,
    'createdAt': this.createdAt,
    'updatedAt': this.updatedAt,
    'weight': this.weight,
    'height': this.height,
    'waist': this.waist,
    'wrist': this.wrist,
    'weeklyPhysicalActivity': this.weeklyPhysicalActivity,
  };

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final Map<String, dynamic>? data = document.data();

    return UserModel(
      id: data?['id'],
      username: data?['username'],
      email: data?['email'],
      genreType: getGenreType(data?['genreType']),
      onBoardingStatus: getOnBoardingStatus(data?['onBoardingStatus']),
      birthdate: data?['birthdate'],
      targetCalories: data?['targetCalories'],
      createdAt: data?['createdAt'],
      updatedAt: data?['updatedAt'],
      weight: data?['weight'],
      height: data?['height'],
      waist: data?['waist'],
      wrist: data?['wrist'],
      weeklyPhysicalActivity: data?['weeklyPhysicalActivity']
    );
  }

  UserModel copyFrom({
    String? username,
    GenreType? genreType,
    OnBoardingStatus? onBoardingStatus,
    int? targetCalories,
    String? birthdate,
    String? updatedAt,
    double? weight,
    int? height,
    int? waist,
    int? wrist,
    int? weeklyPhysicalActivity
  }) => UserModel(
    id: this.id,
    email: this.email,
    username: username ?? this.username,
    genreType: genreType ?? this.genreType,
    onBoardingStatus: onBoardingStatus ?? this.onBoardingStatus,
    targetCalories: targetCalories ?? this.targetCalories,
    birthdate: birthdate ?? this.birthdate,
    createdAt: this.createdAt,
    updatedAt: DateTime.now().toString(),
    weight: weight ?? this.weight,
    height: height ?? this.height,
    waist: waist ?? this.waist,
    wrist: wrist ?? this.wrist,
    weeklyPhysicalActivity: weeklyPhysicalActivity ?? this.weeklyPhysicalActivity
  );
}

enum GenreType {
  male,
  female,
}

enum OnBoardingStatus {
  onboarding,
  finalized
}