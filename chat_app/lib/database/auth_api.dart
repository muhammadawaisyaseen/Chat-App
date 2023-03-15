import 'package:chat_app/utilities/utils.dart';
import 'package:chat_app/pages/chat_screen.dart';
import 'package:chat_app/pages/register_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthApi {
  static final FirebaseAuth _authInstance = FirebaseAuth.instance;
  static User? get getCurrentUser => _authInstance.currentUser;
  static String _uid = getCurrentUser!.uid;
  static String get uid => _uid;

  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  FirebaseFirestore get firestoreInstance => _firestoreInstance;

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  static const String _collection = 'user_information';

  Future<void> verifyOTP(
      String verificationId, String otp, BuildContext context) async {
    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);
      final UserCredential authCredetial =
          await _authInstance.signInWithCredential(phoneAuthCredential);
      if (authCredetial.user != null) {
        _uid = authCredetial.user!.uid;
        DocumentSnapshot snapshot =
            await _firestoreInstance.collection(_collection).doc(_uid).get();
        if (snapshot.exists) {
          print('PURANA USER');
          Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatScreen(),
                  ));
        } else {
          print('NEW USER');
           Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterScreen(),
                  ));
        }
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
