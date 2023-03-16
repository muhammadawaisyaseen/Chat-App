import 'package:chat_app/database/auth_api.dart';
import 'package:chat_app/provider/auth_provider.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

class NumberScreen extends StatelessWidget {
  const NumberScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFf4f4f4),
        body: Consumer<AuthProvider>(
          builder: (context, AuthProvider authPro, _) {
            return Padding(
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
                    height: 10,
                  ),
                  const Center(
                    child: Text(
                      'This dummy app will send an SMS messege to verify your phone number, select your country and enter your phone number',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade700,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: InternationalPhoneNumberInput(
                      initialValue: PhoneNumber(
                        phoneNumber: authPro.phoneNumber.toString(),
                        isoCode: 'PK',
                      ),
                      keyboardType: TextInputType.phone,
                      onInputChanged: (PhoneNumber value) {
                        authPro.onPhoneNumberChange(value);
                        print('PHONE NUMBER:${authPro.phoneNumber}');
                      },
                      inputBorder: InputBorder.none,
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: CustomButton(
                      text: 'SEND',
                      onpress: () async {
                        await AuthApi().verifyPhoneNum(context);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // void sendPhoneNumber() {
  //   final ap = Provider.of<AuthProvider>(context, listen: false);
  // String phoneNumber
  // }
}
