import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx_app/global_variables.dart';
import 'package:path/path.dart' as Path;

class UploadAdScreen extends StatefulWidget {
  const UploadAdScreen({super.key});

  @override
  State<UploadAdScreen> createState() => _UploadAdScreenState();
}

class _UploadAdScreenState extends State<UploadAdScreen> {
  bool next = false, uploading = false;
  final List<File> _images = [];
  final List<String> _imageUrls = [];
  double val = 0;
  String name = '';
  String phoneNumber = '';

  CollectionReference? imageRef;

  chooseImage() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _images.add(File(pickedFile!.path));
    });
  }

  Future uploadImages() async {
    int i = 1;

    for (var image in _images) {
      setState(() {
        val = i / _images.length;
      });

      var ref = FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(image.path)}');

      await ref.putFile(image).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          _imageUrls.add(value);
          i++;
        });
      });
    }
  }

  getNameOfUser() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          name = snapshot.data()!['userName'];
          phoneNumber = snapshot.data()!['userNumber'];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getNameOfUser();
    imageRef = FirebaseFirestore.instance.collection('imageUrls');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            next ? "Please Write Item\'s info" : "Choose Item Images",
            style: TextStyle(
                color: Colors.black, fontFamily: 'Signatra', fontSize: 30),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(color: Colors.teal),
          ),
          actions: [
            next
                ? Container()
                : ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "Next",
                      style: TextStyle(
                          fontSize: 19,
                          color: Colors.black,
                          fontFamily: 'Bebas'),
                    ))
          ],
        ),
        body: next
            ? SingleChildScrollView()
            : Stack(
                children: [
                  Container(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        return index == 0
                            ? Center(
                                child: IconButton(
                                    onPressed: () {
                                      !uploading ? chooseImage() : null;
                                    },
                                    icon: Icon(Icons.add)),
                              )
                            : Container(
                                margin: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: FileImage(_images[index - 1],
                                            scale: 1.0),
                                        fit: BoxFit.cover)),
                              );
                      },
                      itemCount: _images.length + 1,
                    ),
                  ),
                  uploading
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Uploading",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CircularProgressIndicator(
                                value: val,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.green),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
      ),
    );
  }
}
