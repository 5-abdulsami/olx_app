import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:olx_app/LoginScreen/login_screen.dart';
import 'package:olx_app/ProfileScreen/profile_screen.dart';
import 'package:olx_app/SearchProduct/search_product.dart';
import 'package:olx_app/UploadAdScreen/upload_ad_screen.dart';
import 'package:olx_app/global_variables.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;

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
    Position newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    position = newPosition;
    placemarks =
        await placemarkFromCoordinates(position!.latitude, position!.longitude);

    Placemark placemark = placemarks![0];

    String newCompleteAddress =
        '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subThoroughfare} ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.postalCode}, ${placemark.country}';

    completeAddress = newCompleteAddress;
    print(completeAddress);

    return completeAddress;
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserAddress();
    super.initState();
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
          title: Text(
            "Home Screen",
            style: TextStyle(
                color: Colors.black, fontFamily: 'Signatra', fontSize: 30),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(color: Colors.teal),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
              icon: Icon(
                Icons.person,
                color: Colors.black,
              ),
            ),
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SearchProduct()));
                },
                icon: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                )),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                _auth.signOut().then((value) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                });
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => UploadAdScreen()));
          },
          child: Icon(Icons.add),
          tooltip: "Add Post ",
        ),
      ),
    );
  }
}
