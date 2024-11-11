import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx_app/HomeScreen/home_screen.dart';
import 'package:olx_app/Widgets/listview_widget.dart';
import 'package:olx_app/global_variables.dart';

class ProfileScreen extends StatefulWidget {
  final String sellerId;
  const ProfileScreen({super.key, required this.sellerId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  _buildBackButton() {
    return IconButton(
        onPressed: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        },
        icon: Icon(Icons.arrow_back));
  }

  _buildUserImage() {
    return Container(
      width: 50,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            image: NetworkImage(adUserImageUrl), fit: BoxFit.fill),
      ),
    );
  }

  getResult() {
    FirebaseFirestore.instance
        .collection("items")
        .where('id', isEqualTo: widget.sellerId)
        .where('status', isEqualTo: 'approved')
        .get()
        .then((result) {
      setState(() {
        items = result;
        adUserName = items!.docs[0].get('userName');
        adUserImageUrl = items!.docs[0].get("userImage");
      });
    });
  }

  QuerySnapshot? items;

  @override
  void initState() {
    super.initState();
    getResult();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.teal),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: _buildBackButton(),
          title: Row(
            children: [
              _buildUserImage(),
              SizedBox(width: 10),
              Text(
                adUserName,
                style: TextStyle(
                    color: Colors.black, fontFamily: 'Signatara', fontSize: 30),
              ),
            ],
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(color: Colors.teal),
          ),
          automaticallyImplyLeading: false,
          actions: const [],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('items')
                .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.data!.docs.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return ListViewWidget(
                        postId: snapshot.data!.docs[index]['postId'],
                        docId: snapshot.data!.docs[index].id,
                        userImg: snapshot.data!.docs[index]['userImageUrl'],
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
                  return Center(child: Text("No data found"));
                }
              }
            }),
      ),
    );
  }
}
