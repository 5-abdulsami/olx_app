import 'package:flutter/material.dart';

class SearchProduct extends StatefulWidget {
  const SearchProduct({super.key});

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  final searchController = TextEditingController();
  String searchText = '';
  bool _isSearching = false;

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

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            if (searchController == null || searchController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }
    return [
      IconButton(onPressed: () {}, icon: Icon(Icons.search)),
    ];
  }

  _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  _stopSearching() {
    _clearSearchQuery();
    setState(() {
      _isSearching = false;
    });
  }

  _clearSearchQuery() {
    setState(() {
      searchController.clear();
      updateSearchText('');
    });
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
