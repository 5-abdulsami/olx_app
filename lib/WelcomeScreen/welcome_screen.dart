import 'package:flutter/material.dart';
import 'package:olx_app/WelcomeScreen/welcome_body.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Welcome Screen"),
        ),
        body: WelcomeBody());
  }
}
