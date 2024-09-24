import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http;
import 'package:quadb_tech_assignment/pages/show_list.dart';

class DetailedScreen extends StatefulWidget {
  final Map show; // Receiving show data

  const DetailedScreen({super.key, required this.show}); // Constructor to accept show data

  @override
  _DetailedScreenState createState() => _DetailedScreenState();
}

class _DetailedScreenState extends State<DetailedScreen> {
  List shows = []; // Initialize shows list

  @override
  void initState() {
    super.initState();
    fetchShows(); // Fetch data when the screen is initialized
  }

  // Function to fetch data from the API
  Future<void> fetchShows() async {
    final url = Uri.parse('https://api.tvmaze.com/search/shows?q=all');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        shows = data; // Update shows list with fetched data
      });
    } else {
      throw Exception('Failed to load shows');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String imageUrl = widget.show['image'] != null
        ? widget.show['image']['original']
        : 'https://via.placeholder.com/400x600';
    final String showName = widget.show['name'] ?? 'No Name';
    String summary = widget.show['summary'] ?? 'No summary available.';

    // Remove HTML tags from summary
    summary = _removeHtmlTags(summary);

    final List<String> genres = List<String>.from(widget.show['genres'] ?? []);
    final String language = widget.show['language'] ?? 'Unknown';
    final String status = widget.show['status'] ?? 'Unknown';
    final double runtime = (widget.show['runtime'] ?? 0).toDouble();
    final double averageRating = widget.show['rating']['average'] ?? 0.0;
    final String networkName =
    widget.show['network'] != null ? widget.show['network']['name'] : 'N/A';
    final String premiereDate = widget.show['premiered'] ?? 'Unknown';

    return WillPopScope(
      onWillPop: () async {
        // You can perform additional logic here if needed before popping
        return true; // Return true to pop the screen
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(showName, style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    height: 300,
                    width: double.infinity,
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: ElevatedButton(
                      onPressed: () {
                        // Action for play button
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      child: const Text('Play', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Similar to $showName show",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              shows.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ShowList(shows: shows),
              ExpansionTile(
                title: const Text('Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                backgroundColor: Colors.grey[900],
                children: [
                  _buildInfoRow('Genres:', genres.join(', ')),
                  _buildInfoRow('Language:', language),
                  _buildInfoRow('Status:', status),
                  _buildInfoRow('Runtime:', '${runtime} min'),
                  _buildInfoRow('Average Rating:', averageRating.toStringAsFixed(1)),
                  _buildInfoRow('Premiered:', premiereDate),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      summary,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  _buildInfoRow('Network:', networkName),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        backgroundColor: Colors.black,
      ),
    );
  }

  // Helper method to create info rows with a title and value
  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  // Function to remove HTML tags from a string
  String _removeHtmlTags(String htmlString) {
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
    return htmlString.replaceAll(exp, '').trim();
  }
}
