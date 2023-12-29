// ignore_for_file: unnecessary_this
import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseModel {
  final String id;
  final String name;
  //final String exerciseType;
  final int duration;
  final int burnedCalories;

  const ExerciseModel({
    required this.id,
    required this.name,
    required this.duration,
    required this.burnedCalories,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': this.name,
    'duration': this.duration,
    'burnedCalories': this.burnedCalories,
  };

  factory ExerciseModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final Map<String, dynamic>? data = document.data();
    return ExerciseModel(
      id: data?['id'],
      name: data?['name'],
      duration: data?['duration'],
      burnedCalories: data?['burnedCalories'],
    );
  }
}