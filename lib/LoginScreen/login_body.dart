import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx_app/AlertDialog/error_alert_dialog.dart';
import 'package:olx_app/AlertDialog/loading_alert_dialog.dart';
import 'package:olx_app/ForgotPassword/forgot_password.dart';
import 'package:olx_app/HomeScreen/home_screen.dart';
import 'package:olx_app/LoginScreen/login_background.dart';
import 'package:olx_app/SignupScreen/signup_screen.dart';
import 'package:olx_app/Widgets/already_have_account.dart';
import 'package:olx_app/Widgets/rounded_button.dart';
import 'package:olx_app/Widgets/rounded_input_field.dart';
import 'package:olx_app/Widgets/rounded_password_field.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  _login() async {
    showDialog(
        context: context,
        builder: (context) {
          return LoadingAlertDialog(
            message: "Please wait...",
          );
        });

    User? currentUser;

    await _auth
        .signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text)
        .then((auth) {
      currentUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(message: error.message.toString());
          });
    });

    if (currentUser != null) {
      Navigator.pop(context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      print("error creating user");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LoginBackground(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: size.height * 0.04,
          ),
          Image.asset(
            "assets/icons/login.png",
            height: size.height * 0.32,
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          RoundedInputField(
            hintText: "Email",
            icon: Icons.person,
            onChanged: (value) {
              _emailController.text = value;
            },
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          RoundedPasswordField(onChanged: (value) {
            _passwordController.text = value;
          }),
          SizedBox(
            height: size.height * 0.03,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPassword()));
                },
                child: Text(
                  "Forgot Password",
                  style: TextStyle(
                      color: Colors.teal,
                      fontSize: 15,
                      fontStyle: FontStyle.italic),
                )),
          ),
          RoundedButton(
              text: "LOGIN",
              onPressed: () {
                _emailController.text.isNotEmpty &&
                        _passwordController.text.isNotEmpty
                    ? _login()
                    : showDialog(
                        context: context,
                        builder: (context) => ErrorAlertDialog(
                            message: "Please provide your email and password"));
              }),
          SizedBox(
            height: size.height * 0.03,
          ),
          AlreadyHaveAccount(
              login: true,
              onPress: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignupScreen()));
              }),
        ],
      ),
    ));
  }
}
