import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String firstName;
  final String lastName;

  const User(
      {required this.uid,
      required this.photoUrl,
      required this.email,
      required this.lastName,
      required this.firstName});

  Map<String, dynamic> toJson() => {
        "lastName": lastName,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "firstName": firstName,
      };

  static User fromSnap(DocumentSnapshot snap) {
    final data = snap.data();
    if (data != null) {
      final dataMap = data as Map<String, dynamic>;
      // Use dataMap
      return User(
        firstName: dataMap["firstName"],
        lastName: dataMap["lastName"],
        uid: dataMap["uid"],
        email: dataMap["email"],
        photoUrl: dataMap["photoUrl"],
      );
    } else {
      // Handle null data
      return null as User;
    }
  }
}
