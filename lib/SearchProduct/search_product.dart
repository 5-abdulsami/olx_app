import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:olx_app/HomeScreen/home_screen.dart';
import 'package:olx_app/Widgets/listview_widget.dart';

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
            if (searchController.text.isEmpty) {
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
      decoration: const BoxDecoration(color: Colors.teal),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          actions: _buildActions(),
          leading: _isSearching ? BackButton() : _buildBackButton(),
          backgroundColor: Colors.teal,
          title: _isSearching ? _buildSearchBar() : _buildTitle(context),
          flexibleSpace: Container(
            decoration: const BoxDecoration(color: Colors.teal),
          ),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('items')
                .where('itemModel',
                    isGreaterThanOrEqualTo: searchController.text.trim())
                .where('status', isEqualTo: 'approved')
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
              }
            }),
      ),
    );
  }
}
