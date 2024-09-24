import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http;

import 'detailed_screen.dart'; // For API calls

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List shows = [];
  TextEditingController _searchController = TextEditingController();
  bool isLoading = false;

  // Function to fetch search results from the API
  Future<void> fetchShows(String searchTerm) async {
    setState(() {
      isLoading = true; // Show loading spinner while fetching data
    });

    final url = Uri.parse('https://api.tvmaze.com/search/shows?q=$searchTerm');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        shows = data;
        isLoading = false; // Hide loading spinner when data is fetched
      });
    } else {
      setState(() {
        isLoading = false; // Hide loading spinner if the request fails
      });
      throw Exception('Failed to load shows');
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (_searchController.text.isNotEmpty) {
        fetchShows(_searchController.text); // Fetch results as the user types
      } else {
        setState(() {
          shows = []; // Clear results when search is empty
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose controller when no longer needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search TV Shows'),
        backgroundColor: Colors.black, // Netflix-like black background
      ),
      body: Column(
        children: [
          // Search bar similar to Netflix
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for shows...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                filled: true,
                fillColor: Colors.grey[850], // Netflix-like search background color
              ),
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white, // White cursor like Netflix
            ),
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator()) // Show loader while fetching
              : Expanded(
            child: shows.isEmpty && _searchController.text.isNotEmpty
                ? const Center(child: Text('No results found', style: TextStyle(color: Colors.white)))
                : shows.isEmpty && _searchController.text.isEmpty
                ? const Center(child: Text('Search Your Favourite Shows...', style: TextStyle(color: Colors.white)))
                : ListView.builder(
              itemCount: shows.length,
              itemBuilder: (context, index) {
                final show = shows[index]['show'];
                final imageUrl = show['image'] != null
                    ? show['image']['medium']
                    : 'https://via.placeholder.com/210x295'; // Placeholder if no image available
                final showName = show['name'] ?? 'No Name';
                final showSummary = show['summary'] ?? 'No summary available';

                return Card(
                  color: Colors.grey[900], // Dark card background
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailedScreen(show: show),
                        ),
                      );
                    },
                    leading: Image.network(imageUrl, fit: BoxFit.cover),
                    title: Text(
                      showName,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      showSummary.replaceAll(RegExp(r'<[^>]*>'), ''), // Remove HTML tags from summary
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black, // Netflix-like black background
    );
  }
}
