import 'package:flutter/material.dart';
import 'detailed_screen.dart'; // Importing DetailedScreen

class ShowList extends StatelessWidget {
  final List shows;

  const ShowList({Key? key, required this.shows}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return shows.isEmpty
        ? const Center(child: Text("No shows available"))
        : Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 200,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: shows.map((showData) {
              final show = showData['show'];
              final imageUrl = show['image'] != null
                  ? show['image']['medium']
                  : 'https://via.placeholder.com/210x295';
              final showName = show['name'] ?? 'No Name';

              return Container(
                width: 160, // Set a fixed width for each card
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () {
                    // Navigate to the detailed screen and pass show data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailedScreen(show: show),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.grey[850], // Dark card background
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10)),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            showName,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white), // White text color
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
