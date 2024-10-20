import 'package:flutter/material.dart';

class SignupBackground extends StatelessWidget {
  final Widget child;
  const SignupBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(color: Colors.teal),
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              left: 0,
              top: 0,
              child: Image.asset(
                "assets/images/signup_top.png",
                color: Colors.deepPurple,
                width: size.width * 0.3,
              )),
          Positioned(
              left: 0,
              bottom: 0,
              child: Image.asset(
                "assets/images/main_bottom.png",
                color: Colors.deepPurple,
                width: size.width * 0.2,
              )),
          child,
        ],
      ),
    );
  }
}
