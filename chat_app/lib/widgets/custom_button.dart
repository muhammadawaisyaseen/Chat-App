import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({required this.text, required this.onpress, super.key});
  String text;
  VoidCallback onpress;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onpress,
      child: Container(
        width: MediaQuery.of(context).size.width * 1,
        height: 70,
        decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFFf34351), Color(0xFFfd4553)]),
            borderRadius: BorderRadius.circular(50)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
