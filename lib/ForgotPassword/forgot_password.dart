import 'package:flutter/material.dart';
import 'package:olx_app/ForgotPassword/forgot_password_background.dart';
import 'package:olx_app/ForgotPassword/forgot_password_body.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ForgotPasswordBody(),
    );
  }
}
