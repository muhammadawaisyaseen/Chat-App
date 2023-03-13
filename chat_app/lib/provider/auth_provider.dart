import 'package:chat_app/functions/snackbar.dart';
import 'package:chat_app/pages/otp_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
// import 'package:provider/provider.dart';

class AuthProvider extends ChangeNotifier {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  static String? _uid = _firebaseAuth.currentUser!.uid;
  static String? get uid => _uid;

  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  static const String _collection = 'User_Information';

  // String? _uid=_firebaseAuth.currentUser!.uid;
  // String get uid => _uid;
  Future<void> signInWithPhone(
      BuildContext context, PhoneNumber mynumber) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: mynumber.phoneNumber,
        verificationCompleted: (phoneAuthCredential) async {
          await _firebaseAuth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {
          throw Exception(error.message);
        },
        codeSent: (verificationId, forceResendingToken) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpScreen(verificationId: verificationId),
              ));
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  //////////////
  ///
  Future<void> verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    try {
      PhoneAuthCredential cred = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);
      User? user = (await _firebaseAuth.signInWithCredential(cred)).user;
      if (user != null) {
        _uid = user.uid;
        onSuccess();
      }
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  ////////////////
  ///
  Future<bool> checkingExistingUser() async {
    DocumentSnapshot snapshot =
        await _firestoreInstance.collection(_collection).doc(_uid).get();
    if (snapshot.exists) {
      print('PURANA USER');
      return true;
    } else {
      print('New USER');
      return false;
    }
  }
}
