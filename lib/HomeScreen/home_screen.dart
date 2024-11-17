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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
    // Get user's current location and address
    getUserAddress();
    // Call parent class initState
    super.initState();
    // Get current user's ID from Firebase Auth
    uid = FirebaseAuth.instance.currentUser!.uid;
    // Get current user's email from Firebase Auth
    userEmail = FirebaseAuth.instance.currentUser!.email!;
    // Fetch user data (image URL and username) from Firestore
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
                Navigator.pushReplacement(
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
                  Navigator.pushReplacement(
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
                )),
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
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.data!.docs.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return ListViewWidget(
                        postId: snapshot.data!.docs[index]['postId'],
                        docId: snapshot.data!.docs[index].id,
                        userImage: snapshot.data!.docs[index]['userImage'],
                        name: snapshot.data!.docs[index]['userName'],
                        userId: snapshot.data!.docs[index]['userId'],
                        itemModel: snapshot.data!.docs[index]['itemModel'],
                        itemColor: snapshot.data!.docs[index]['itemColor'],
                        itemPrice: snapshot.data!.docs[index]['itemPrice'],
                        description: snapshot.data!.docs[index]['description'],
                        address: snapshot.data!.docs[index]['address'],
                        userNumber: snapshot.data!.docs[index]['userNumber'],
                        date: snapshot.data!.docs[index]['date'].toDate(),
                        lat: snapshot.data!.docs[index]['lat'],
                        lng: snapshot.data!.docs[index]['lng'],
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
              }
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const UploadAdScreen()));
          },
          tooltip: "Add Post ",
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
