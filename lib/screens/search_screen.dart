import 'package:flutter/material.dart';
import 'package:khmer_cultur_app/widgets/search_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];

  final List<String> _items = [
    "Pizza",
    "Burger",
    "Khmer Food",
    "Thai Food",
    "Chinese Food",
    "Fast Food",
  ];

  void _onSearchChanged(String query) {
    setState(() {
      _searchResults = _items
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _onClear() {
    setState(() {
      _searchResults.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, 
        elevation: 0,
        leading: IconButton(
          icon: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(Icons.chevron_left, size: 32, color: Colors.black),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Search", style: TextStyle(fontSize: 16)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            SearchWidget(
              controller: _searchController,
              hintText: "Search dishes, restaurants",
              onChanged: _onSearchChanged,
              onClear: _onClear,
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}