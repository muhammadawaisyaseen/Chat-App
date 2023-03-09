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
                  // Icon(Icons.arrow_back_ios),
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
                child: InternationalPhoneNumberInput(
                  hintText: '6 digit code',
                  onInputChanged: (value) {},
                  inputBorder: InputBorder.none,
                ),
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    // After verification firebase give you the token
                    final credentialToken = PhoneAuthProvider.credential(
                      verificationId: verificationId,
                      smsCode: _otpCodeController.text.toString(),
                    );
                    try {
                      print('DONE HY BAI');
                      await FirebaseAuth.instance
                          .signInWithCredential(credentialToken);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddNameScreen(),
                          ));
                    } catch (e) {
                      print('ERROR: ${e.runtimeType}');
                      // print(e.hashCode);
                    }
                  },
                  child: Text('Verify'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
