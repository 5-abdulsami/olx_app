import 'package:flutter/material.dart';

class SearchProduct extends StatefulWidget {
  const SearchProduct({super.key});

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  final searchController = TextEditingController();
  String searchText = '';

  updateSearchText(String text) {
    setState(() {
      searchText = text;
    });
  }

  Widget _buildSearchBar() {
    return Container(
      child: TextField(
        onChanged: (value) => updateSearchText(value),
        controller: searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: "Search for products",
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.teal),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text(
            "Search Product Screen",
            style: TextStyle(
                fontSize: 30, fontFamily: 'Signatra', color: Colors.black),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(color: Colors.teal),
          ),
          actions: const [],
        ),
      ),
    );
  }
}
