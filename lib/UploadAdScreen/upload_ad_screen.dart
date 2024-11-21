import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx_app/AlertDialog/loading_alert_dialog.dart';
import 'package:olx_app/HomeScreen/home_screen.dart';
import 'package:olx_app/global_variables.dart';
import 'package:path/path.dart' as Path;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class UploadAdScreen extends StatefulWidget {
  const UploadAdScreen({super.key});

  @override
  State<UploadAdScreen> createState() => _UploadAdScreenState();
}

class _UploadAdScreenState extends State<UploadAdScreen> {
  String postId = const Uuid().v4();
  bool next = false, uploading = false;
  final List<File> _images = [];
  final List<String> urlsList = [];
  double val = 0;
  String name = '';
  String phoneNumber = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String itemPrice = '';
  String itemModel = '';
  String itemName = '';
  String itemColor = '';
  String description = '';

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
          urlsList.add(value);
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            next ? "Please Write Item's info" : "Choose Item Images",
            style: const TextStyle(
                color: Colors.black, fontFamily: 'Signatra', fontSize: 30),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(color: Colors.teal),
          ),
          actions: [
            next
                ? Container()
                : ElevatedButton(
                    onPressed: () {
                      if (_images.length == 5) {
                        setState(() {
                          uploading = true;
                          next = true;
                        });
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please Select 5 images",
                            gravity: ToastGravity.CENTER);
                      }
                    },
                    child: const Text(
                      "Next",
                      style: TextStyle(
                          fontSize: 19,
                          color: Colors.black,
                          fontFamily: 'Bebas'),
                    ))
          ],
        ),
        body: next
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Item Name',
                        ),
                        onChanged: (value) {
                          itemName = value;
                        },
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Item Price',
                        ),
                        onChanged: (value) {
                          itemPrice = value;
                        },
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Item Color',
                        ),
                        onChanged: (value) {
                          itemColor = value;
                        },
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Item Model',
                        ),
                        onChanged: (value) {
                          itemModel = value;
                        },
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Write some description about the item',
                        ),
                        onChanged: (value) {
                          description = value;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const LoadingAlertDialog(
                                        message: 'Uploading');
                                  });

                              uploadImages().whenComplete(() {
                                FirebaseFirestore.instance
                                    .collection('items')
                                    .doc(postId)
                                    .set({
                                  'id': _auth.currentUser!.uid,
                                  'postId': postId,
                                  'userName': name,
                                  'userNumber': phoneNumber,
                                  'itemPrice': itemPrice,
                                  'itemName': itemName,
                                  'itemColor': itemColor,
                                  'itemModel': itemModel,
                                  'description': description,
                                  'urlImage1': urlsList[0].toString(),
                                  'urlImage2': urlsList[1].toString(),
                                  'urlImage3': urlsList[2].toString(),
                                  'urlImage4': urlsList[3].toString(),
                                  'urlImage5': urlsList[4].toString(),
                                  'userImage': userImageUrl,
                                  'lat': position!.latitude,
                                  'long': position!.longitude,
                                  'address': completeAddress,
                                  'date': DateTime.now(),
                                  'status': 'approved'
                                });
                                Fluttertoast.showToast(
                                  msg: "Posted Successfully",
                                );
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen()));
                              }).catchError((error) {
                                log(error);
                              });
                            },
                            child: const Text(
                              'Upload',
                              style: TextStyle(color: Colors.black),
                            )),
                      ),
                    ],
                  ),
                ),
              )
            : Stack(
                children: [
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                    itemBuilder: (context, index) {
                      return index == 0
                          ? Center(
                              child: IconButton(
                                  onPressed: () {
                                    !uploading ? chooseImage() : null;
                                  },
                                  icon: const Icon(Icons.add)),
                            )
                          : Container(
                              margin: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: FileImage(_images[index - 1],
                                          scale: 1.0),
                                      fit: BoxFit.cover)),
                            );
                    },
                    itemCount: _images.length + 1,
                  ),
                  uploading
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Uploading",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CircularProgressIndicator(
                                value: val,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.green),
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
