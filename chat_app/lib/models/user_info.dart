// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserInformation {
  String name;
  String profile;
  String id;
  // String number;
  UserInformation({
    required this.name,
    required this.profile,
    required this.id,
    // required this.number,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profile': profile,
      'id': id,
      // 'number': number,
    };
  }

  factory UserInformation.fromMap(DocumentSnapshot<Map<String, dynamic>> map) {
    return UserInformation(
      name: map.data()?['name'] as String,
      profile: map.data()?['profile'] as String,
      id: map.data()?['id'] as String,
      // number: map.data()?['number'] as String,
    );
  }
}
