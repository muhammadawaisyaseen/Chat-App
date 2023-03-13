import 'package:chat_app/models/user_info.dart';
import 'package:chat_app/pages/chat_screen.dart';
import 'package:chat_app/pages/otp_screen.dart';
import 'package:chat_app/pages/register_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class AuthApi {
  static final FirebaseAuth _authInstance = FirebaseAuth.instance;
  static String? _uid=_authInstance.currentUser!.uid;
  static String? get uid => _uid;
  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  static const String _collection = 'User_Information';

  Future<void> verifyNumber(BuildContext context, PhoneNumber number) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: number.phoneNumber,
        verificationCompleted: (_) {
          print('DONE');
        },
        verificationFailed: (e) {
          print('ERROR: ${e.code}');
        },
        codeSent: (String verificationId, int? token) {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) =>
          //         OtpScreen(verificationId: verificationId, number: number),
          //   ),
          // );
        },
        codeAutoRetrievalTimeout: (e) {
          print(e.hashCode);
        });
  }

  Future<void> signInWithCredentialFun(
      BuildContext context,
      String verificationId,
      TextEditingController _otpCodeController,
      PhoneNumber number) async {
    // After verification firebase give you the token
    final credentialToken = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: _otpCodeController.text.toString());
    try {
      User? user =
          (await _authInstance.signInWithCredential(credentialToken)).user;
      if (user != null) {
        _uid = user.uid;
        DocumentSnapshot doc =
            await _firestoreInstance.collection(_collection).doc(_uid).get();
        if (doc.exists) {
          //purana user
          print('PURANA USER');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(),
            ),
          );
        } else {
          // new user
          print('NEW USER');
          // ignore: use_build_context_synchronously
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    RegisterScreen(),
              ));
        }
      } else {
        print('USER IS NOT EXIST');
      }
    } catch (e) {
      //Wrong otp or problem in signIn
      print('ERROR IS: ${e.runtimeType}');
    }
  }

  Future<void> addData(UserInformation information) async {
    try {
      await _firestoreInstance
          .collection(_collection)
          .doc(information.id)
          .set(information.toMap());
    } catch (e) {
      print('ADD DATA ERROR: ${e.hashCode.toString()}');
    }
  }
}
