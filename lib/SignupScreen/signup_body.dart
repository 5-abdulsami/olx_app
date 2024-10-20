import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx_app/SignupScreen/signup_background.dart';

class SignupBody extends StatefulWidget {
  const SignupBody({super.key});

  @override
  State<SignupBody> createState() => _SingupBodyState();
}

class _SingupBodyState extends State<SignupBody> {
  XFile? _image;
  final signupFormKey = GlobalKey<FormState>();

  pickCameraImage() async {
    XFile? _pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(_pickedImage!.path);
    setState(() {
      _image = _pickedImage;
    });
    Navigator.of(context).pop();
  }

  void pickGalleryImage() async {
    XFile? _pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(_pickedImage!.path);
    setState(() {
      _image = _pickedImage;
    });
    Navigator.of(context).pop();
  }

  void _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper()
        .cropImage(sourcePath: filePath, maxHeight: 1080, maxWidth: 1080);
    if (croppedImage != null) {
      setState(() {
        _image = XFile(croppedImage.path);
      });
    }
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
                onTap: () {},
                child: CircleAvatar(
                  radius: screenWidth * 0.20,
                  backgroundColor: Colors.white,
                  backgroundImage: _image == null ? null : FileImage(_image!),
                  child: _image == null
                      ? Icon(
                          Icons.camera_enhance,
                          size: screenWidth * 0.18,
                          color: Colors.black,
                        )
                      : null,
                ),
              )),
        ],
      ),
    ));
  }
}
