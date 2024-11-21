import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:olx_app/LoginScreen/login_screen.dart';
import 'package:olx_app/ProfileScreen/profile_screen.dart';
import 'package:olx_app/SearchProduct/search_product.dart';
import 'package:olx_app/UploadAdScreen/upload_ad_screen.dart';
import 'package:olx_app/Widgets/listview_widget.dart';
import 'package:olx_app/global_variables.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  getMyData() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((result) {
      setState(() {
        userImageUrl = result.data()!['userImage'];
        getUserName = result.data()!['userName'];
      });
    });
  }

  getUserAddress() async {
    var status = await Permission.location.request();

    if (status.isDenied) {
      status = await Permission.location.request();
    }

    if (status.isPermanentlyDenied) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Location Permission Needed"),
              content: const Text(
                  "This app needs location access to fetch your current location."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    openAppSettings();
                    Navigator.pop(context);
                  },
                  child: const Text("Open Settings"),
                ),
              ],
            );
          });
    }

    if (status.isGranted) {
      try {
        Position newPosition = await Geolocator.getCurrentPosition(
          locationSettings:
              const LocationSettings(accuracy: LocationAccuracy.high),
        );

        position = newPosition;
        placemarks = await placemarkFromCoordinates(
            position!.latitude, position!.longitude);

        Placemark placemark = placemarks![0];

        String newCompleteAddress =
            '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.locality}, '
            '${placemark.subAdministrativeArea}, ${placemark.postalCode}, ${placemark.country}';

        completeAddress = newCompleteAddress;
        log("----------Address: $completeAddress");

        setState(() {});
      } catch (e) {
        log("----------Error fetching location: $e");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getUserAddress();
    uid = FirebaseAuth.instance.currentUser!.uid;
    userEmail = FirebaseAuth.instance.currentUser!.email!;
    getMyData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            "Home Screen",
            style: TextStyle(
                color: Colors.black, fontFamily: 'Signatra', fontSize: 30),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(color: Colors.teal),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                              sellerId: uid,
                            )));
              },
              icon: const Icon(
                Icons.person,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchProduct()));
              },
              icon: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                _auth.signOut().then((value) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                });
              },
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('items')
              .orderBy("date", descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                return ListView.builder(
                  controller: _scrollController, // Attach ScrollController
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ListViewWidget(
                      postId: snapshot.data!.docs[index]['postId'],
                      docId: snapshot.data!.docs[index].id,
                      userImage: snapshot.data!.docs[index]['userImage'],
                      name: snapshot.data!.docs[index]['userName'],
                      userId: snapshot.data!.docs[index]['id'],
                      itemModel: snapshot.data!.docs[index]['itemModel'],
                      itemColor: snapshot.data!.docs[index]['itemColor'],
                      itemPrice: snapshot.data!.docs[index]['itemPrice'],
                      description: snapshot.data!.docs[index]['description'],
                      address: snapshot.data!.docs[index]['address'],
                      userNumber: snapshot.data!.docs[index]['userNumber'],
                      date: snapshot.data!.docs[index]['date'].toDate(),
                      lat: snapshot.data!.docs[index]['lat'],
                      long: snapshot.data!.docs[index]['long'],
                      img1: snapshot.data!.docs[index]['urlImage1'],
                      img2: snapshot.data!.docs[index]['urlImage2'],
                      img3: snapshot.data!.docs[index]['urlImage3'],
                      img4: snapshot.data!.docs[index]['urlImage4'],
                      img5: snapshot.data!.docs[index]['urlImage5'],
                    );
                  },
                );
              } else {
                return const Center(child: Text("No data found"));
              }
            } else {
              return const Center(child: Text("Something went wrong"));
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UploadAdScreen()));
          },
          tooltip: "Add Post",
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
