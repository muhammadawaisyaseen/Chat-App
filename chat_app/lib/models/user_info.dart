import 'package:cloud_firestore/cloud_firestore.dart';

class UserInformation {
  String name;
  String profile;
  String id;
  String number;
  UserInformation({
    required this.name,
    required this.profile,
    required this.id,
    required this.number,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profile': profile,
      'id': id,
      'number': number,
    };
  }

  factory UserInformation.fromMap(DocumentSnapshot<Map<String, dynamic>> map) {
    return UserInformation(
      name: map.data()?['name'] ?? 'null',
      profile: map.data()?['profile'] ?? '',
      id: map.data()?['id'] ??'',
      number: map.data()?['number'] ??'',
    );
  }
}
