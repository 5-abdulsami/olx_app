import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

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
  final DateTime dateTime;
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
    required this.dateTime,
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
            title: Text(
              "Update Data",
              style: TextStyle(
                  fontSize: 24, fontFamily: "Bebas", letterSpacing: 2),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: oldUsername,
                  decoration: InputDecoration(
                    labelText: "Username",
                  ),
                  onChanged: (value) {
                    oldUsername = value;
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  initialValue: oldPhoneNumber,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                  ),
                  onChanged: (value) {
                    setState(() {
                      oldPhoneNumber = value;
                    });
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  initialValue: oldItemPrice,
                  decoration: InputDecoration(
                    labelText: "Enter your item price",
                  ),
                  onChanged: (value) {
                    setState(() {
                      oldItemPrice = value;
                    });
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  initialValue: oldItemName,
                  decoration: InputDecoration(
                    labelText: "Enter your item name",
                  ),
                  onChanged: (value) {
                    setState(() {
                      oldItemName = value;
                    });
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  initialValue: oldItemColor,
                  decoration: InputDecoration(
                    labelText: "Enter your item color",
                  ),
                  onChanged: (value) {
                    setState(() {
                      oldItemColor = value;
                    });
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  initialValue: oldDescription,
                  decoration: InputDecoration(
                    labelText: "Enter your item description",
                  ),
                  onChanged: (value) {
                    setState(() {
                      oldDescription = value;
                    });
                  },
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
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
                child: Text("Update"),
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
      padding: EdgeInsets.all(8),
      child: Card(
        elevation: 16,
        shadowColor: Colors.white10,
        child: Container(
          color: Colors.teal,
          padding: EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onDoubleTap: () {
                  // for image slider screen
                },
                child: Image.network(
                  widget.img1,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
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
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.itemModel,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          DateFormat('dd MMM, yyyy - hh:mm a')
                              .format(widget.dateTime)
                              .toString(),
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
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
