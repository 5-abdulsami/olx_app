import 'package:flutter/material.dart';

class SearchProduct extends StatefulWidget {
  const SearchProduct({super.key});

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search Product Screen",
          style: TextStyle(
              fontSize: 30, fontFamily: 'Signatra', color: Colors.black),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(color: Colors.teal),
        ),
        actions: [],
      ),
    );
  }
}
