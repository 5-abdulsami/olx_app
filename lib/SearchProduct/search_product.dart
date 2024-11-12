import 'package:flutter/material.dart';
import 'package:olx_app/HomeScreen/home_screen.dart';

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

  _buildTitle(BuildContext context) {
    return Text('Search Product');
  }

  _buildBackButton() {
    return IconButton(
        onPressed: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.teal),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: _isSearching ? BackButton() : _buildBackButton(),
          backgroundColor: Colors.teal,
          title: _isSearching ? _buildSearchBar() : _buildTitle(context),
          flexibleSpace: Container(
            decoration: const BoxDecoration(color: Colors.teal),
          ),
          actions: const [],
        ),
      ),
    );
  }
}
