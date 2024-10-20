import 'package:flutter/material.dart';
import 'package:olx_app/LoginScreen/login_background.dart';
import 'package:olx_app/LoginScreen/login_body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LoginBody());
  }
}
