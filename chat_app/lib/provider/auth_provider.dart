import 'dart:io';
// import 'dart:js';
// import 'dart:js';

import 'package:chat_app/database/auth_api.dart';
import 'package:chat_app/database/user_api.dart';
import 'package:chat_app/pages/chat_screen.dart';
import 'package:chat_app/utilities/utils.dart';
import 'package:chat_app/models/user_info.dart';
import 'package:chat_app/pages/otp_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
// import 'package:provider/provider.dart';

class AuthProvider extends ChangeNotifier {
// variables
  PhoneNumber? _phoneNumber;
  PhoneNumber get phoneNumber => _phoneNumber!;
  String? _verificationId;
  String? _otp;
  String get otp => _otp!;
  TextEditingController _nameController = TextEditingController();
  TextEditingController get nameController => _nameController;
  File? _image;
  File get image => _image!;

  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseAuth get firebaseAuth => _firebaseAuth;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  static String? _uid = _firebaseAuth.currentUser!.uid;
  String? get uid => _uid;

  // static String? _downloadUrl = _firebaseAuth.currentUser!.photoURL;
  // String get downloadUrlGetter => _downloadUrl ?? " ";

  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  FirebaseFirestore get firestoreInstance => _firestoreInstance;
  static const String _collection = 'user_information';

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  FirebaseStorage get firebaseStorage => _firebaseStorage;
  UserInformation? _information;
  UserInformation get information => _information!;

  //////////////
  ///
  // Future<void> verifyOtp({
  //   required BuildContext context,
  //   required String verificationId,
  //   required String userOtp,
  //   required Function onSuccess,
  // }) async {
  //   _isLoading = true;
  //   try {
  //     PhoneAuthCredential cred = PhoneAuthProvider.credential(
  //         verificationId: verificationId, smsCode: userOtp);
  //     User? user = (await _firebaseAuth.signInWithCredential(cred)).user;
  //     if (user != null) {
  //       _uid = user.uid;
  //       onSuccess();
  //     }
  //     _isLoading = false;
  //     notifyListeners();
  //   } on FirebaseAuthException catch (e) {
  //     showSnackBar(context, e.message.toString());
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  ////////////////
  ///
  // Future<bool> checkingExistingUser() async {
  //   DocumentSnapshot snapshot =
  //       await _firestoreInstance.collection(_collection).doc(_uid).get();
  //   if (snapshot.exists) {
  //     print('PURANA USER');
  //     return true;
  //   } else {
  //     print('New USER');
  //     return false;
  //   }
  // }

  ///////////////
  ///

  void saveUserDataToFirebase({
    required BuildContext context,
    required UserInformation info,
    required File profilePic,
    required Function onSuccess,
    // required String downloadUrl,
  }) async {
    _isLoading = true;
    notifyListeners();
    print('ENTERED IN saveUserDataToFirebase');
    try {
      //upload image to storage
      // await storeFileToStorage(_uid!, profilePic).;
      UploadTask uploadTask =
          _firebaseStorage.ref().child(_uid!).putFile(profilePic);
      TaskSnapshot snapshot = await uploadTask;
      // _downloadUrl = await snapshot.ref.getDownloadURL();
      // print('DOWNLOAD URL: ${_downloadUrl}');
      print('MODEL DATA: ${info}');
      // .then((String value) {
      //   info.profile = value;
      //   info.number = _firebaseAuth.currentUser!.phoneNumber!;
      //   info.id = _uid!;
      // });

      // _information = info;

      await _firestoreInstance
          .collection(_collection)
          .doc(info.id)
          .set(info.toMap())
          .then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  ////////////
  ///
  // Future<String> storeFileToStorage(String ref, File file) async {
  //   UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
  //   TaskSnapshot snapshot = await uploadTask;
  //   String downloadUrl = await snapshot.ref.getDownloadURL();
  //   return downloadUrl;
  // }

  /// New Auth Provider
  onPhoneNumberChange(PhoneNumber value) {
    _phoneNumber = value;
    notifyListeners();
  }

  onPinPutCompleted(String value) {
    _otp = value;
    // notifyListeners();
  }

  Future<void> verifyPhoneNum(BuildContext context) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: _phoneNumber!.phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          // await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          _verificationId = phoneAuthCredential.verificationId;
        },
        verificationFailed: (FirebaseAuthException error) {
          // throw Exception(error.message);
          showSnackBar(context, error.message!);
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          _verificationId = verificationId;
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpScreen(),
              ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  Future<void> verifyOtpFun(String otp, BuildContext context) async {
    // if (_verificationId == null) return 0;
    await AuthApi().verifyOTP(_verificationId!, otp, context);
    // return num;
  }
//-------------------------

  Future<void> onRegister(BuildContext context) async {
    print('onRegister FUN');
    String? url;
    url=await UserApi().uploadProfilePhoto(file: _image!);
    UserInformation info = UserInformation(
      name: _nameController.text.trim(),
      id: _uid!,
      number: _phoneNumber.toString(),
      profile: url,
    );
    if (_image != null) {
      UserApi().addUserDataToFirebase(info);
    } else {
      showSnackBar(context, 'Please upload your profile photo');
    }
  }

  //For selecting image
  void selectImage(BuildContext context) async {
    _image = await pickImage(context);
  }

  // Future<Future> fun(BuildContext context, String route) async {
  //   return Navigator.of(context).push(route as Route<Object?>);
  // }
}
