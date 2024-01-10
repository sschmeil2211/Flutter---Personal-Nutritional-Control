import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_nutrition_control/models/day_model.dart';

class DayRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StreamController<List<DayModel>> _daysController = StreamController<List<DayModel>>();

  Stream<List<DayModel>> getDaysStream(String userId) {
    _firestore.collection('users').doc(userId).collection('days').snapshots().listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
      List<DayModel> days = snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) => DayModel.fromSnapshot(doc)).toList();
      _daysController.add(days);
    });
    return _daysController.stream;
  }

  Future<DayModel?> getSpecificDay(String userId, String specificDate) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('days')
        .where('date', isEqualTo: specificDate)
        .limit(1) // Limitar a un solo documento
        .get();
    return snapshot.docs.isNotEmpty ? DayModel.fromSnapshot(snapshot.docs.first) : null;
  }

  Future<void> updateDay(String userId, DayModel day) async => await _firestore
      .collection('users')
      .doc(userId)
      .collection('days')
      .doc(day.id)
      .update(day.toJson());

  Future<void> addDay(String userId, DayModel day) async => await _firestore
      .collection('users')
      .doc(userId)
      .collection('days')
      .doc(day.id)
      .set(day.toJson());
}