import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final CollectionReference users = FirebaseFirestore.instance.collection(
    'usersData',
  );

  Future<void> createUser(
    String userId,
    String firstName,
    String lastName,
    String birthDate,
  ) async {
    await users.doc(userId).set({
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate,
      'profileImageUrl': null,
    });
  }
}
