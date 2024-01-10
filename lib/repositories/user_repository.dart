import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_nutrition_control/models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    try{
      await _firestore.collection('users').doc(user.id).set(user.toJson());
    } catch(e){
      return;
    }
  }

  Future<void> updateUser(String userId, UserModel updatedUser) async {
    try {
      await _firestore.collection('users').doc(userId).update(updatedUser.toJson());
    } catch (e) {
      throw e;
    }
  }

  Future<UserModel?> getUser(String userId) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore.collection('users').doc(userId).get();
    if (snapshot.exists) {
      return UserModel.fromSnapshot(snapshot);
    } else {
      return null;
    }
  }
}