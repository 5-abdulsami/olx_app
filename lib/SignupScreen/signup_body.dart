import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx_app/ForgotPassword/forgot_password.dart';
import 'package:olx_app/HomeScreen/home_screen.dart';
import 'package:olx_app/LoginScreen/login_screen.dart';
import 'package:olx_app/SignupScreen/signup_background.dart';
import 'package:olx_app/Widgets/already_have_account.dart';
import 'package:olx_app/AlertDialog/error_alert_dialog.dart';
import 'package:olx_app/Widgets/rounded_button.dart';
import 'package:olx_app/Widgets/rounded_input_field.dart';
import 'package:olx_app/Widgets/rounded_password_field.dart';
import 'package:olx_app/global_variables.dart';

class SignupBody extends StatefulWidget {
  const SignupBody({super.key});

  @override
  State<SignupBody> createState() => _SingupBodyState();
}

class _SingupBodyState extends State<SignupBody> {
  String userPhotoUrl = '';
  bool _isLoading = false;
  File? _image;
  final signupFormKey = GlobalKey<FormState>();

  pickCameraImage() async {
    XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    cropImage(pickedImage!.path);

    Navigator.of(context).pop();
  }

  void pickGalleryImage() async {
    XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    cropImage(pickedImage!.path);

    Navigator.pop(context);
  }

  void cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper()
        .cropImage(sourcePath: filePath, maxHeight: 1080, maxWidth: 1080);
    if (croppedImage != null) {
      setState(() {
        _image = File(croppedImage.path);
      });
    }
  }

  void showImageDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Please choose an option"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    pickCameraImage();
                  },
                  child: const Row(children: [
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.camera,
                        color: Colors.purple,
                      ),
                    ),
                    Text(
                      "Camera",
                      style: TextStyle(
                        color: Colors.purple,
                      ),
                    )
                  ]),
                ),
                InkWell(
                  onTap: () {
                    pickGalleryImage();
                  },
                  child: const Row(children: [
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.photo,
                        color: Colors.purple,
                      ),
                    ),
                    Text(
                      "Gallery",
                      style: TextStyle(
                        color: Colors.purple,
                      ),
                    )
                  ]),
                ),
              ],
            ),
          );
        });
  }

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  submitFormOnSignup() async {
    final isValid = signupFormKey.currentState!.validate();
    if (isValid) {
      if (_image == null) {
        showDialog(
            context: context,
            builder: (context) {
              return const ErrorAlertDialog(message: "Please select an image");
            });
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim().toLowerCase(),
          password: _passwordController.text,
        );

        final User? user = _auth.currentUser;
        uid = user!.uid;

        // to store user images
        final ref = FirebaseStorage.instance
            .ref()
            .child('userImages')
            .child('$uid.jpg');
        await ref.putFile(_image!);
        userPhotoUrl = await ref.getDownloadURL();

        // firestore
        FirebaseFirestore.instance.collection('users').doc(uid).set({
          'id': uid,
          'userName': _nameController.text.trim(),
          'userNumber': _phoneController.text.trim(),
          'userEmail': _emailController.text.trim(),
          'userImage': userPhotoUrl,
          'timestamp': DateTime.now(),
          'status': 'approved',
        });

        // navigate to homescreen after user creation
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      } catch (e) {
        print(e.toString());
        setState(() {
          _isLoading = false;
        });
        ErrorAlertDialog(message: e.toString());
      }
      // signupFormKey.currentState!.save();
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return SignupBackground(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
              key: signupFormKey,
              child: InkWell(
                onTap: () {
                  showImageDialog();
                },
                child: CircleAvatar(
                  radius: screenWidth * 0.20,
                  backgroundColor: Colors.white,
                  backgroundImage:
                      _image == null ? null : FileImage(File(_image!.path)),
                  child: _image == null
                      ? Icon(
                          Icons.camera_enhance,
                          size: screenWidth * 0.18,
                          color: Colors.black,
                        )
                      : null,
                ),
              )),
          SizedBox(height: screenHeight * 0.02),
          RoundedInputField(
            hintText: "Name",
            icon: Icons.person,
            onChanged: (value) {
              _nameController.text = value;
            },
          ),
          RoundedInputField(
            hintText: "Email",
            icon: Icons.email,
            onChanged: (value) {
              _emailController.text = value;
            },
          ),
          RoundedInputField(
            hintText: "Phone Number",
            icon: Icons.phone,
            onChanged: (value) {
              _phoneController.text = value;
            },
          ),
          RoundedPasswordField(
            onChanged: (value) {
              _passwordController.text = value;
            },
          ),
          SizedBox(height: screenHeight * 0.02),
          Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ForgotPassword()));
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontStyle: FontStyle.italic),
                  ))),
          _isLoading
              ? const SizedBox(
                  height: 70, width: 70, child: CircularProgressIndicator())
              : RoundedButton(
                  onPressed: () {
                    submitFormOnSignup();
                  },
                  text: "SIGN UP"),
          SizedBox(height: screenHeight * 0.02),
          AlreadyHaveAccount(
              login: false,
              onPress: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()));
              }),
        ],
      ),
    ));
  }
}
