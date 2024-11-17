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
      margin: const EdgeInsets.symmetric(vertical: 4),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
          ),
          child: Text(
            text!,
            style: TextStyle(color: textColor, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
