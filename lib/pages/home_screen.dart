import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart'; // Import the shimmer package
import 'show_list.dart'; // Importing ShowList class

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List shows = [];

  // Function to fetch data from the API
  Future<void> fetchShows() async {
    final url = Uri.parse('https://api.tvmaze.com/search/shows?q=all');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        shows = data;
      });
    } else {
      throw Exception('Failed to load shows');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchShows(); // Fetch data when the screen is initialized
  }

  // Home screen showing TV shows
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TV Shows"),
        backgroundColor: Colors.black, // Dark app bar
      ),
      body: shows.isEmpty
          ? _buildSkeletonLoader() // Show skeleton loader
          : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Text("Top Trending",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                      ),),
                  ],
                ),
              ),
              ShowList(shows: shows),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Text("Recommended to You",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                      ),),
                  ],
                ),
              ),
              ShowList(shows: shows),

            ],
          ), // Use the ShowList widget here
      backgroundColor: Colors.black, // Dark background for the entire screen
    );
  }

  // Method to build skeleton loader
  Widget _buildSkeletonLoader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5, // Number of skeleton items to show
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[700]!,
            highlightColor: Colors.grey[500]!,
            child: Container(
              width: 160, // Set a fixed width for each card
              height: 200, // Set height for each card
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                color: Colors.grey[850], // Dark card background
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  height: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                          child: Container(
                            color: Colors.grey[800], // Placeholder for image
                            // You can also use Image.network with a placeholder if you prefer
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 16, // Fixed height for the title
                          color: Colors.grey[700], // Placeholder for text
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
