import 'dart:io';
import 'package:chat_app/database/auth_api.dart';
import 'package:chat_app/database/user_api.dart';
import 'package:chat_app/pages/chat_board.dart';
import 'package:chat_app/pages/chat_screen.dart';
import 'package:chat_app/pages/register_screen.dart';
import 'package:chat_app/utilities/utils.dart';
import 'package:chat_app/models/user_info.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:permission_handler/permission_handler.dart';

class AuthProvider extends ChangeNotifier {
  PhoneNumber? _phoneNumber;
  PhoneNumber? get phoneNumber => _phoneNumber;

  String? _otp;
  String get otp => _otp!;
  final TextEditingController _nameController = TextEditingController();
  TextEditingController get nameController => _nameController;
  File? _image;
  File? get image => _image;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _verificationId = '';
  String? get verificationId => _verificationId;
  set verificationId(String? s) {
    _verificationId = s;
  }

  onPhoneNumberChange(PhoneNumber value) {
    _phoneNumber = value;
  }

  onPinPutCompleted(String value) {
    _otp = value;
  }

  Future<void> verifyOtpFun(BuildContext context) async {
    int temp = await AuthApi().verifyOTP(_verificationId!, otp, context);
    if (temp == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatBoardScreen(),
        ),
      );
    } else if (temp == 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RegisterScreen(),
          ));
    }
  }

  Future<void> onRegister(BuildContext context) async {
    // print('onRegister FUN');
    String? url;
    url = await UserApi().uploadProfilePhoto(file: _image!);
    UserInformation info = UserInformation(
      name: _nameController.text.trim(),
      id: AuthApi().uid,
      number: _phoneNumber!.phoneNumber.toString(),
      profile: url,
    );
    if (_image != null) {
      UserApi().addUserDataToFirebase(info);
    } else {
      showSnackBar(context, 'Please upload your profile photo');
    }
  }

  void selectImage(BuildContext context) async {
    _image = await pickImage(context);
  }
}
