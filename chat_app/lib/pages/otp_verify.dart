import 'package:chat_app/database/auth_api.dart';
import 'package:chat_app/pages/chat_screen.dart';
import 'package:chat_app/pages/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinput/pinput.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OtpVerify extends StatelessWidget {
  OtpVerify({required this.verificationId, super.key});
  final String verificationId;
  final TextEditingController _otpCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 26),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // |
            crossAxisAlignment: CrossAxisAlignment.start, // --------------
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
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: TextField(
                  controller: _otpCodeController,
                  decoration: const InputDecoration(hintText: '6 digit code'),
                  keyboardType: TextInputType.number,
                ),
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    AuthApi().signInWithCredentialFun(
                        context, verificationId, _otpCodeController);
                  
                  },
                  child: const Text('Verify'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
