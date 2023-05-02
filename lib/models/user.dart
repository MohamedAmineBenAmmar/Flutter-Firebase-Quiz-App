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
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      firstName: snapshot["firstName"],
      lastName: snapshot["lastName"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
    );
  }
}
