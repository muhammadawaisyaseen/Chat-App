import 'dart:io';

import 'package:chat_app/models/user_info.dart';
import 'package:chat_app/provider/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserApi {
  static const String _collection = 'user_information';
  static final FirebaseFirestore _firestoreInstance =
      FirebaseFirestore.instance;

  Future<void> addUserDataToFirebase(UserInformation userInfo) async {
    await _firestoreInstance
        .collection(_collection)
        .doc(userInfo.id)
        .set(userInfo.toMap());
  }

  //upload image and getting url
  Future<String> uploadProfilePhoto({required File file})async{
    UploadTask uploadTask =
          AuthProvider().firebaseStorage.ref().child(AuthProvider().uid!).putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
  }
}
