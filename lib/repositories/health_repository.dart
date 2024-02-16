import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_nutrition_control/models/models.dart';

class HealthRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StreamController<List<HealthModel>> _healthController = StreamController<List<HealthModel>>();

  Stream<List<HealthModel>> getHealthStream(String userId) {
    _firestore.collection('users').doc(userId).collection('health').snapshots().listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
      List<HealthModel> health = snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) => HealthModel.fromSnapshot(doc)).toList();
      _healthController.add(health);
    });
    return _healthController.stream;
  }

  Future<HealthModel?> getSpecificHealth(String userId, DateTime specificDate) async {
    String date = '${specificDate.year}-${specificDate.month}-${specificDate.day}';
    final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('health')
        .where('date', isEqualTo: date)
        .limit(1) // Limitar a un solo documento
        .get();
    return snapshot.docs.isNotEmpty ? HealthModel.fromSnapshot(snapshot.docs.first) : null;
  }

  Future<void> updateHealth(String userId, String docId, HealthModel health) async => await _firestore
      .collection('users')
      .doc(userId)
      .collection('health')
      .doc(docId)
      .update(health.toJson());

  Future<void> addHealth(String userId, String docId, HealthModel health) async => await _firestore
      .collection('users')
      .doc(userId)
      .collection('health')
      .doc(docId)
      .set(health.toJson());
}