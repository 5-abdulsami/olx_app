import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:olx_app/ImageSliderScreen/image_slider_screen.dart';
import 'package:olx_app/global_variables.dart';

class ListViewWidget extends StatefulWidget {
  final String docId,
      itemColor,
      img1,
      img2,
      img3,
      img4,
      img5,
      userImg,
      name,
      userId,
      postId,
      itemModel;
  final String itemPrice, description, address, userNumber;
  final DateTime date;
  final double lat, lng;

  const ListViewWidget({
    super.key,
    required this.docId,
    required this.itemColor,
    required this.img1,
    required this.img2,
    required this.img3,
    required this.img4,
    required this.img5,
    required this.userImg,
    required this.name,
    required this.userId,
    required this.postId,
    required this.itemModel,
    required this.itemPrice,
    required this.description,
    required this.address,
    required this.userNumber,
    required this.date,
    required this.lat,
    required this.lng,
  });

  @override
  State<ListViewWidget> createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<ListViewWidget> {
  Future showDialogForUpdateData(
      selectedDoc,
      oldUsername,
      oldItemColor,
      oldItemPrice,
      oldItemName,
      oldDescription,
      oldAddress,
      oldPhoneNumber) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return SingleChildScrollView(
              child: AlertDialog(
            title: const Text(
              "Update Data",
              style: TextStyle(
                  fontSize: 24, fontFamily: "Bebas", letterSpacing: 2),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: oldUsername,
                  decoration: const InputDecoration(
                    labelText: "Username",
                  ),
                  onChanged: (value) {
                    oldUsername = value;
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  initialValue: oldPhoneNumber,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                  ),
                  onChanged: (value) {
                    setState(() {
                      oldPhoneNumber = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  initialValue: oldItemPrice,
                  decoration: const InputDecoration(
                    labelText: "Enter your item price",
                  ),
                  onChanged: (value) {
                    setState(() {
                      oldItemPrice = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  initialValue: oldItemName,
                  decoration: const InputDecoration(
                    labelText: "Enter your item name",
                  ),
                  onChanged: (value) {
                    setState(() {
                      oldItemName = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  initialValue: oldItemColor,
                  decoration: const InputDecoration(
                    labelText: "Enter your item color",
                  ),
                  onChanged: (value) {
                    setState(() {
                      oldItemColor = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  initialValue: oldDescription,
                  decoration: const InputDecoration(
                    labelText: "Enter your item description",
                  ),
                  onChanged: (value) {
                    setState(() {
                      oldDescription = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  updateProfileNameOnExistingPosts(oldUsername);
                  _updateUserName(oldUsername, oldPhoneNumber);

                  FirebaseFirestore.instance
                      .collection("items")
                      .doc(selectedDoc)
                      .update({
                    'userName': oldUsername,
                    'userNumber': oldPhoneNumber,
                    'itemPrice': oldItemPrice,
                    'itemName': oldItemName,
                    'itemColor': oldItemColor,
                    'description': oldDescription,
                  }).catchError((e) {
                    print(e.toString());
                  });
                  Fluttertoast.showToast(
                      msg: "The task has been updated",
                      toastLength: Toast.LENGTH_SHORT,
                      backgroundColor: Colors.grey,
                      fontSize: 18);
                },
                child: const Text("Update"),
              ),
            ],
          ));
        });
  }

  updateProfileNameOnExistingPosts(oldUsername) async {
    await FirebaseFirestore.instance
        .collection("items")
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) {
      for (int i = 0; i < snapshot.docs.length; i++) {
        String userProfileNameInPost = snapshot.docs[i]['userName'];
        if (userProfileNameInPost != oldUsername) {
          FirebaseFirestore.instance
              .collection("items")
              .doc(snapshot.docs[i].id)
              .update({"userName": oldUsername});
        }
      }
    });
  }

  Future _updateUserName(oldUsername, oldPhoneNumber) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'userName': oldUsername,
      'userNumber': oldPhoneNumber,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        elevation: 16,
        shadowColor: Colors.white10,
        child: Container(
          color: Colors.teal,
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onDoubleTap: () {
                  // for image slider screen
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageSliderScreen(
                              title: widget.itemModel,
                              urlImg1: widget.img1,
                              urlImg2: widget.img2,
                              urlImg3: widget.img3,
                              urlImg4: widget.img4,
                              urlImg5: widget.img5,
                              itemColor: widget.itemColor,
                              itemPrice: widget.itemPrice,
                              description: widget.description,
                              address: widget.address,
                              userNumber: widget.userNumber,
                              lat: widget.lat,
                              lng: widget.lng)));
                },
                child: Image.network(
                  widget.img1,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(widget.userImg),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.itemModel,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          DateFormat('dd MMM, yyyy - hh:mm a')
                              .format(widget.date)
                              .toString(),
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
                    widget.userId == uid
                        ? Padding(
                            padding: EdgeInsets.only(right: 50),
                            child: Column(
                              children: [],
                            ))
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    showDialogForUpdateData(
                                        widget.docId,
                                        widget.name,
                                        widget.itemColor,
                                        widget.itemPrice,
                                        widget.itemModel,
                                        widget.description,
                                        widget.address,
                                        widget.userNumber);
                                  },
                                  icon: Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 27,
                                    ),
                                  )),
                              IconButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('items')
                                        .doc(widget.postId)
                                        .delete();
                                    Fluttertoast.showToast(
                                        msg: "Post has been deleted",
                                        toastLength: Toast.LENGTH_SHORT,
                                        backgroundColor: Colors.grey,
                                        fontSize: 18);
                                  },
                                  icon: Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  )),
                            ],
                          )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
