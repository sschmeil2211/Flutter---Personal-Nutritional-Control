import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_nutrition_control/models/DayModel.dart';

class DayRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addDay(String userId, DayModel day) async => await _firestore.collection('users').doc(userId).collection('days').doc(day.id).set(day.toJson());

  Future<List<DayModel>> getDays(String userId) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore.collection('users').doc(userId).collection('days').get();
    return snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) => DayModel.fromSnapshot(doc)).toList();
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
}