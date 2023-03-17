import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {required this.width,
      required this.height,
      required this.text,
      required this.onpress,
      required this.btnColor,
      required this.textfontSize,
      required this.textColor,
      
      super.key});
  String text;
  double width;
  double height;
  Color btnColor;
  double textfontSize;
  Color textColor;
  VoidCallback onpress;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onpress,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: btnColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: textfontSize,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
