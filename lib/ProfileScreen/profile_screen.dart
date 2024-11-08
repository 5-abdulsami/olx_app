import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile Screen",
          style: TextStyle(
              color: Colors.black, fontFamily: 'Signatara', fontSize: 30),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Colors.teal),
        ),
        automaticallyImplyLeading: false,
        actions: const [],
      ),
    );
  }
}
