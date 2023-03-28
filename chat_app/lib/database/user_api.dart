import 'dart:io';
import 'package:chat_app/database/auth_api.dart';
import 'package:chat_app/models/user_info.dart';
import 'package:chat_app/pages/chat_board.dart';
import 'package:chat_app/provider/contact_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class UserApi {
  static const String _collection = 'user_information';
  String get collection => _collection;
  static final FirebaseFirestore _firestoreInstance =
      FirebaseFirestore.instance;
  static FirebaseFirestore get firestoreInstance => _firestoreInstance;

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<void> addUserDataToFirebase(UserInformation userInfo) async {
    await _firestoreInstance
        .collection(_collection)
        .doc(userInfo.id)
        .set(userInfo.toMap());
  }

  Future<List<UserInformation>> retrieveData() async {
    List<UserInformation> user = <UserInformation>[];
    final QuerySnapshot<Map<String, dynamic>> doc =
        await _firestoreInstance.collection(_collection).get();
    if (doc.docs.isEmpty) return user;
    for (DocumentSnapshot<Map<String, dynamic>> element in doc.docs) {
      user.add(UserInformation.fromMap(element));
    }
    return user;
  }

  Future<String> uploadProfilePhoto({required File file}) async {
    UploadTask uploadTask =
        _firebaseStorage.ref().child(AuthApi().uid).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<DocumentSnapshot> isUserExist() async {
    DocumentSnapshot snapshot = await _firestoreInstance
        .collection(_collection)
        .doc(AuthApi().uid)
        .get();
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAppUsersList(
      BuildContext context) async {
    //ContactProvider contactPro = Provider.of<Cont>(context,listen: false);
    List<String> temp = await getAppContactsUids();
    return await _firestoreInstance
        .collection(_collection)
        .where(FieldPath.documentId, whereIn: temp)
        .get();
  }
}
