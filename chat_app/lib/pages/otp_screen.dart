import 'dart:math';

import 'package:chat_app/database/auth_api.dart';
import 'package:chat_app/functions/utils.dart';
import 'package:chat_app/pages/chat_screen.dart';
import 'package:chat_app/pages/register_screen.dart';
import 'package:chat_app/provider/auth_provider.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinput/pinput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  OtpScreen({required this.verificationId, super.key});
  final String verificationId;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? otpCode;

  // final PhoneNumber number;
  // final TextEditingController _otpCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      body: SafeArea(
        child: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 26),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start, // |
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // --------------
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back_ios)),
                        const SizedBox(
                          width: 140,
                        ),
                        const Center(
                          child: Text(
                            'OTP',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Center(
                      child: Text(
                        'Enter your otp',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Pinput(
                      length: 6,
                      showCursor: true,
                      defaultPinTheme: PinTheme(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onCompleted: (value) {
                        setState(() {
                          otpCode = value;
                        });
                      },
                    ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //     border: Border.all(
                    //       color: Colors.grey,
                    //     ),
                    //   ),
                    //   child: TextField(
                    //     controller: _otpCodeController,
                    //     decoration: const InputDecoration(hintText: '6 digit code'),
                    //     keyboardType: TextInputType.number,
                    //   ),
                    // ),
                    // const Spacer(),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomButton(
                      text: 'Verify',
                      onpress: () {
                        if (otpCode != null) {
                          print('OTP CODE: ${otpCode}');
                          verifyOtpFuction(context, otpCode!);
                        } else {
                          showSnackBar(context, 'Enter 6 digits code');
                        }
                        // Print('Awais'),
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Don't receive any code?",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      "Resend New code",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),

                    // Center(
                    //   child: ElevatedButton(
                    // onPressed: () async {
                    //   AuthApi().signInWithCredentialFun(
                    //       context, verificationId, _otpCodeController, number);
                    // },
                    //   onPressed: () {},
                    //   child: const Text('Next'),
                    // ),
                    // ),
                  ],
                ),
              ),
      ),
    );
  }

  void verifyOtpFuction(BuildContext context, String userOtp) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.verifyOtp(
        context: context,
        verificationId: widget.verificationId,
        userOtp: userOtp,
        onSuccess: () {
          // check whether user exist in db
          ap.checkingExistingUser().then((bool value) async {
            if (value == true) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(),
                  ));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterScreen(),
                  ));
            }
          });
        });
  }

}
