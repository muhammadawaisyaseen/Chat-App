import 'dart:io';
import 'package:chat_app/database/auth_api.dart';
import 'package:chat_app/models/user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserApi {
  static const String _collection = 'user_information';
  static final FirebaseFirestore _firestoreInstance =
      FirebaseFirestore.instance;

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<void> addUserDataToFirebase(UserInformation userInfo) async {
    await _firestoreInstance
        .collection(_collection)
        .doc(userInfo.id)
        .set(userInfo.toMap());
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
}
