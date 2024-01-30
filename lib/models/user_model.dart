// ignore_for_file: unnecessary_this
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_nutrition_control/utils/utils.dart';

class UserModel {
  final String id;
  final String username;
  final String email;
  final String birthdate;
  final String createdAt;
  final String updatedAt;
  final int weight;
  final int height;
  final int waist;
  final int wrist;
  final double targetCalories;
  final OnBoardingStatus onBoardingStatus;
  final PhysicalActivity weeklyPhysicalActivity;
  final GenderType genderType;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.targetCalories,
    required this.createdAt,
    required this.updatedAt,
    required this.onBoardingStatus,
    required this.genderType,
    required this.birthdate,
    required this.weeklyPhysicalActivity,
    required this.waist,
    required this.wrist,
    required this.height,
    required this.weight,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': this.username,
    'email': this.email,
    'genreType': this.genderType.toString(),
    'onBoardingStatus': this.onBoardingStatus.toString(),
    'birthdate': this.birthdate,
    'targetCalories': this.targetCalories,
    'createdAt': this.createdAt,
    'updatedAt': this.updatedAt,
    'weight': this.weight,
    'height': this.height,
    'waist': this.waist,
    'wrist': this.wrist,
    'weeklyPhysicalActivity': this.weeklyPhysicalActivity.toString(),
  };

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final Map<String, dynamic>? data = document.data();
    return UserModel(
      id: data?['id'],
      username: data?['username'],
      email: data?['email'],
      genderType: getGenderType(data?['genderType']),
      onBoardingStatus: getOnBoardingStatus(data?['onBoardingStatus']),
      birthdate: data?['birthdate'],
      targetCalories: (data?['targetCalories'] as num).toDouble(),
      createdAt: data?['createdAt'],
      updatedAt: data?['updatedAt'],
      weight: data?['weight'],
      height: data?['height'],
      waist: data?['waist'],
      wrist: data?['wrist'],
      weeklyPhysicalActivity: getPhysicalActivityType(data?['weeklyPhysicalActivity'])
    );
  }

  factory UserModel.newUser({
    required String id,
    required String username,
    required String email,
  }) => UserModel(
    id: id,
    username: username,
    email: email,
    createdAt: DateTime.now().toString(),
    updatedAt: DateTime.now().toString(),
    onBoardingStatus: OnBoardingStatus.personal,
    targetCalories: 0,
    genderType: GenderType.male,
    birthdate: DateTime.now().toString(),
    weeklyPhysicalActivity: PhysicalActivity.lessThanHour,
    waist: 0,
    wrist: 0,
    height: 0,
    weight: 0
  );

  UserModel copyFrom({
    String? username,
    GenderType? genderType,
    OnBoardingStatus? onBoardingStatus,
    double? targetCalories,
    String? birthdate,
    String? updatedAt,
    int? weight,
    int? height,
    int? waist,
    int? wrist,
    PhysicalActivity? weeklyPhysicalActivity
  }) => UserModel(
    id: this.id,
    email: this.email,
    username: username ?? this.username,
    genderType: genderType ?? this.genderType,
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

enum GenderType {
  male,
  female,
}

enum PhysicalActivity {
  lessThanHour,
  twoToFive,
  sixToNine,
  tenToTwenty,
  moreThanTwenty
}

enum OnBoardingStatus {
  personal,
  body,
  finalized
}