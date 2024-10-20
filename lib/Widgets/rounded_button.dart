import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String? text;
  final Color color, textColor;
  final VoidCallback onPressed;

  const RoundedButton(
      {super.key,
      required this.text,
      this.color = Colors.black,
      this.textColor = Colors.white,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      width: size.width * 0.7,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(
            text!,
            style: TextStyle(color: textColor),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          ),
        ),
      ),
    );
  }
}
