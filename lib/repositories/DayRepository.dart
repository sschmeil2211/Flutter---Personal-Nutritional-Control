import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_nutrition_control/models/DayModel.dart';

class DayRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StreamController<List<DayModel>> _daysController = StreamController<List<DayModel>>();

  //Future<void> addDay(String userId, DayModel day) async => await _firestore.collection('users').doc(userId).collection('days').doc(day.id).set(day.toJson());

  Stream<List<DayModel>> getDaysStream(String userId) {
    StreamController<List<DayModel>> daysController = StreamController<List<DayModel>>();
    _firestore.collection('users').doc(userId).collection('days').snapshots().listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
      List<DayModel> days = snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) => DayModel.fromSnapshot(doc)).toList();
      daysController.add(days);
    });
    return daysController.stream;
  }

  Future<DayModel?> getSpecificDay(String userId, String specificDate) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('days')
        .where('date', isEqualTo: specificDate)
        .limit(1) // Limitar a un solo documento
        .get();
    if (snapshot.docs.isNotEmpty)
      return DayModel.fromSnapshot(snapshot.docs.first);
    else
      return null;
  }

  Future<void> updateDay(String userId, DayModel day) async => await _firestore.collection('users').doc(userId).collection('days').doc(day.id).update(day.toJson());

  Future<void> deleteDay(String userId, String dayId) async => await _firestore.collection('users').doc(userId).collection('days').doc(dayId).delete();

  /*Stream<DayModel?> getSpecificDayStream(String userId, String dayId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('days')
        .doc(dayId)
        .snapshots()
        .map((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      if (snapshot.exists) {
        return DayModel.fromSnapshot(snapshot);
      } else {
        return null;
      }
    });
  }*/

  Stream<DayModel?> getSpecificDayStream(String userId, String specificDate) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('days')
        .where('date', isEqualTo: specificDate)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) => snapshot.docs.isNotEmpty ? DayModel.fromSnapshot(snapshot.docs.first) : null);
  }

  Future<void> addDay(String userId, DayModel day) async {
    await _firestore.collection('users').doc(userId).collection('days').doc(day.id).set(day.toJson());

    // Después de agregar el día, emite un nuevo evento en el stream
    _updateDaysStream(userId);
  }

  void _updateDaysStream(String userId) {
    _firestore.collection('users').doc(userId).collection('days').snapshots().listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
      List<DayModel> days = snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) => DayModel.fromSnapshot(doc)).toList();
      _daysController.add(days);
    });
  }
}