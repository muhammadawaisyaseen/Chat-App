import 'package:chat_app/database/user_api.dart';
import 'package:chat_app/pages/otp_screen.dart';
import 'package:chat_app/provider/auth_provider.dart';
import 'package:chat_app/utilities/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthApi {
  static final FirebaseAuth _authInstance = FirebaseAuth.instance;
  static User? get getCurrentUser => _authInstance.currentUser;

 String? _uid = getCurrentUser?.uid;
 String get uid => _uid!;
  

  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  FirebaseFirestore get firestoreInstance => _firestoreInstance;
  // static const String _collection = 'user_information';

  // static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // FirebaseAuth get firebaseAuth => _firebaseAuth;

  Future<void> verifyPhoneNum(BuildContext context) async {
    try {
      await _authInstance.verifyPhoneNumber(
        phoneNumber: Provider.of<AuthProvider>(context, listen: false)
            .phoneNumber!
            .phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          Provider.of<AuthProvider>(context, listen: false).verificationId =
              phoneAuthCredential.verificationId;
        },
        verificationFailed: (FirebaseAuthException error) {
          showSnackBar(context, error.message!);
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          Provider.of<AuthProvider>(context, listen: false).verificationId =
              verificationId;
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OtpScreen(),
              ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  Future<int> verifyOTP(
      String verificationId, String otp, BuildContext context) async {
    int temp = -1;
    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);
      final UserCredential authCredetial =
          await _authInstance.signInWithCredential(phoneAuthCredential);
      if (authCredetial.user != null) {
        _uid = authCredetial.user!.uid;
        DocumentSnapshot snapshot = await UserApi().isUserExist();
        if (snapshot.exists) {
          print('PURANA USER');
          temp = 1;
        } else {
          print('NEW USER');
          temp = 0;
        }
      }
    } catch (e) {
      showSnackBar(context, e.toString());
      temp = -1;
    }
    return temp;
  }
}
