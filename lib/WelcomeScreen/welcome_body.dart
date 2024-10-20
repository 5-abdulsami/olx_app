import 'package:flutter/material.dart';
import 'package:olx_app/LoginScreen/login_screen.dart';
import 'package:olx_app/SignupScreen/signup_screen.dart';
import 'package:olx_app/WelcomeScreen/welcome_background.dart';
import 'package:olx_app/Widgets/rounded_button.dart';

class WelcomeBody extends StatelessWidget {
  const WelcomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WelcomeBackground(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "OLX CLONE",
            style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: "Signatra"),
          ),
          SizedBox(
            height: size.height * 0.05,
          ),
          Image.asset(
            "assets/icons/chat.png",
            width: size.height * 0.4,
          ),
          RoundedButton(
              text: "Login",
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              }),
          RoundedButton(
              text: "Signup",
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignupScreen()));
              }),
        ],
      ),
    ));
  }
}
