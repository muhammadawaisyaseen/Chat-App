import 'dart:io';
import 'package:chat_app/database/auth_api.dart';
import 'package:chat_app/models/user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

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

  //   Stream<List<Product>> retrieveData() {
  //   return _instance.collection(_collection).snapshots().asyncMap((event) {
  //     List<Product> myItems = [];
  //     for (DocumentSnapshot<Map<String, dynamic>> element in event.docs) {
  //       myItems.add(Product.fromMap(element));
  //     }
  //     return myItems;
  //   });
  // }

  // Future<List<UserInformation>> retrieveData() async {
  //   // return _firestoreInstance.collection(_collection).get()
  //   List<UserInformation> user = [];

  // }

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
