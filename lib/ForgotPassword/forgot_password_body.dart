import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx_app/AlertDialog/error_alert_dialog.dart';
import 'package:olx_app/ForgotPassword/forgot_password_background.dart';
import 'package:olx_app/LoginScreen/login_screen.dart';

class ForgotPasswordBody extends StatefulWidget {
  const ForgotPasswordBody({super.key});

  @override
  State<ForgotPasswordBody> createState() => _ForgotPasswordBodyState();
}

class _ForgotPasswordBodyState extends State<ForgotPasswordBody> {
  final _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  _forgotPasswordSubmitForm() async {
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    } catch (e) {
      ErrorAlertDialog(
        message: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ForgotPasswordBackground(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(40),
            child: ListView(
              children: [
                SizedBox(height: size.height * 0.02),
                const Text(
                  'Forgot Password',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 55,
                      fontFamily: 'Bebas'),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                const Text(
                  'Enter your email and we\'ll send you a link to reset your password.',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontStyle: FontStyle.italic),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.black38,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white))),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                MaterialButton(
                  onPressed: () {
                    _forgotPasswordSubmitForm();
                  },
                  color: Colors.black,
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      'Reset Now',
                      style: TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
