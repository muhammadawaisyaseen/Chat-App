// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class UserInfo {
  String name;
  String image;
  String id;
  String number;
  UserInfo({
    required this.name,
    required this.image,
    required this.id,
    required this.number,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'imageUrl': image,
      'id': id,
      'number': number,
    };
  }

  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      name: map['name'] as String,
      image: map['imageUrl'] as String,
      id: map['id'] as String,
      number: map['number'] as String,
    );
  }
}
