import 'package:flutter/material.dart';

class AlreadyHaveAccount extends StatelessWidget {
  final bool login;
  final VoidCallback onPress;
  const AlreadyHaveAccount(
      {super.key, this.login = true, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          login ? "Already have an account? " : "Don't have an account? ",
          style: TextStyle(
              fontSize: 15, fontStyle: FontStyle.italic, color: Colors.black),
        ),
        GestureDetector(
          onTap: onPress,
          child: Text(
            login ? " Sign In" : " Sign Up",
            style: TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
