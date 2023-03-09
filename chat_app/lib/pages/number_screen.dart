import 'package:chat_app/constants/routes.dart';
import 'package:chat_app/pages/otp_verify.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinput/pinput.dart';

class NumberScreen extends StatelessWidget {
  NumberScreen({super.key});
  final TextEditingController _phoneNumberController = TextEditingController();
  // final phone = " ";
  bool loading = false;
  PhoneNumber? number;
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
                children: const [
                  Icon(Icons.arrow_back_ios),
                  SizedBox(
                    width: 140,
                  ),
                  Center(
                    child: Text(
                      'Number',
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
                  'Enter your phone number',
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
                  textFieldController: _phoneNumberController,
                  onInputChanged: (value) {
                    number = value;
                    print(number!.phoneNumber);
                  },
                  inputBorder: InputBorder.none,
                ),
              ),
              Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: number?.phoneNumber,
                        verificationCompleted: (_) {
                          print('DONE');
                        },
                        verificationFailed: (e) {
                          print('ERROR: ${e.code}');
                        },
                        codeSent: (String verificationId, int? token) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OtpVerify(verificationId: verificationId),
                            ),
                          );
                        },
                        codeAutoRetrievalTimeout: (e) {
                          print(e.hashCode);
                        });
                    
                  },
                  child: Text('Send code'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
