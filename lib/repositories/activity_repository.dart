import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_nutrition_control/models/models.dart';

class ActivityRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ActivityModel>> getActivities() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore.collection('activities').get();
    return snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) => ActivityModel.fromSnapshot(doc)).toList();
  }
}