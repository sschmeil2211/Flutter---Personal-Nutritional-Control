// ignore_for_file: unnecessary_this
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {
  final String activity;
  final double met;

  const ActivityModel({
    required this.activity,
    required this.met,
  });

  Map<String, dynamic> toJson() => {
    'activity': this.activity,
    'met': this.met,
  };

  factory ActivityModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final Map<String, dynamic>? data = document.data();
    return ActivityModel(
      activity: data?['activity'],
      met: (data?['met'] as num).toDouble(),  //
    );
  }
}