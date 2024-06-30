import 'package:cloud_firestore/cloud_firestore.dart';

class UserLoggedIn {
  String? uid;
  String? name;
  String? email;
  String? password;
  int? role;

  UserLoggedIn({this.uid, this.name, this.email, this.password, this.role});

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      };

  factory UserLoggedIn.fromMap(Map<String, dynamic> map) => UserLoggedIn(
        uid: map['uid'],
        name: map['name'],
        email: map['email'],
        password: map['password'],
        role: map['role'],
      );

  factory UserLoggedIn.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>>? map) {
    return UserLoggedIn(
      uid: map!['uid'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      role: map['role'],
    );
  }

  factory UserLoggedIn.fromDocumentSnapshot(
          DocumentSnapshot<Map<String, dynamic>> map) =>
      UserLoggedIn(
        uid: map['uid'],
        name: map['name'],
        email: map['email'],
        password: map['password'],
        role: map['role'],
      );
}
