import 'package:flutter/material.dart';

class WelcomeBackground extends StatelessWidget {
  final Widget child;

  const WelcomeBackground({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.teal),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "assets/images/main_top.png",
              color: Colors.deepPurple,
              width: size.width * 0.3,
            ),
          ),
          Positioned(
              bottom: 0,
              right: 0,
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
